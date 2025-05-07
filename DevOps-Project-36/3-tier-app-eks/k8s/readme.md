# DevOps Learning Platform - EKS Deployment Guide

## Prerequisites
- AWS CLI installed and configured
- kubectl installed and configured
- eksctl installed
- Helm installed
- Docker installed

## Step 1: Clone the Repository and Organize Kubernetes Manifests

```bash
# Clone your repository (assuming you have one)
git clone https://github.com/kubernetes-zero-to-hero.git
cd 3-tier-app-eks/
```


## Step 2: Create the EKS Cluster -> EKS AUTOmode from UI

# Normal cluster

```bash
eksctl create cluster \
  --name Akhilesh-cluster \
  --region eu-west-1 \
  --version 1.31 \
  --nodegroup-name standard-workers \
  --node-type t3.medium \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 3 \
  --managed
  

aws eks list-clusters

# Replace my-cluster with your cluster name from the list-clusters output
export cluster_name=Akhilesh-cluster # Name of the cluster
echo $cluster_name

aws eks update-kubeconfig --name $cluster_name --region eu-west-1

kubectl config get-contexts

kubectl config current-context

```

## Step 3: Create the RDS PostgreSQL Database

```bash
# VPC ID associated with your cluster
aws eks describe-cluster --name Akhilesh-cluster --region eu-west-1 --query "cluster.resourcesVpcConfig.vpcId" --output text

# Get VPC ID
VPC_ID=$(aws eks describe-cluster --name Akhilesh-cluster --region eu-west-1 --query "cluster.resourcesVpcConfig.vpcId" --output text)

# Find private subnets (subnets without a route to an internet gateway)
PRIVATE_SUBNET_IDS=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query "Subnets[?MapPublicIpOnLaunch==\`false\`].SubnetId" \
  --output text \
  --region eu-west-1)

# Create a subnet group using only private subnet
aws rds create-db-subnet-group \
  --db-subnet-group-name akhilesh-postgres-private-subnet-group \
  --db-subnet-group-description "Private subnet group for Akhilesh PostgreSQL RDS" \
  --subnet-ids subnet-0115609bc602b388e	subnet-0611f6ecae28a510c	subnet-00a21441953091d88 \
  --region eu-west-1


# Create security group for rds
aws ec2 create-security-group \
  --group-name postgressg \
  --description "SG for RDS" \
  --vpc-id $VPC_ID \
  --region eu-west-1

# Store the security group ID
SG_ID=$(aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=postgressg" "Name=vpc-id,Values=$VPC_ID" \
  --query "SecurityGroups[0].GroupId" \
  --output text \
  --region eu-west-1)

# get the SG attached with cluster nodes:
NODE_SG=$(aws eks describe-cluster --name Akhilesh-cluster --region eu-west-1 \
  --query "cluster.resourcesVpcConfig.securityGroupIds[0]" --output text)

# Allow cluster to reach rds on port 5432
aws ec2 authorize-security-group-ingress \
  --group-id sg-02b8f5325b7833969 \
  --protocol tcp \
  --port 5432 \
  --source-group $NODE_SG \
  --region eu-west-1

# create the PostgreSQL RDS instance in the private subnet group
aws rds create-db-instance \
  --db-instance-identifier akhilesh-postgres  \
  --db-instance-class db.t3.small \
  --engine postgres \
  --engine-version 15 \
  --allocated-storage 20 \
  --master-username postgresadmin \
  --master-user-password YourStrongPassword123! \
  --db-subnet-group-name akhilesh-postgres-private-subnet-group \
  --vpc-security-group-ids $SG_ID \
  --no-publicly-accessible \
  --backup-retention-period 7 \
  --multi-az \
  --storage-type gp2 \
  --region eu-west-1
```


Make sure to:
1. Create a security group that allows inbound traffic on port 5432 from your EKS cluster's VPC
2. Create a DB subnet group that includes subnets in at least two availability zones



## Step 4: Update Database Connection in ConfigMap

Edit the `secrets.yaml` file to update the database connection string:

```yaml
DATABASE_URL: "postgresql://postgres:<strong-password>@devops-learning-db.<your-db-endpoint>.us-west-2.rds.amazonaws.com:5432/devops_learning"
```

Replace `<strong-password>` and `<your-db-endpoint>` with your actual values.

## Step 5: Deploy the Application
Backend image: livingdevopswithakhilesh/devopsdozo:backend-latest
Frontend image: livingdevopswithakhilesh/devopsdozo:frontend-latest

