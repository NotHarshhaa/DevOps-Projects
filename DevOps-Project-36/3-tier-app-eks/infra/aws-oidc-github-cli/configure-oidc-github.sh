#!/bin/bash
set -e

export OIDC_PROVIDER="token.actions.githubusercontent.com"
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
export GITHUB_ORG="akhileshmishrabiz"
export GITHUB_REPO="DevOpsDojo"

# Create the OIDC provider
aws iam create-open-id-connect-provider \
  --url https://$OIDC_PROVIDER \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list "6938fd4d98bab03faadb97b34396831e3780aea1"

aws iam create-role \
  --role-name GitHubActionsEKSDeployRole \
  --assume-role-policy-document file://trust-policy.json


aws iam create-policy \
  --policy-name GitHubActionsEKSPolicy \
  --policy-document file://eks-policy.json

# Attach the policy to the role
aws iam attach-role-policy \
  --role-name GitHubActionsEKSDeployRole \
  --policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/GitHubActionsEKSPolicy

