# Observability Guide

## Stack overview

```
Application (ai-api, ai-worker)
  → OpenTelemetry SDK
    → OpenTelemetry Collector (OTLP gRPC :4317)
      → Prometheus (metrics scrape :8889)
      → Loki (logs via Promtail)
      → Grafana (visualisation)
```

## Signals

### Traces

| Span name | Service | Description |
|-----------|---------|-------------|
| `http.post.ask` | ai-api | Incoming /ask request |
| `queue.enqueue.redis` | ai-api | Job enqueue to Redis |
| `worker.process.job` | ai-worker | Full job processing |
| `ai.provider.call` | ai-worker | AI provider invocation |

### Metrics

| Metric | Type | Description |
|--------|------|-------------|
| `ai_jobs_created_total` | Counter | Total jobs created via /ask |
| `ai_jobs_completed_total` | Counter | Total successfully completed jobs |
| `ai_jobs_failed_total` | Counter | Total failed jobs |
| `ai_job_duration_seconds` | Histogram | Job processing time |
| `ai_queue_depth` | Gauge | Current Redis list length |
| `ai_jobs_enqueue_failed_total` | Counter | Failed enqueue attempts |

### Logs

Logs are structured JSON with `traceId` correlation when an active trace exists.

## Install Prometheus + Grafana

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  -f DevOps-Project-41/observability/prometheus-values.yaml

kubectl -n monitoring get pods
kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80
```

## Install Loki + Promtail

```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm install loki grafana/loki-stack \
  --namespace monitoring \
  -f DevOps-Project-41/observability/loki-values.yaml
```

## Import Grafana dashboard

1. Open `http://localhost:3000` (admin/admin)
2. **Dashboards → Import → Upload JSON file**
3. Select `observability/grafana-dashboard.json`

## Deploy OpenTelemetry Collector on Kubernetes

```bash
kubectl apply -f DevOps-Project-41/observability/otel-collector.yaml
kubectl -n ai-devsecops get pods -l app.kubernetes.io/name=otel-collector
```

## Verify metrics are flowing

```bash
# Check Prometheus targets
open http://localhost:9091/targets

# Query a metric directly
curl -s http://localhost:9091/api/v1/query?query=ai_jobs_created_total | jq .

# Check OTel collector is receiving
kubectl -n ai-devsecops logs -l app.kubernetes.io/name=otel-collector --tail=20
```
