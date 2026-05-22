# Local Setup Guide

## Prerequisites

Install the following tools before starting:

```bash
# macOS (Homebrew)
brew install kind kubectl helm dotnet k6 trivy cosign

# Verify
docker --version          # ≥ 24
kind --version            # ≥ 0.23
kubectl version --client  # ≥ 1.29
helm version              # ≥ 3.14
dotnet --version          # 8.0.x
```

## Option 1 — Docker Compose (fastest)

```bash
cd DevOps-Project-41/app
docker compose up --build

# Verify
curl http://localhost:8080/health
# Grafana: http://localhost:3000  (admin/admin)
# Prometheus: http://localhost:9091
```

## Option 2 — Local Kubernetes with kind

### Step 1: Create the cluster

```bash
kind create cluster --config DevOps-Project-41/infra/kind/kind-cluster.yaml
kubectl cluster-info
```

### Step 2: Build and load images into kind

```bash
cd DevOps-Project-41/app
docker build --target api    -t ai-api:dev    .
docker build --target worker -t ai-worker:dev .

kind load docker-image ai-api:dev    --name ai-devsecops
kind load docker-image ai-worker:dev --name ai-devsecops
```

### Step 3: Create the postgres secret

```bash
kubectl create namespace ai-devsecops
kubectl -n ai-devsecops create secret generic postgres-secret \
  --from-literal=password=aiops-dev-password
```

### Step 4: Deploy with Kustomize

```bash
# Update images in overlays/dev/kustomization.yaml to ai-api:dev and ai-worker:dev
kubectl apply -k DevOps-Project-41/k8s/overlays/dev
kubectl -n ai-devsecops get pods -w
```

### Step 5: Port-forward and test

```bash
kubectl -n ai-devsecops port-forward svc/ai-api 8080:80 &
curl http://localhost:8080/health
bash DevOps-Project-41/tests/smoke/smoke-test.sh
```

## AI Provider Configuration

| Mode | `AI_PROVIDER` value | Extra env var required |
|------|--------------------|-----------------------|
| Mock (default) | `mock` | None |
| Ollama | `ollama` | `OLLAMA_BASE_URL=http://ollama:11434` |
| OpenAI-compatible | `openai-compatible` | `OPENAI_COMPATIBLE_BASE_URL`, `OPENAI_API_KEY` |

To switch provider in Docker Compose, edit `docker-compose.yml` and change `AI_PROVIDER`.

## Running tests

```bash
cd DevOps-Project-41/app
dotnet test -c Release
```