```bash
# Apply Kubernetes manifests
kubectl apply -f namespace.yaml
kubectl apply -f database-service.yaml
kubectl apply -f secrets.yaml
kubectl apply -f backend.yaml
kubectl apply -f frontend.yaml
kubectl apply -f horizontal-pod-autoscaler.yaml
kubectl apply -f ingress.yaml

# verify the db dns
kubectl run -it --rm --restart=Never dns-test --image=tutum/dnsutils -- dig postgres-db.3-tier-app-eks.svc.cluster.local
# Verify deployments
kubectl get pods -n 3-tier-app-eks
kubectl get svc -n 3-tier-app-eks
kubectl get ingress -n 3-tier-app-eks

kubectl logs -n 3-tier-app-eks -l app=backend

kubectl logs -n 3-tier-app-eks -l app=frontend

# access the app locally
# port forward backend
kubectl port-forward -n devops-learning svc/backend 8000:8000

curl http://localhost:8000/api/topics

## to check the db connection for troubleshooting
kubectl run debug-pod --rm -it --image=postgres -- bash
PGPASSWORD=postgrespassword psql -h devops-learning-db.devops-learning.svc.cluster.local -U postgres -d devops_learning
# run query
SELECT COUNT(*) FROM topics;


# port forward the frontend 
kubectl port-forward svc/frontend 8080:80 -n devops-learning

```

## Step 6: Configure ALB Ingress Controller

The AWS Application Load Balancer (ALB) Ingress Controller is required for the ingress resource:

```bash

# resource: https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html
export cluster_name=Akhilesh-cluster
oidc_id=$(aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
echo $oidc_id
# Check if IAM OIDC provider with your cluster’s issuer ID 
aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4

# If not, create
eksctl utils associate-iam-oidc-provider --cluster $cluster_name --approve

# or use console
-> To create a provider, go to IAM, choose Add provider.
-> For Provider type, select OpenID Connect.
-> For Provider URL, enter the OIDC provider URL for your cluster.
-> For Audience, enter sts.amazonaws.com.
-> (Optional) Add any tags, for example a tag to identify which cluster is for this provider.
-> Choose Add provider.

# IAM policy for loadbalancder controller -> You only need to create an IAM Role for the AWS Load Balancer Controller once per AWS # account. Check if AmazonEKSLoadBalancerControllerRole 
# Resource https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html

curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json

eksctl create iamserviceaccount \
  --cluster=$cluster_name \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::163962798700:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve

# Install the AWS Load Balancer Controller
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"

# install helm 
brew install helm # (for mac)
helm repo add eks https://aws.github.io/eks-charts
helm repo update
VPC_ID=$(aws eks describe-cluster --name Akhilesh-cluster --region eu-west-1 --query "cluster.resourcesVpcConfig.vpcId" --output text)

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$cluster_name \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set $VPC_ID \
  --set region=eu-west-1

```

## Step 8: Access the Application via engress

After deployment, find the ALB URL:

```bash
kubectl get ingress -n 3-tier-app-eks

# After ingress creation
kubectl logs -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller

# VPC_ID for cluster
VPC_ID=$(aws eks describe-cluster --name Akhilesh-cluster --region eu-west-1 --query "cluster.resourcesVpcConfig.vpcId" --output text)

# verify the vpc id
echo $VPC_ID

# Public subnets for the cluster
aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" "Name=map-public-ip-on-launch,Values=true" \
--query "Subnets[*].{SubnetId:SubnetId,AvailabilityZone:AvailabilityZone,PublicIp:MapPublicIpOnLaunch}"

# Get the list of subnets id's from above commands and run this
aws ec2 create-tags --resources subnet-05c313851d6e027e0 subnet-002f8dde08d2f1643 \
subnet-0f8aabbf5f8538d81 --tags Key=kubernetes.io/role/elb,Value=1

# Verify the tags
aws ec2 describe-subnets --subnet-ids ubnet-05c313851d6e027e0 subnet-002f8dde08d2f1643 \
subnet-0f8aabbf5f8538d81 --query "Subnets[*].{SubnetId:SubnetId,Tags:Tags}"

# For private subnets (used by internal load balancers) - if needed later
# aws ec2 create-tags --resources subnet-id3 subnet-id4 --tags Key=kubernetes.io/role/internal-elb,Value=1

# verify tags
aws ec2 describe-subnets --subnet-ids subnet-id1 subnet-id2 --query "Subnets[*].{SubnetId:SubnetId,Tags:Tags}" --output table

# delete and recreate ingress
kubectl delete ingress 3-tier-app-ingress -n 3-tier-app-eks --grace-period=0 --force
kubectl apply -f k8s/ingress.yaml

# check the status again
kubectl describe ingress devops-learning-ingress -n devops-learning


# Monitor the AWS Load Balancer Controller logs to see if it's processing your Ingress:
kubectl logs -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller

# check if the ALB created -> in ec2 dashboard
```


#This will give you the external address of the ALB. Use this address to access your application.

## Step 9: Set up DNS (Optional)

