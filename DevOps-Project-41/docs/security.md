# Security Guide

## Defence-in-depth layers

| Layer | Tool | What it protects |
|-------|------|-----------------|
| Code scanning | Trivy (fs) | Vulnerabilities in source dependencies |
| Image scanning | Trivy (image) | CVEs in base image and OS packages |
| Config scanning | Trivy (config) | Kubernetes manifest misconfigurations |
| SBOM | Trivy / Syft | Component inventory + licence compliance |
| Image signing | Cosign (keyless) | Tamper-evident provenance via Sigstore |
| Admission control | Kyverno | Runtime enforcement of security policies |
| Secret management | Kubernetes Secrets (dev) / External Secrets (prod) | Credential isolation |

## Trivy

Trivy is configured in `security/trivy.yaml` to report `HIGH` and `CRITICAL` findings.

```bash
# Source code scan
trivy fs DevOps-Project-41 --config DevOps-Project-41/security/trivy.yaml

# Kubernetes manifests
trivy config DevOps-Project-41/k8s

# Container image
trivy image ghcr.io/GITHUB_OWNER/ai-api:1.0.0

# Generate JSON report
trivy image --format json --output report.json ghcr.io/GITHUB_OWNER/ai-api:1.0.0
```

## SBOM

See [security/sbom.md](../security/sbom.md) for full SBOM generation and inspection instructions.

## Cosign image signing

See [security/cosign.md](../security/cosign.md) for signing and verification instructions.

## Kyverno policies

Policies are in `security/policies/`. They are enforced on the `ai-devsecops` namespace.

| Policy file | Rule | Action |
|-------------|------|--------|
| `deny-privileged-containers.yaml` | No `privileged: true` containers | Enforce |
| `require-non-root.yaml` | `runAsNonRoot: true` required | Enforce |
| `require-resource-limits.yaml` | CPU + memory requests and limits required | Enforce |
| `restrict-latest-tag.yaml` | No `:latest` image tag | Enforce |
| `require-labels.yaml` | `app.kubernetes.io/name` + `version` labels required | Enforce |

### Install Kyverno and apply policies

```bash
helm repo add kyverno https://kyverno.github.io/kyverno
helm install kyverno kyverno/kyverno --namespace kyverno --create-namespace
kubectl -n kyverno get pods

kubectl apply -f DevOps-Project-41/security/policies/
kubectl get clusterpolicies
```

### Test a policy rejection

```bash
# This should be REJECTED (latest tag)
kubectl -n ai-devsecops run test --image=nginx:latest --dry-run=server
# Error from server: admission webhook denied the request: Image tag 'latest' is not allowed.

# This should be ACCEPTED (explicit tag)
kubectl -n ai-devsecops run test --image=nginx:1.27 --dry-run=server
```

## Container security baseline

All workloads in this project follow the Kubernetes Restricted pod security standard:

- `runAsNonRoot: true`
- `allowPrivilegeEscalation: false`
- `capabilities.drop: [ALL]`
- `readOnlyRootFilesystem: true` (API and worker)
- `automountServiceAccountToken: false`

## Secret handling

- Development: Kubernetes Secrets via `kubectl create secret` or `secretGenerator` in Kustomize
- Production: Use [External Secrets Operator](https://external-secrets.io/) with AWS Secrets Manager, Azure Key Vault, or GCP Secret Manager
- Never commit `secret.yaml` — only `secret.example.yaml` is tracked in Git
