variable "instance_type" {}

variable "key_name" {}

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

variable "launch_template_id" {
  description = "Launch template ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "target_group_arns" {
  description = "List of target group ARNs"
  type        = list(string)
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
}