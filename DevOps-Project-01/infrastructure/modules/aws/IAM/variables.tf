
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
variable "iam_instance_profile_name" {
  description = "IAM instance profile name to attach to the EC2 instance"
  type        = string
  default     = ""
  
}
variable "iam_role_name" {
  description = "IAM role name to attach to the EC2 instance"
  type        = string
  default     = ""  
  
}
variable "flow_log_role" {  
  description = "IAM role name to attach to the VPC flow logs"
  type        = string
  default     = ""
  
}
