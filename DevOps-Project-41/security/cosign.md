# Cosign — Image Signing and Verification

This project uses **Cosign keyless signing** via GitHub Actions OIDC. No long-lived signing keys are stored.

## How signing works

1. The `release.yml` pipeline authenticates to Sigstore via GitHub OIDC (`id-token: write` permission).
2. Cosign signs the image digest after push to GHCR.
3. The signature and transparency log entry are stored alongside the image in GHCR.

## Verify a signed image locally

```bash
# Install cosign
brew install cosign  # macOS
# or: curl -O -L https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64 && chmod +x cosign-linux-amd64

# Verify the api image
cosign verify \
  ghcr.io/GITHUB_OWNER/ai-native-devsecops-platform/ai-api:1.0.0 \
  --certificate-identity-regexp "https://github.com/GITHUB_OWNER/DevOps-Projects/.github/workflows/release.yml.*" \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com

# Verify the worker image
cosign verify \
  ghcr.io/GITHUB_OWNER/ai-native-devsecops-platform/ai-worker:1.0.0 \
  --certificate-identity-regexp "https://github.com/GITHUB_OWNER/DevOps-Projects/.github/workflows/release.yml.*" \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
```

## What the output means

A successful verification prints the certificate chain and the Rekor transparency log entry. If verification fails, the image has either not been signed or the signature does not match the expected workflow identity — do not deploy it.

## Notes

- Keyless signing requires no secret management.
- The OIDC identity ties the signature to this specific GitHub Actions workflow.
- The Rekor transparency log provides an immutable audit trail.
- Replace `GITHUB_OWNER` with your GitHub username or organisation.
