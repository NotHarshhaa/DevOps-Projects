using System.Diagnostics;
using System.Net.Http.Json;
using Microsoft.Extensions.Logging;

namespace AiProvider;

public class OpenAiCompatibleProvider : IAiProvider
{
    private readonly HttpClient _http;
    private readonly ILogger<OpenAiCompatibleProvider> _logger;

    public string ProviderName => "openai-compatible";

    public OpenAiCompatibleProvider(HttpClient http, ILogger<OpenAiCompatibleProvider> logger)
    {
        _http = http;
        _logger = logger;
    }

    public async Task<AiResponse> CompleteAsync(AiRequest request, CancellationToken cancellationToken = default)
    {
        var sw = Stopwatch.StartNew();

        _logger.LogInformation("OpenAI-compatible processing job {JobId} with model {Model}", request.JobId, request.Model);

        var payload = new
        {
            model = request.Model,
            messages = new[] { new { role = "user", content = request.Prompt } }
        };

        var response = await _http.PostAsJsonAsync("/chat/completions", payload, cancellationToken);
        response.EnsureSuccessStatusCode();

        var result = await response.Content.ReadFromJsonAsync<OpenAiResponse>(cancellationToken: cancellationToken);
        var content = result?.Choices?.FirstOrDefault()?.Message?.Content ?? string.Empty;

        sw.Stop();

        return new AiResponse(request.JobId, content, request.Model, ProviderName, sw.ElapsedMilliseconds);
    }

    private record OpenAiResponse(OpenAiChoice[]? Choices);
    private record OpenAiChoice(OpenAiMessage Message);
    private record OpenAiMessage(string Content);
}
