# GitOps Workflow Guide

## How GitOps works in this project

```
Git commit
  → GitHub Actions CI (build + test + scan)
  → Release pipeline (push to GHCR + sign)
  → Pipeline updates image digest in k8s/overlays/dev/kustomization.yaml
  → Argo CD detects change in Git
  → Argo CD syncs desired state to Kubernetes cluster
```

Git is the single source of truth. No `kubectl apply` is run manually in production — all changes go through Git.

## Install Argo CD

```bash
kubectl create namespace argocd
kubectl apply -n argocd --server-side --force-conflicts \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl -n argocd wait --for=condition=Available deployment/argocd-server --timeout=120s
```

## Access the UI

```bash
# Get initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo

# Port-forward
kubectl -n argocd port-forward svc/argocd-server 8080:443
# Open: https://localhost:8080  (accept self-signed cert)
```

## Apply the dev Application

Edit `gitops/argocd-app-dev.yaml` and replace `GITHUB_OWNER` with your GitHub username, then:

```bash
kubectl apply -f DevOps-Project-41/gitops/argocd-app-dev.yaml
kubectl -n argocd get applications
kubectl -n argocd get application ai-native-platform-dev -o yaml
```

## Sync behaviour

| Environment | Sync mode | Prune | Self-heal |
|-------------|-----------|-------|-----------|
| dev | Automated | Yes | Yes |
| prod | Manual | Yes | No |

## Promote to prod

1. Merge changes to `master` branch
2. Update image tag in `k8s/overlays/prod/kustomization.yaml`
3. Apply the prod Application: `kubectl apply -f gitops/argocd-app-prod.yaml`
4. In Argo CD UI, click **Sync** → **Synchronize**

## Using the Argo CD CLI

```bash
# Install
brew install argocd

# Login
argocd login localhost:8080 --insecure --username admin

# List apps
argocd app list

# Sync manually
argocd app sync ai-native-platform-dev

# Watch status
argocd app wait ai-native-platform-dev --health
```
