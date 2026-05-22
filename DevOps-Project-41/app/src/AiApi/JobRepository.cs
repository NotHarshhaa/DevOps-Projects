using Npgsql;

namespace AiApi;

public class JobRepository
{
    private readonly string _connectionString;

    public JobRepository(IConfiguration config)
    {
        _connectionString = config.GetConnectionString("Postgres")
            ?? config["POSTGRES_CONNECTION_STRING"]
            ?? "Host=localhost;Database=aiops;Username=aiops;Password=aiops";
    }

    public async Task EnsureSchemaAsync()
    {
        await using var conn = new NpgsqlConnection(_connectionString);
        await conn.OpenAsync();
        await using var cmd = conn.CreateCommand();
        cmd.CommandText = """
            CREATE TABLE IF NOT EXISTS ai_jobs (
                job_id      TEXT PRIMARY KEY,
                status      TEXT NOT NULL DEFAULT 'queued',
                prompt      TEXT NOT NULL,
                model       TEXT NOT NULL,
                provider    TEXT,
                result      TEXT,
                error       TEXT,
                duration_ms BIGINT,
                created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                completed_at TIMESTAMPTZ
            );
            """;
        await cmd.ExecuteNonQueryAsync();
    }

    public async Task InsertJobAsync(string jobId, string prompt, string model)
    {
        await using var conn = new NpgsqlConnection(_connectionString);
        await conn.OpenAsync();
        await using var cmd = conn.CreateCommand();
        cmd.CommandText = "INSERT INTO ai_jobs (job_id, prompt, model, status, created_at) VALUES (@id, @prompt, @model, 'queued', NOW())";
        cmd.Parameters.AddWithValue("id", jobId);
        cmd.Parameters.AddWithValue("prompt", prompt);
        cmd.Parameters.AddWithValue("model", model);
        await cmd.ExecuteNonQueryAsync();
    }

    public async Task<JobStatusResponse?> GetJobAsync(string jobId)
    {
        await using var conn = new NpgsqlConnection(_connectionString);
        await conn.OpenAsync();
        await using var cmd = conn.CreateCommand();
        cmd.CommandText = "SELECT job_id, status, result, model, provider, duration_ms, created_at, completed_at, error FROM ai_jobs WHERE job_id = @id";
        cmd.Parameters.AddWithValue("id", jobId);
        await using var reader = await cmd.ExecuteReaderAsync();
        if (!await reader.ReadAsync()) return null;

        return new JobStatusResponse(
            reader.GetString(0),
            reader.GetString(1),
            reader.IsDBNull(2) ? null : reader.GetString(2),
            reader.IsDBNull(3) ? null : reader.GetString(3),
            reader.IsDBNull(4) ? null : reader.GetString(4),
            reader.IsDBNull(5) ? null : reader.GetInt64(5),
            reader.GetFieldValue<DateTimeOffset>(6),
            reader.IsDBNull(7) ? null : reader.GetFieldValue<DateTimeOffset>(7),
            reader.IsDBNull(8) ? null : reader.GetString(8)
        );
    }

    public async Task<bool> CanConnectAsync()
    {
        try
        {
            await using var conn = new NpgsqlConnection(_connectionString);
            await conn.OpenAsync();
            return true;
        }
        catch
        {
            return false;
        }
    }
}
