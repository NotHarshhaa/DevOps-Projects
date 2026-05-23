# Cleanup Instructions

## Docker Compose

```bash
cd DevOps-Project-41/app

# Stop all containers and remove volumes
docker compose down -v

# Remove local images (optional)
docker rmi ai-native-devsecops/ai-api:local ai-native-devsecops/ai-worker:local 2>/dev/null || true
```

## Kubernetes

```bash
# Remove Argo CD applications (triggers pruning of managed resources)
kubectl delete -f DevOps-Project-41/gitops/argocd-app-dev.yaml  --ignore-not-found=true
kubectl delete -f DevOps-Project-41/gitops/argocd-app-prod.yaml --ignore-not-found=true

# Remove application namespace
kubectl delete namespace ai-devsecops --ignore-not-found=true

# Remove Argo CD
kubectl delete namespace argocd --ignore-not-found=true

# Remove KEDA
helm uninstall keda -n keda 2>/dev/null || true
kubectl delete namespace keda --ignore-not-found=true

# Remove Prometheus + Grafana + Loki
helm uninstall kube-prometheus-stack -n monitoring 2>/dev/null || true
helm uninstall loki -n monitoring 2>/dev/null || true
kubectl delete namespace monitoring --ignore-not-found=true

# Remove Kyverno
helm uninstall kyverno -n kyverno 2>/dev/null || true
kubectl delete namespace kyverno --ignore-not-found=true
kubectl delete clusterpolicies --all 2>/dev/null || true
```

## kind cluster

```bash
kind delete cluster --name ai-devsecops
```

## GHCR images (optional)

Delete container images via GitHub UI:
- Go to your GitHub profile → Packages
- Select `ai-api` or `ai-worker`
- Delete specific versions or the entire package

## Local build artefacts

```bash
cd DevOps-Project-41/app
find . -name "bin" -o -name "obj" | xargs rm -rf
rm -f sbom-*.json trivy-*.sarif TestResults/*.trx
```
