# Setting Up SSL with cert-manager for Route 53 Domain in Kubernetes

I'll guide you through setting up SSL certificates with cert-manager for your Route 53 domain. This approach uses Let's Encrypt and DNS validation via Route 53 to issue free, auto-renewing certificates.

## Step 1: Install cert-manager

First, let's install cert-manager in your Kubernetes cluster:

```bash
# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Install cert-manager with CRDs
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.13.3 \
  --set installCRDs=true

# Verify the installation
kubectl get pods -n cert-manager
```

Ensure all pods are in the `Running` state before proceeding.

## Step 2: Set Up IAM Permissions for Route 53

cert-manager needs permissions to create DNS records in Route 53 for validation:

```bash
# Create IAM policy
cat > route53-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "route53:GetChange",
      "Resource": "arn:aws:route53:::change/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets"
      ],
      "Resource": "arn:aws:route53:::hostedzone/*"
    },
    {
      "Effect": "Allow",
      "Action": "route53:ListHostedZonesByName",
      "Resource": "*"
    }
  ]
}
EOF

# Create the policy
aws iam create-policy \
  --policy-name CertManagerRoute53 \
  --policy-document file://route53-policy.json

# Get policy ARN (save this for the next step)
aws iam list-policies --query 'Policies[?PolicyName==`CertManagerRoute53`].Arn' --output text
```

## Step 3: Create IAM Role for cert-manager

Create an IAM role that cert-manager will use:

```bash
# Get your OIDC provider URL
export CLUSTER_NAME=devopsdozo
export OIDC_PROVIDER=$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")

# Create trust relationship
cat > trust-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):oidc-provider/${OIDC_PROVIDER}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${OIDC_PROVIDER}:sub": "system:serviceaccount:cert-manager:cert-manager"
        }
      }
    }
  ]
}
EOF

# Create role
aws iam create-role \
  --role-name CertManagerRoute53Role \
  --assume-role-policy-document file://trust-policy.json

# Attach policy to role
aws iam attach-role-policy \
  --role-name CertManagerRoute53Role \
  --policy-arn arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):policy/CertManagerRoute53

# Get the role ARN (save this for later)
export ROLE_ARN=$(aws iam get-role --role-name CertManagerRoute53Role --query Role.Arn --output text)
echo $ROLE_ARN
```

## Step 4: Update cert-manager ServiceAccount

Add the IAM role annotation to the cert-manager ServiceAccount:

```bash
kubectl annotate serviceaccount cert-manager \
  --namespace cert-manager \
  eks.amazonaws.com/role-arn=$ROLE_ARN

# Restart cert-manager to pick up the new role
kubectl rollout restart deployment cert-manager -n cert-manager
```

## Step 5: Get Your Route 53 Hosted Zone ID

Identify your Route 53 hosted zone ID:

```bash
# Replace with your domain
export DOMAIN="example.com"
export HOSTED_ZONE_ID=$(aws route53 list-hosted-zones-by-name \
  --dns-name $DOMAIN \
  --query "HostedZones[0].Id" \
  --output text | sed 's/\/hostedzone\///')
echo $HOSTED_ZONE_ID
```

## Step 6: Create a ClusterIssuer for Let's Encrypt


```bash
# Replace placeholders in the file
sed -i "s/your-email@example.com/your-actual-email@example.com/g" cluster-issuer.yaml
sed -i "s/example.com/$DOMAIN/g" cluster-issuer.yaml
sed -i "s/REPLACE_WITH_YOUR_HOSTED_ZONE_ID/$HOSTED_ZONE_ID/g" cluster-issuer.yaml

# Apply the ClusterIssuer
kubectl apply -f cluster-issuer.yaml

# Verify it was created
kubectl get clusterissuer letsencrypt-prod -o wide
```

## Step 7: Create a Certificate Resource



```bash
# Replace placeholders
sed -i "s/example.com/$DOMAIN/g" certificate.yaml

# Apply the Certificate
kubectl apply -f certificate.yaml

# Monitor the certificate issuance
kubectl get certificate -n devopsdozo
kubectl get certificaterequest -n devopsdozo
kubectl get order -n devopsdozo
kubectl get challenge -n devopsdozo
```

Certificate issuance may take a few minutes as DNS propagation occurs.

## Step 8: Update Your Ingress to Use the TLS Certificate


Apply the updated ingress:

```bash
# Replace the domain name placeholder
sed -i "s/example.com/$DOMAIN/g" tls-ingress.yaml

# Apply the updated ingress
kubectl apply -f tls-ingress.yaml
```

## Step 9: Verify the Setup

Check that everything is working correctly:

```bash
# Check certificate status
kubectl get certificate -n devopsdozo

# Check the secret was created
kubectl get secret example-com-tls -n devopsdozo

# Check the ingress is configured correctly
kubectl describe ingress devopsdozo-ingress -n devopsdozo
```

## Step 10: Test HTTPS Access

Once DNS propagation is complete and the certificate is issued:

1. Open your browser and navigate to `https://yourdomain.com`
2. Verify the secure lock icon appears in the browser
3. Check certificate details by clicking on the lock icon

## Troubleshooting Guide

If you encounter issues:

### Certificate Issuance Issues

```bash
# Check certificate status
kubectl describe certificate example-com-tls -n devopsdozo

# Check certificate request
kubectl describe certificaterequest -n devopsdozo

# Check challenges
kubectl describe challenges -n devopsdozo

# Check cert-manager logs
kubectl logs -n cert-manager -l app=cert-manager
```

### Ingress Issues

```bash
# Check ALB controller logs
kubectl logs -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller

# Check the created ALB in AWS Console
aws elbv2 describe-load-balancers

# Check Target Group health
aws elbv2 describe-target-health --target-group-arn <target-group-arn>
```

### Route 53 Issues

```bash
# Check if the validation records were created
aws route53 list-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID | grep -A 2 _acme-challenge
```
