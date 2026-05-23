using AiProvider;
using Microsoft.Extensions.Logging.Abstractions;
using Xunit;

namespace AiWorker.Tests;

public class AiProviderContractTests
{
    [Fact]
    public async Task MockProvider_AlwaysReturnsNonEmptyContent()
    {
        var provider = new MockLlmProvider(NullLogger<MockLlmProvider>.Instance);
        var request = new AiRequest("How does KEDA work?", "mock-devops-model", "contract-test-001");

        var response = await provider.CompleteAsync(request);

        Assert.NotNull(response);
        Assert.NotEmpty(response.Content);
        Assert.Equal("contract-test-001", response.JobId);
        Assert.Equal("mock", response.Provider);
        Assert.True(response.DurationMs >= 0);
    }

    [Fact]
    public async Task MockProvider_CancellationToken_IsRespected()
    {
        var provider = new MockLlmProvider(NullLogger<MockLlmProvider>.Instance);
        var cts = new CancellationTokenSource();
        cts.Cancel();

        await Assert.ThrowsAnyAsync<OperationCanceledException>(
            () => provider.CompleteAsync(new AiRequest("test", "model", "job-cancel"), cts.Token));
    }
}
