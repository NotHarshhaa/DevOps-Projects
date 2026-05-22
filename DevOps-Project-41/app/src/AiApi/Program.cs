using System.Diagnostics;
using AiApi;
using OpenTelemetry.Metrics;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;
using Prometheus;
using StackExchange.Redis;

var builder = WebApplication.CreateBuilder(args);

// Redis
var redisConnection = builder.Configuration["REDIS_CONNECTION_STRING"] ?? "localhost:6379";
builder.Services.AddSingleton<IConnectionMultiplexer>(_ => ConnectionMultiplexer.Connect(redisConnection));

// PostgreSQL repository
builder.Services.AddSingleton<JobRepository>();

// OpenTelemetry
var otelEndpoint = builder.Configuration["OTEL_EXPORTER_OTLP_ENDPOINT"];
builder.Services.AddOpenTelemetry()
    .ConfigureResource(r => r.AddService("ai-api"))
    .WithTracing(t =>
    {
        t.AddAspNetCoreInstrumentation()
         .AddHttpClientInstrumentation();
        if (!string.IsNullOrEmpty(otelEndpoint))
            t.AddOtlpExporter(o => o.Endpoint = new Uri(otelEndpoint));
    })
    .WithMetrics(m =>
    {
        m.AddAspNetCoreInstrumentation()
         .AddRuntimeInstrumentation();
        if (!string.IsNullOrEmpty(otelEndpoint))
            m.AddOtlpExporter(o => o.Endpoint = new Uri(otelEndpoint));
    });

var app = builder.Build();

// Ensure DB schema on startup
using (var scope = app.Services.CreateScope())
{
    var repo = scope.ServiceProvider.GetRequiredService<JobRepository>();
    try { await repo.EnsureSchemaAsync(); }
    catch (Exception ex) { app.Logger.LogWarning(ex, "Could not initialise DB schema — will retry on first request"); }
}

// Prometheus metrics endpoint
app.UseHttpMetrics();
app.MapMetrics("/metrics");

// Custom counters
var jobsCreated = Metrics.CreateCounter("ai_jobs_created_total", "Total AI jobs created");
var jobsFailed = Metrics.CreateCounter("ai_jobs_enqueue_failed_total", "Total jobs that failed to enqueue");

var activitySource = new ActivitySource("ai-api");

// GET /health
app.MapGet("/health", () => Results.Ok(new { status = "healthy", timestamp = DateTimeOffset.UtcNow }));

// GET /ready
app.MapGet("/ready", async (IConnectionMultiplexer redis, JobRepository repo) =>
{
    var redisOk = false;
    var pgOk = false;
    try { await redis.GetDatabase().PingAsync(); redisOk = true; } catch { }
    try { pgOk = await repo.CanConnectAsync(); } catch { }

    if (redisOk && pgOk)
        return Results.Ok(new { status = "ready", redis = "ok", postgres = "ok" });

    return Results.Json(
        new { status = "degraded", redis = redisOk ? "ok" : "unavailable", postgres = pgOk ? "ok" : "unavailable" },
        statusCode: 503);
});

// POST /ask
app.MapPost("/ask", async (AskRequest request, IConnectionMultiplexer redis, JobRepository repo, ILogger<Program> logger) =>
{
    if (string.IsNullOrWhiteSpace(request.Prompt))
        return Results.BadRequest(new { error = "prompt is required" });

    var jobId = Guid.NewGuid().ToString("N");

    using var activity = activitySource.StartActivity("http.post.ask");
    activity?.SetTag("job.id", jobId);
    activity?.SetTag("job.model", request.Model);

    try
    {
        await repo.InsertJobAsync(jobId, request.Prompt, request.Model);

        var db = redis.GetDatabase();
        var payload = System.Text.Json.JsonSerializer.Serialize(new { jobId, prompt = request.Prompt, model = request.Model });
        await db.ListLeftPushAsync("ai-jobs", payload);
        activity?.SetTag("queue.enqueued", true);

        jobsCreated.Inc();
        logger.LogInformation("Job {JobId} enqueued with model {Model}", jobId, request.Model);

        return Results.Accepted($"/jobs/{jobId}", new AskResponse(jobId, JobStatus.Queued));
    }
    catch (Exception ex)
    {
        jobsFailed.Inc();
        logger.LogError(ex, "Failed to enqueue job {JobId}", jobId);
        activity?.SetStatus(ActivityStatusCode.Error, ex.Message);
        return Results.Problem("Failed to enqueue job", statusCode: 500);
    }
});

// GET /jobs/{jobId}
app.MapGet("/jobs/{jobId}", async (string jobId, JobRepository repo) =>
{
    var job = await repo.GetJobAsync(jobId);
    return job is null ? Results.NotFound(new { error = "job not found" }) : Results.Ok(job);
});

app.Run();
