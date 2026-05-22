# Terraform — Cloud Infrastructure

This directory is a placeholder for cloud-managed Kubernetes cluster provisioning.

## Purpose

Provision a managed Kubernetes cluster on your preferred cloud provider before deploying
the AI-Native DevSecOps Platform manifests from `k8s/`.

## Supported Providers

Choose one module directory to create based on your target platform:

| Provider | Module path | Cluster type |
|----------|-------------|--------------|
| AWS      | `aws/`      | EKS          |
| Azure    | `azure/`    | AKS          |
| GCP      | `gcp/`      | GKE          |

## Minimum Variables (all modules)

| Variable | Description | Example |
|----------|-------------|---------|
| `region` | Cloud region | `eu-west-1` |
| `cluster_name` | Cluster name | `ai-devsecops` |
| `node_count` | Initial node count | `3` |
| `node_type` | VM size / instance type | `t3.medium` |

## Usage

```bash
cd infra/terraform/<provider>
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

After the cluster is ready, update your kubeconfig and apply the Kustomize overlay:

```bash
# AWS example
aws eks update-kubeconfig --region <REGION> --name <CLUSTER_NAME>

# Deploy
kubectl apply -k k8s/overlays/prod
```

## Security Notes

- **Never commit** `*.tfstate`, `*.tfplan`, or `.terraform/` — add them to `.gitignore`.
- Use remote state (S3 + DynamoDB, Azure Blob, GCS) with state locking for team use.
- Rotate cloud credentials used by Terraform regularly; prefer OIDC/Workload Identity where available.
