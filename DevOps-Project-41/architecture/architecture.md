# Architecture — AI-Native DevSecOps Platform

## System overview

This platform is designed around three axes:

1. **Developer workflow** — git push triggers automated CI/CD with security gates
2. **Runtime platform** — Kubernetes with GitOps, event-driven autoscaling and observability
3. **Security posture** — supply chain security from code to deployment

## Components

### Application layer

| Component | Type | Responsibility |
|-----------|------|---------------|
| `ai-api` | .NET 8 Minimal API | Accept HTTP requests, validate, enqueue to Redis, return job status |
| `ai-worker` | .NET 8 Worker Service | Dequeue jobs, invoke AI provider, persist results, emit telemetry |
| `AiProvider` | .NET 8 Class Library | Abstraction over MockLLM, Ollama, and OpenAI-compatible providers |

### Infrastructure layer

| Component | Purpose |
|-----------|---------|
| Redis 7.2 | FIFO job queue using Redis List (`ai-jobs`) |
| PostgreSQL 16 | Persistent job state (`ai_jobs` table) |
| kind (local) | Local Kubernetes cluster with 1 control-plane + 2 workers |

### CI/CD layer

| Workflow | Trigger | Key jobs |
|----------|---------|----------|
| `ci.yml` | push / PR | restore → build → test → docker-build |
| `security.yml` | push / weekly schedule | trivy-fs → trivy-config → trivy-image → upload-sarif |
| `release.yml` | version tag / manual | build+push GHCR → sign → SBOM → verify |

### GitOps layer

| Component | Configuration |
|-----------|--------------|
| Argo CD | Watches `k8s/overlays/dev`, auto-syncs on digest change |
| Kustomize | `k8s/base` + `k8s/overlays/{dev,prod}` for environment-specific config |
| KEDA | `ScaledObject` on Redis list `ai-jobs` — scales worker 0→10 replicas |

### Observability layer

```
Application SDK (OpenTelemetry)
  → OpenTelemetry Collector (OTLP gRPC)
    → Prometheus exporter (:8889)
    → Logging exporter
    → Tempo/Loki (optional)
Prometheus scrapes OTel Collector
Grafana queries Prometheus + Loki
```

### Security layer

| Control | Where applied |
|---------|--------------|
| Trivy scan | GitHub Actions + local CLI |
| SBOM generation | GitHub Actions release pipeline |
| Cosign keyless signing | GitHub Actions OIDC → Sigstore Rekor |
| Kyverno policies | Kubernetes admission webhook |
| Non-root containers | All Kubernetes workloads |
| Network policies | Restrict pod-to-pod communication |
| Secret separation | Kubernetes Secrets (dev) / ESO (prod) |

## Data flow — job lifecycle

```
POST /ask
  → API validates request
  → API inserts row in PostgreSQL (status=queued)
  → API pushes JSON payload to Redis list ai-jobs
  → API returns 202 Accepted with jobId

KEDA (every 10s)
  → reads Redis list length
  → adjusts HPA target replicas (0–10)

Worker (continuous)
  → pops job from Redis (blocking)
  → updates PostgreSQL (status=processing)
  → calls AI provider
  → updates PostgreSQL (status=completed/failed, result, duration_ms)
  → emits OTel span + metrics

GET /jobs/{jobId}
  → API reads from PostgreSQL
  → returns current status + result
```

## Overlay strategy

```
k8s/base/              → all resources at default scale
k8s/overlays/dev/      → small resources, mock AI, imagePullPolicy Always
k8s/overlays/prod/     → 2 replicas, full resource limits, manual Argo CD sync
```

## Security boundary

Kyverno enforces at admission time so no non-compliant Pod can ever be scheduled, regardless of who applies the manifest.

Network policies restrict lateral movement between Pods. The `ai-api` and `ai-worker` can only talk to Redis, PostgreSQL, and the OTel Collector — not to each other directly.
