using System.Diagnostics;
using Microsoft.Extensions.Logging;

namespace AiProvider;

public class MockLlmProvider : IAiProvider
{
    private readonly ILogger<MockLlmProvider> _logger;

    private static readonly Dictionary<string, string> _responses = new(StringComparer.OrdinalIgnoreCase)
    {
        ["gitops"] = "GitOps is a practice where Git is the single source of truth for declarative infrastructure and application configuration. Changes are made via pull requests and automatically reconciled by operators like Argo CD.",
        ["kubernetes"] = "Kubernetes is an open-source container orchestration platform that automates deployment, scaling, and management of containerised applications across clusters.",
        ["devsecops"] = "DevSecOps integrates security practices into the DevOps pipeline, shifting security left so that vulnerabilities are detected early in development rather than post-deployment.",
        ["keda"] = "KEDA (Kubernetes Event-Driven Autoscaling) scales workloads based on external event sources such as queue lengths, HTTP requests, or custom metrics.",
        ["opentelemetry"] = "OpenTelemetry is a vendor-neutral observability framework for generating, collecting, and exporting traces, metrics, and logs from distributed systems.",
    };

    public string ProviderName => "mock";

    public MockLlmProvider(ILogger<MockLlmProvider> logger)
    {
        _logger = logger;
    }

    public async Task<AiResponse> CompleteAsync(AiRequest request, CancellationToken cancellationToken = default)
    {
        var sw = Stopwatch.StartNew();

        _logger.LogInformation("MockLLM processing job {JobId} with model {Model}", request.JobId, request.Model);

        await Task.Delay(Random.Shared.Next(100, 600), cancellationToken);

        var keyword = _responses.Keys.FirstOrDefault(k => request.Prompt.Contains(k, StringComparison.OrdinalIgnoreCase));
        var content = keyword is not null
            ? _responses[keyword]
            : $"[MockLLM] Received: \"{request.Prompt}\". This is a deterministic mock response for local testing. Configure AI_PROVIDER=ollama or AI_PROVIDER=openai-compatible to use a real model.";

        sw.Stop();

        return new AiResponse(request.JobId, content, request.Model, ProviderName, sw.ElapsedMilliseconds);
    }
}
