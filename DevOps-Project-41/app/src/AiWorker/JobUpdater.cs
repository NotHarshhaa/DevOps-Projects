using Npgsql;

namespace AiWorker;

public class JobUpdater
{
    private readonly string _connectionString;

    public JobUpdater(IConfiguration config)
    {
        _connectionString = config.GetConnectionString("Postgres")
            ?? config["POSTGRES_CONNECTION_STRING"]
            ?? "Host=localhost;Database=aiops;Username=aiops;Password=aiops";
    }

    public async Task MarkProcessingAsync(string jobId)
    {
        await using var conn = new NpgsqlConnection(_connectionString);
        await conn.OpenAsync();
        await using var cmd = conn.CreateCommand();
        cmd.CommandText = "UPDATE ai_jobs SET status = 'processing' WHERE job_id = @id";
        cmd.Parameters.AddWithValue("id", jobId);
        await cmd.ExecuteNonQueryAsync();
    }

    public async Task MarkCompletedAsync(string jobId, string result, string provider, long durationMs)
    {
        await using var conn = new NpgsqlConnection(_connectionString);
        await conn.OpenAsync();
        await using var cmd = conn.CreateCommand();
        cmd.CommandText = """
            UPDATE ai_jobs
            SET status = 'completed', result = @result, provider = @provider,
                duration_ms = @duration, completed_at = NOW()
            WHERE job_id = @id
            """;
        cmd.Parameters.AddWithValue("id", jobId);
        cmd.Parameters.AddWithValue("result", result);
        cmd.Parameters.AddWithValue("provider", provider);
        cmd.Parameters.AddWithValue("duration", durationMs);
        await cmd.ExecuteNonQueryAsync();
    }

    public async Task MarkFailedAsync(string jobId, string error)
    {
        await using var conn = new NpgsqlConnection(_connectionString);
        await conn.OpenAsync();
        await using var cmd = conn.CreateCommand();
        cmd.CommandText = "UPDATE ai_jobs SET status = 'failed', error = @error, completed_at = NOW() WHERE job_id = @id";
        cmd.Parameters.AddWithValue("id", jobId);
        cmd.Parameters.AddWithValue("error", error);
        await cmd.ExecuteNonQueryAsync();
    }
}
