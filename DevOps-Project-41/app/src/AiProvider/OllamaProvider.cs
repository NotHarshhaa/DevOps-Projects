using System.Diagnostics;
using System.Net.Http.Json;
using Microsoft.Extensions.Logging;

namespace AiProvider;

public class OllamaProvider : IAiProvider
{
    private readonly HttpClient _http;
    private readonly ILogger<OllamaProvider> _logger;

    public string ProviderName => "ollama";

    public OllamaProvider(HttpClient http, ILogger<OllamaProvider> logger)
    {
        _http = http;
        _logger = logger;
    }

    public async Task<AiResponse> CompleteAsync(AiRequest request, CancellationToken cancellationToken = default)
    {
        var sw = Stopwatch.StartNew();

        _logger.LogInformation("Ollama processing job {JobId} with model {Model}", request.JobId, request.Model);

        var payload = new { model = request.Model, prompt = request.Prompt, stream = false };
        var response = await _http.PostAsJsonAsync("/api/generate", payload, cancellationToken);
        response.EnsureSuccessStatusCode();

        var result = await response.Content.ReadFromJsonAsync<OllamaResponse>(cancellationToken: cancellationToken);
        sw.Stop();

        return new AiResponse(request.JobId, result?.Response ?? string.Empty, request.Model, ProviderName, sw.ElapsedMilliseconds);
    }

    private record OllamaResponse(string Response);
}
