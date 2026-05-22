# Platform Validation Checklist

Use this checklist to verify each component after deployment.

## 1. Local Development (Docker Compose)

- [ ] `docker compose up --build` completes without errors
- [ ] `curl http://localhost:8080/health` → `{"status":"healthy"}`
- [ ] `POST /ask` returns `jobId` with `status: queued`
- [ ] `GET /jobs/{jobId}` eventually returns `status: completed` with a `result`
- [ ] `bash tests/smoke/smoke-test.sh` — all tests pass
- [ ] Grafana accessible at `http://localhost:3000`
- [ ] Prometheus accessible at `http://localhost:9091`

## 2. .NET Tests

```bash
cd DevOps-Project-41/app
dotnet test -c Release
```

- [ ] All unit tests pass
- [ ] MockLlmProvider returns expected responses for known keywords
- [ ] CancellationToken is respected

## 3. Kubernetes Deployment

```bash
kubectl -n ai-devsecops get pods
```

- [ ] `ai-api` pod is `Running` and `Ready`
- [ ] `ai-worker` pod is `Running` and `Ready`
- [ ] `redis` pod is `Running` and `Ready`
- [ ] `postgres-0` StatefulSet pod is `Running` and `Ready`
- [ ] `otel-collector` pod is `Running` and `Ready`

```bash
kubectl -n ai-devsecops port-forward svc/ai-api 8080:80
curl http://localhost:8080/health
```

- [ ] API responds inside cluster

## 4. GitOps — Argo CD

```bash
kubectl -n argocd get applications
```

- [ ] `ai-native-platform-dev` shows `Synced` and `Healthy`
- [ ] Changing a manifest in Git triggers automatic reconciliation within 3 minutes

## 5. KEDA Autoscaling

```bash
kubectl -n ai-devsecops get scaledobject
kubectl -n ai-devsecops get hpa
```

- [ ] ScaledObject `READY=True`
- [ ] Worker replica count is 0 when queue is empty
- [ ] Run load test: `API_URL=http://localhost:8080 k6 run tests/load/k6-ai-jobs.js`
- [ ] Worker replicas increase during load
- [ ] Worker scales back to 0 after load test ends

```bash
kubectl -n ai-devsecops get deploy ai-worker -w
```

## 6. Observability

```bash
open http://localhost:9091/targets
```

- [ ] Prometheus scrapes `ai-api` target (UP)
- [ ] Prometheus scrapes `ai-worker` target (UP)
- [ ] Prometheus scrapes `otel-collector` target (UP)

In Grafana:

- [ ] Dashboard `AI-Native DevSecOps Platform` is importable
- [ ] `API Request Rate` panel shows data after sending requests
- [ ] `Job Queue Depth` panel shows queue depth
- [ ] `Worker Replica Count` panel reflects KEDA scaling

## 7. Supply Chain Security

```bash
trivy fs DevOps-Project-41 --severity HIGH,CRITICAL
```

- [ ] Trivy filesystem scan completes

```bash
trivy config DevOps-Project-41/k8s
```

- [ ] Trivy config scan completes with no CRITICAL misconfigurations

After release pipeline runs:

```bash
cosign verify ghcr.io/GITHUB_OWNER/ai-api:1.0.0 \
  --certificate-identity-regexp ".*release.yml.*" \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
```

- [ ] Cosign verification succeeds
- [ ] SBOM artefacts appear in GitHub Actions run

## 8. Kyverno Policies

```bash
kubectl get clusterpolicies
```

- [ ] 5 policies are `Ready`

```bash
# Should be rejected
kubectl -n ai-devsecops run test --image=nginx:latest --dry-run=server 2>&1 | grep "denied"
```

- [ ] `:latest` tag rejected by `restrict-latest-tag` policy

## 9. CI Pipeline

Check GitHub Actions tab after pushing:

- [ ] `CI` workflow passes on push
- [ ] `.NET` tests pass
- [ ] Docker images build successfully
- [ ] `Security Scanning` workflow uploads SARIF to GitHub Security tab
- [ ] `Release` workflow (on tag) pushes images to GHCR

## 10. Cleanup

```bash
kind delete cluster --name ai-devsecops
docker compose down -v
```

- [ ] kind cluster deleted cleanly
- [ ] Docker volumes removed
- [ ] No orphan namespaces in local cluster
