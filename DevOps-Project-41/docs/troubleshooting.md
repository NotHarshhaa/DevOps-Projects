# Troubleshooting Guide

## Docker Compose

### `docker compose up` fails immediately

**Symptom:** Port binding error.

```
Error response from daemon: Ports are not available: exposing port TCP 0.0.0.0:8080
```

**Fix:** Find and stop the process using the port.

```bash
lsof -i :8080
kill -9 <PID>
```

### API returns 503 on `/ready`

**Symptom:** Redis or PostgreSQL not yet ready.

**Fix:** Wait 15–30 seconds for healthcheck retries. Check individual service logs:

```bash
docker compose logs redis
docker compose logs postgres
```

### Worker not processing jobs

**Symptom:** Jobs stay in `queued` state indefinitely.

**Fix:** Check worker logs and confirm `REDIS_CONNECTION_STRING` is reachable.

```bash
docker compose logs ai-worker
docker compose exec redis redis-cli llen ai-jobs
```

---

## Kubernetes (kind)

### Pods in `ImagePullBackOff`

**Cause:** Image not present in kind cluster.

**Fix:** Load image manually.

```bash
kind load docker-image ai-api:dev --name ai-devsecops
kind load docker-image ai-worker:dev --name ai-devsecops
```

### Pods stuck in `Pending`

**Cause:** Insufficient resources or PVC not bound.

**Fix:**

```bash
kubectl -n ai-devsecops describe pod <pod-name>
kubectl -n ai-devsecops get pvc
```

For PVC issues on kind, ensure the default StorageClass is available:

```bash
kubectl get storageclass
```

### `kubectl apply -k` fails with version errors

**Cause:** Old kubectl version.

**Fix:** Update to kubectl ≥ 1.29:

```bash
brew upgrade kubectl
```

---

## Argo CD

### Argo CD Application stuck in `OutOfSync`

**Fix:** Check the source path and branch:

```bash
kubectl -n argocd describe application ai-native-platform-dev
argocd app diff ai-native-platform-dev
```

### Argo CD cannot reach the Git repository

**Fix:** Ensure the `repoURL` in `gitops/argocd-app-dev.yaml` is a public repository or add SSH credentials:

```bash
argocd repo add https://github.com/GITHUB_OWNER/DevOps-Projects.git
```

---

## KEDA

### Worker not scaling despite jobs in queue

**Step 1:** Verify KEDA operator is running.

```bash
kubectl -n keda get pods
```

**Step 2:** Check the ScaledObject status.

```bash
kubectl -n ai-devsecops describe scaledobject ai-worker-scaledobject
```

**Step 3:** Verify Redis address matches the Service name.

The `address` in `keda-scaledobject-worker.yaml` must match the Redis Service FQDN:

```
redis.ai-devsecops.svc.cluster.local:6379
```

**Step 4:** Check KEDA operator logs.

```bash
kubectl -n keda logs -l app=keda-operator --tail=30
```

---

## Cosign

### `cosign verify` fails with identity mismatch

**Fix:** Ensure `--certificate-identity-regexp` matches your exact repository path:

```bash
--certificate-identity-regexp "https://github.com/YOUR_OWNER/DevOps-Projects/.github/workflows/release.yml.*"
```

### `cosign sign` fails with OIDC error in GitHub Actions

**Fix:** The workflow must have `id-token: write` permission at the job level. Check `release.yml`:

```yaml
permissions:
  id-token: write
  packages: write
```

---

## GitHub Actions CI

### CI fails on `dotnet restore`

**Fix:** Ensure .NET 8 SDK is specified correctly in `ci.yml`:

```yaml
dotnet-version: "8.0.x"
```

### Docker build cache miss on every run

**Fix:** Ensure `cache-from` and `cache-to` are set correctly:

```yaml
cache-from: type=gha
cache-to: type=gha,mode=max
```

---

## PostgreSQL

### `NpgsqlException: connection refused`

**Fix:** Check the connection string format. For Docker Compose:

```
Host=postgres;Database=aiops;Username=aiops;Password=aiops
```

For Kubernetes (StatefulSet headless service):

```
Host=postgres.ai-devsecops.svc.cluster.local;Database=aiops;Username=aiops;Password=<from-secret>
```
