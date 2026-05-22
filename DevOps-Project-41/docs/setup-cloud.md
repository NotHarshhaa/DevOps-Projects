# Cloud Setup Guide (Optional)

> This guide describes deploying the platform to a managed Kubernetes service. All core functionality works locally with kind — cloud is optional.

## Supported targets

- **Azure AKS** — recommended for .NET workloads
- **AWS EKS**
- **GCP GKE**

## Prerequisites

```bash
# Azure
brew install azure-cli
az login
az aks install-cli

# AWS
brew install awscli eksctl
aws configure

# GCP
brew install google-cloud-sdk
gcloud auth login
gcloud components install gke-gcloud-auth-plugin
```

## AKS (Azure)

```bash
# Create resource group and cluster
az group create --name rg-ai-devsecops --location westeurope
az aks create \
  --resource-group rg-ai-devsecops \
  --name aks-ai-devsecops \
  --node-count 2 \
  --node-vm-size Standard_DS2_v2 \
  --generate-ssh-keys

# Get credentials
az aks get-credentials --resource-group rg-ai-devsecops --name aks-ai-devsecops
kubectl get nodes
```

## EKS (AWS)

```bash
eksctl create cluster \
  --name ai-devsecops \
  --region eu-west-1 \
  --nodegroup-name workers \
  --node-type t3.medium \
  --nodes 2 \
  --with-oidc

kubectl get nodes
```

## GKE (GCP)

```bash
gcloud container clusters create ai-devsecops \
  --zone europe-west1-b \
  --machine-type e2-standard-2 \
  --num-nodes 2 \
  --workload-pool=$(gcloud config get-value project).svc.id.goog

gcloud container clusters get-credentials ai-devsecops --zone europe-west1-b
kubectl get nodes
```

## Deploy the platform

Once you have a cluster configured, follow the same steps as the local Kubernetes setup:

```bash
# Create namespace and postgres secret
kubectl create namespace ai-devsecops
kubectl -n ai-devsecops create secret generic postgres-secret \
  --from-literal=password=<STRONG_PASSWORD>

# Install KEDA
helm install keda kedacore/keda --namespace keda --create-namespace

# Install observability stack
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  -f DevOps-Project-41/observability/prometheus-values.yaml

# Install Argo CD and apply the Application
kubectl create namespace argocd
kubectl apply -n argocd --server-side --force-conflicts \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f DevOps-Project-41/gitops/argocd-app-dev.yaml
```

## Terraform (future)

The `infra/terraform/` directory is reserved for Terraform modules to provision the cloud infrastructure above. Contributions welcome.

## Cleanup (cloud)

```bash
# AKS
az aks delete --resource-group rg-ai-devsecops --name aks-ai-devsecops --yes
az group delete --name rg-ai-devsecops --yes

# EKS
eksctl delete cluster --name ai-devsecops --region eu-west-1

# GKE
gcloud container clusters delete ai-devsecops --zone europe-west1-b
```
