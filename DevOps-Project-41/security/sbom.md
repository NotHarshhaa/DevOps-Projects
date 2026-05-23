# SBOM — Software Bill of Materials

This project generates SBOMs in both **SPDX** and **CycloneDX** formats as part of the release pipeline.

## What is an SBOM?

An SBOM is a machine-readable inventory of all software components, dependencies, and licences in a build artefact. It enables vulnerability tracking, licence compliance, and supply chain auditing.

## Generated artefacts

| Format | File | Description |
|--------|------|-------------|
| SPDX JSON | `sbom-api.spdx.json` | SPDX 2.3 SBOM for the AI API image |
| CycloneDX JSON | `sbom-api.cyclonedx.json` | CycloneDX 1.4 SBOM for the AI API image |
| SPDX JSON | `sbom-worker.spdx.json` | SPDX 2.3 SBOM for the AI Worker image |

Artefacts are attached to the GitHub Actions release run and also attested to the image in GHCR using `cosign attest`.

## Generate SBOM locally

```bash
# Using Trivy (SPDX)
trivy image --format spdx-json --output sbom-api.spdx.json \
  ghcr.io/GITHUB_OWNER/ai-native-devsecops-platform/ai-api:1.0.0

# Using Trivy (CycloneDX)
trivy image --format cyclonedx --output sbom-api.cyclonedx.json \
  ghcr.io/GITHUB_OWNER/ai-native-devsecops-platform/ai-api:1.0.0

# Using Syft (alternative)
syft ghcr.io/GITHUB_OWNER/ai-native-devsecops-platform/ai-api:1.0.0 \
  -o spdx-json=sbom-api.spdx.json \
  -o cyclonedx-json=sbom-api.cyclonedx.json
```

## Inspect an SBOM

```bash
# List all packages
cat sbom-api.spdx.json | jq '.packages[].name' | sort -u

# Find a specific package
cat sbom-api.cyclonedx.json | jq '.components[] | select(.name == "StackExchange.Redis")'
```

## Attest SBOM to image (done by pipeline)

```bash
cosign attest --predicate sbom-api.spdx.json \
  --type spdxjson \
  ghcr.io/GITHUB_OWNER/ai-native-devsecops-platform/ai-api:1.0.0
```
