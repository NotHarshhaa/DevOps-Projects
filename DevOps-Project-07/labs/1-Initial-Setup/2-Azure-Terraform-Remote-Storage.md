# Azure Terraform Setup

The purpose of this lab is to create the location that will store the remote Terraform State file

When deploying Terraform there is a requirement that it must store a state file; this file is used by Terraform to map Azure Resources to your configuration that you want to deploy, keeps track of meta data and can also assist with improving performance for larger Azure Resource deployments.

## Create Blob Storage location for Terraform State file
1. Edit the [variables](labs/1-Initial-Setup/scripts/create-terraform-storage.sh#L3-L4)
2. Run the script `./scripts/create-terraform-storage.sh`
3. The script will create
- Azure Resource Group
- Azure Storage Account
- Azure Blob storage location within Azure Storage Account