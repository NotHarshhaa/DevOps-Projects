using AiProvider;
using AiWorker;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;
using Prometheus;
using StackExchange.Redis;

var builder = Host.CreateApplicationBuilder(args);

// Redis
var redisConnection = builder.Configuration["REDIS_CONNECTION_STRING"] ?? "localhost:6379";
builder.Services.AddSingleton<IConnectionMultiplexer>(_ => ConnectionMultiplexer.Connect(redisConnection));

// Job updater
builder.Services.AddSingleton<JobUpdater>();

// AI Provider selection
var providerName = builder.Configuration["AI_PROVIDER"] ?? "mock";
builder.Services.AddHttpClient();

builder.Services.AddSingleton<IAiProvider>(sp =>
{
    var loggerFactory = sp.GetRequiredService<ILoggerFactory>();

    return providerName switch
    {
        "ollama" => new OllamaProvider(
            CreateHttpClient(sp, builder.Configuration["OLLAMA_BASE_URL"] ?? "http://localhost:11434"),
            loggerFactory.CreateLogger<OllamaProvider>()),

        "openai-compatible" => new OpenAiCompatibleProvider(
            CreateHttpClient(sp, builder.Configuration["OPENAI_COMPATIBLE_BASE_URL"] ?? "http://localhost:8000",
                builder.Configuration["OPENAI_API_KEY"]),
            loggerFactory.CreateLogger<OpenAiCompatibleProvider>()),

        _ => new MockLlmProvider(loggerFactory.CreateLogger<MockLlmProvider>())
    };
});

// OpenTelemetry
var otelEndpoint = builder.Configuration["OTEL_EXPORTER_OTLP_ENDPOINT"];
builder.Services.AddOpenTelemetry()
    .ConfigureResource(r => r.AddService("ai-worker"))
    .WithTracing(t =>
    {
        t.AddHttpClientInstrumentation();
        if (!string.IsNullOrEmpty(otelEndpoint))
            t.AddOtlpExporter(o => o.Endpoint = new Uri(otelEndpoint));
    });

builder.Services.AddHostedService<Worker>();

var host = builder.Build();

// Expose Prometheus metrics on port 9090
var metricServer = new MetricServer(port: 9090);
metricServer.Start();

await host.RunAsync();

static HttpClient CreateHttpClient(IServiceProvider sp, string baseUrl, string? apiKey = null)
{
    var client = new HttpClient { BaseAddress = new Uri(baseUrl) };
    if (!string.IsNullOrEmpty(apiKey))
        client.DefaultRequestHeaders.Add("Authorization", $"Bearer {apiKey}");
    return client;
}
