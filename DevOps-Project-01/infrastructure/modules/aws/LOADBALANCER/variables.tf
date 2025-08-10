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
variable "load_balancer_type" {
  description = "Type of the load balancer"
  type        = string
  default     = "application"
}
variable "load_balancer_behavior" {
  description = "internal or external facing load balancer"
  type        = bool
  default     = false  
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}
variable "target_group_arn" {
  description = "ARN of the target group"
  type        = string
  default     = ""
}

variable "tomcat_target_group_arn" {
  description = "ARN of the Tomcat target group"
  type        = string
  default     = ""
}

variable "lb_name" {
  description = "Name of the load balancer"
  type        = string
}

variable "listener_port" {
  description = "Port for the load balancer listener"
  type        = number
  default     = 80
}