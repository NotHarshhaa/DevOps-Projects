namespace AiApi;

public record AskRequest(string Prompt, string Model = "mock-devops-model");

public record AskResponse(string JobId, string Status);

public record JobStatusResponse(
    string JobId,
    string Status,
    string? Result,
    string? Model,
    string? Provider,
    long? DurationMs,
    DateTimeOffset CreatedAt,
    DateTimeOffset? CompletedAt,
    string? Error
);

public static class JobStatus
{
    public const string Queued = "queued";
    public const string Processing = "processing";
    public const string Completed = "completed";
    public const string Failed = "failed";
}
