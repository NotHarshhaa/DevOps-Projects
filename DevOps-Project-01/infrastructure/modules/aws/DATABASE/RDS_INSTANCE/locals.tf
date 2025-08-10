# Define Local Values in Terraform
locals {
  owners      = var.business_division
  environment = var.environment
  Role        = var.Role
  name        = "${var.business_division}-${var.environment}"
  #name = "${local.owners}-${local.environment}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
    Role        = local.Role
  }
}

