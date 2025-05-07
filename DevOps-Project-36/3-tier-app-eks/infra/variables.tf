variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "DevOpsDojo"
}

variable "github_repositories" {
  description = "List of GitHub repositories to grant access to"
  type = list(object({
    org    = string
    repo   = string
    branch = string
  }))
  default = [
    {
      org    = "akhileshmishrabiz"
      repo   = "DevOpsDojo"
      branch = "*"
    }
  ]
}


variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
variable "prefix" {
  description = "Prefix to be used for all resources"
  type        = string
  default     = "bootcamp"
}

variable "db_default_settings" {
  type = any
  default = {
    allocated_storage       = 30
    max_allocated_storage   = 50
    engine_version          = 14.15
    instance_class          = "db.t3.micro"
    backup_retention_period = 2
    db_name                 = "postgres"
    ca_cert_name            = "rds-ca-rsa2048-g1"
    db_admin_username       = "postgres"
  }
}