```bash

aws route53 create-hosted-zone \
  --name akhileshmishra.tech \
  --caller-reference $(date +%s) \
  --hosted-zone-config Comment="Public hosted zone for akhileshmishra.tech"

# Get the ALB DNS name from the Ingress
ALB_DNS=$(kubectl get ingress 3-tier-app-ingress -n 3-tier-app-eks -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "ALB DNS Name: $ALB_DNS"

# Get the hosted zone ID for your domain
ZONE_ID=$(aws route53 list-hosted-zones-by-name --dns-name akhileshmishra.tech --query "HostedZones[0].Id" --output text | sed 's/\/hostedzone\///')
echo "Hosted Zone ID: $ZONE_ID"

# Create an A record alias pointing to the ALB
aws route53 change-resource-record-sets \
  --hosted-zone-id $ZONE_ID \
  --change-batch '{
    "Changes": [
      {
        "Action": "UPSERT",
        "ResourceRecordSet": {
          "Name": "app.akhileshmishra.tech",
          "Type": "A",
          "AliasTarget": {
            "HostedZoneId": "Z32O12XQLNTSW2",
            "DNSName": "'$ALB_DNS'",
            "EvaluateTargetHealth": true
          }
        }
      }
    ]
  }'

  ```
## Troubleshooting

### Check Pod Logs
```bash
kubectl logs -f deploy/backend -n devops-learning
kubectl logs -f deploy/frontend -n devops-learning
```

### Check Pod Status
```bash
kubectl describe pod -l app=backend -n devops-learning
kubectl describe pod -l app=frontend -n devops-learning
```

### Restart Deployments
```bash
kubectl rollout restart deployment backend -n devops-learning
kubectl rollout restart deployment frontend -n devops-learning
```


## Step 4: Build and Push Docker Images

```bash
# Log in to Amazon ECR
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 163962798700.dkr.ecr.eu-west-1.amazonaws.com

# Create ECR repositories
aws ecr create-repository --repository-name devops-learning/frontend
aws ecr create-repository --repository-name devops-learning/backend

# Build and push images
docker build -t 163962798700.dkr.ecr.eu-west-1.amazonaws.com/devops-learning/frontend:latest --platform=linux/amd64 ./frontend
docker build -t 163962798700.dkr.ecr.eu-west-1.amazonaws.com/devops-learning/backend:latest --platform=linux/amd64  ./backend

docker push 163962798700.dkr.ecr.eu-west-1.amazonaws.com/devops-learning/frontend:latest
docker push 163962798700.dkr.ecr.eu-west-1.amazonaws.com/devops-learning/backend:latest
```

Replace `163962798700` with your AWS account ID.





########### Monitoring  #######

##Set Up Monitoring and Logging

Run the setup-monitoring.sh script:

```bash
chmod +x setup-monitoring.sh
./setup-monitoring.sh

# Troubleshooting if prom/grafana pods dont come up
# -> check if the storage is provisioned -> check pvc, descrobe and see the events 
# issue might be with csi driver for storage 

kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-ebs-csi-driver

# EBS CSI driver in your EKS cluster
######### or use EKSCTL #############################################################

# Create IAM policy
# https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/example-iam-policy.json
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json
aws iam create-policy \
  --policy-name AmazonEKS_EBS_CSI_Driver_Policy \
  --policy-document file://example-iam-policy.json

# Create service account with role
eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster $cluster_name \
  --attach-policy-arn arn:aws:iam::163962798700:policy/AmazonEKS_EBS_CSI_Driver_Policy \
  --approve \
  --role-name AmazonEKS_EBS_CSI_Driver_Role

## Install the EBS CSI driver using the AWS EKS add-on:

eksctl create addon \
  --name aws-ebs-csi-driver \
  --cluster $cluster_name \
  --service-account-role-arn arn:aws:iam::163962798700:role/AmazonEKS_EBS_CSI_Driver_Role \
  --force

# verify installation
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-ebs-csi-driver
######### ### #############################################################

######### or use helm #############################################################
# If not installing with eksctl
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update
helm upgrade --install aws-ebs-csi-driver \
  --namespace kube-system \
  aws-ebs-csi-driver/aws-ebs-csi-driver

# verify
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-ebs-csi-driver
######### ### #############################################################

# Now reinstall grafana and promethus
helm uninstall prometheus -n monitoring
helm uninstall grafana -n monitoring

./setup-monitoring.sh


# Install AWS CloudWatch Logs agent
kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cloudwatch-namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-serviceaccount.yaml
kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-configmap.yaml
kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-daemonset.yaml


# Quick access 
# For Prometheus
kubectl port-forward -n monitoring svc/prometheus-server 9090:80

# For Grafana
kubectl port-forward -n monitoring svc/grafana 3000:80

```
