using System.Diagnostics;
using System.Text.Json;
using AiProvider;
using Prometheus;
using StackExchange.Redis;

namespace AiWorker;

public class Worker : BackgroundService
{
    private readonly ILogger<Worker> _logger;
    private readonly IConnectionMultiplexer _redis;
    private readonly IAiProvider _aiProvider;
    private readonly JobUpdater _jobUpdater;
    private readonly ActivitySource _activitySource = new("ai-worker");

    private static readonly Counter JobsCompleted = Metrics.CreateCounter("ai_jobs_completed_total", "Total jobs completed successfully");
    private static readonly Counter JobsFailed = Metrics.CreateCounter("ai_jobs_failed_total", "Total jobs failed");
    private static readonly Histogram JobDuration = Metrics.CreateHistogram("ai_job_duration_seconds", "AI job processing duration in seconds");
    private static readonly Gauge QueueDepth = Metrics.CreateGauge("ai_queue_depth", "Current Redis queue depth");

    public Worker(ILogger<Worker> logger, IConnectionMultiplexer redis, IAiProvider aiProvider, JobUpdater jobUpdater)
    {
        _logger = logger;
        _redis = redis;
        _aiProvider = aiProvider;
        _jobUpdater = jobUpdater;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("AI Worker started. Provider: {Provider}", _aiProvider.ProviderName);

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                var db = _redis.GetDatabase();
                var queueLen = await db.ListLengthAsync("ai-jobs");
                QueueDepth.Set(queueLen);

                var raw = await db.ListRightPopAsync("ai-jobs");
                if (raw.IsNullOrEmpty)
                {
                    await Task.Delay(1000, stoppingToken);
                    continue;
                }

                var job = JsonSerializer.Deserialize<JobMessage>(raw!);
                if (job is null) continue;

                await ProcessJobAsync(job, stoppingToken);
            }
            catch (OperationCanceledException) { break; }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error in worker loop");
                await Task.Delay(2000, stoppingToken);
            }
        }

        _logger.LogInformation("AI Worker stopped");
    }

    private async Task ProcessJobAsync(JobMessage job, CancellationToken ct)
    {
        using var activity = _activitySource.StartActivity("worker.process.job");
        activity?.SetTag("job.id", job.JobId);
        activity?.SetTag("job.model", job.Model);

        _logger.LogInformation("Processing job {JobId}", job.JobId);

        await _jobUpdater.MarkProcessingAsync(job.JobId);

        using var timer = JobDuration.NewTimer();
        try
        {
            var response = await _aiProvider.CompleteAsync(
                new AiRequest(job.Prompt, job.Model, job.JobId), ct);

            await _jobUpdater.MarkCompletedAsync(job.JobId, response.Content, response.Provider, response.DurationMs);
            JobsCompleted.Inc();

            activity?.SetTag("job.provider", response.Provider);
            activity?.SetTag("job.duration_ms", response.DurationMs);
            _logger.LogInformation("Job {JobId} completed in {DurationMs}ms", job.JobId, response.DurationMs);
        }
        catch (Exception ex)
        {
            await _jobUpdater.MarkFailedAsync(job.JobId, ex.Message);
            JobsFailed.Inc();
            activity?.SetStatus(ActivityStatusCode.Error, ex.Message);
            _logger.LogError(ex, "Job {JobId} failed", job.JobId);
        }
    }

    private record JobMessage(string JobId, string Prompt, string Model);
}
