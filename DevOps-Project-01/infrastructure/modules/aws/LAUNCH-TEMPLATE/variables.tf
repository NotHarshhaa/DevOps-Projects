variable "instance_type" {
  description = "value of instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = "terraform-key"
}

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

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
}
variable "template_name" {
  description = "Name of the launch template"
  type        = string
}

variable "user_data_script" {
  description = "User data script filename"
  type        = string
}

variable "public_ip" {
  description = "Whether to assign public IP"
  type        = bool
  default     = false
}

variable "instance_name" {
  description = "Name tag for instances created by this launch template"
  type        = string
}