variable "business_division" {
  description = "Business Division of project"
  type        = string
  default     = "DevOps"
}
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
variable "Role" {
  description = "Role of the instance"
  type        = list(string)
  default     = ["ASG"]
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}