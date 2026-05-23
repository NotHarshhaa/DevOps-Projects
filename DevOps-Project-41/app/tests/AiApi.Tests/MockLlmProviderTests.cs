using AiProvider;
using Microsoft.Extensions.Logging.Abstractions;
using Xunit;

namespace AiApi.Tests;

public class MockLlmProviderTests
{
    private readonly MockLlmProvider _provider = new(NullLogger<MockLlmProvider>.Instance);

    [Fact]
    public async Task CompleteAsync_ReturnsResponse_ForKnownKeyword()
    {
        var request = new AiRequest("Explain GitOps in simple terms", "mock-devops-model", "job-001");

        var response = await _provider.CompleteAsync(request);

        Assert.Equal("job-001", response.JobId);
        Assert.NotEmpty(response.Content);
        Assert.Contains("GitOps", response.Content, StringComparison.OrdinalIgnoreCase);
        Assert.Equal("mock", response.Provider);
    }

    [Fact]
    public async Task CompleteAsync_ReturnsFallback_ForUnknownPrompt()
    {
        var request = new AiRequest("Tell me about the weather", "mock-devops-model", "job-002");

        var response = await _provider.CompleteAsync(request);

        Assert.Equal("job-002", response.JobId);
        Assert.Contains("[MockLLM]", response.Content);
    }

    [Fact]
    public async Task CompleteAsync_ReturnsPositiveDuration()
    {
        var request = new AiRequest("Kubernetes overview", "mock-devops-model", "job-003");

        var response = await _provider.CompleteAsync(request);

        Assert.True(response.DurationMs >= 0);
    }

    [Theory]
    [InlineData("kubernetes")]
    [InlineData("devsecops")]
    [InlineData("keda")]
    [InlineData("opentelemetry")]
    public async Task CompleteAsync_RecognisesAllKeywords(string keyword)
    {
        var request = new AiRequest($"What is {keyword}?", "mock-devops-model", $"job-{keyword}");

        var response = await _provider.CompleteAsync(request);

        Assert.NotEmpty(response.Content);
        Assert.DoesNotContain("[MockLLM]", response.Content);
    }
}
