namespace AiProvider;

public interface IAiProvider
{
    Task<AiResponse> CompleteAsync(AiRequest request, CancellationToken cancellationToken = default);
    string ProviderName { get; }
}

public record AiRequest(string Prompt, string Model, string JobId);

public record AiResponse(string JobId, string Content, string Model, string Provider, long DurationMs);
