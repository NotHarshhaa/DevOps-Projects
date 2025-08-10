variable "ami" {
  type = string
  description = "AMI ID for the EC2 instance"
  default     = "ami-0f918f7e67a3323f0" # Replace with a valid AMI ID
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "name" {
  type = string
}
variable "Role" {
  description = "Role of the instance"
  type        = list(string)
  default = [ "master", "agent", "sonar" ]
  
}
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"

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
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = "terraform-key" # Replace with your key pair name
  
}
variable "security_group_ids" {
  description = "List of security group IDs to associate with the instance"
  type        = list(string)
  default     = []
  
}
variable "tags" {
  description = "Tags to apply to the EC2 instance"
  type        = map(string)
  default     = {}
  
}
variable "user_data" {
  type    = string
  default = ""
  description = "User data script to be passed to the instance"
}
variable "iam_instance_profile_name" {
  description = "IAM instance profile name to attach to the EC2 instance"
  type        = string
  default     = ""
}

variable "windows_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.medium"
}

variable "linux_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

