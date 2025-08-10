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
variable "rds_instance_type" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.medium"
}
variable "rds_engine" {
  description = "RDS engine type"
  type        = string
  default     = "mysql"
}
variable "rds_engine_version" {
  description = "RDS engine version"
  type        = string
  default     = "8.0"
}
variable "rds_master_username" {
  description = "RDS master username"
  type        = string        
  default     = "admin"
}
variable "rds_master_password" {
  description = "RDS master password"
  type        = string
  default     = "password123"
}
variable "rds_database_name" {
  description = "RDS database name"
  type        = string
  default     = "mydatabase"
}
variable "rds_backup_retention_period" {
  description = "RDS backup retention period in days"
  type        = number
  default     = 7
}
variable "rds_preferred_backup_window" {
  description = "RDS preferred backup window"
  type        = string
  default     = "07:00-09:00"
}
variable "rds_preferred_maintenance_window" {
  description = "RDS preferred maintenance window"
  type        = string
  default     = "sun:23:00-sun:23:30"
}     
variable "rds_skip_final_snapshot" {
  description = "RDS skip final snapshot"
  type        = bool
  default     = true
} 
variable "vpc_security_group_ids" {
  description = "VPC security group IDs for RDS"
  type        = list(string)
  default     = []
}
variable "subnet_ids" {
  description = "Subnet IDs for RDS"
  type        = list(string)
  default     = []
  
}
variable "db_subnet_group_name" {
  description = "DB subnet group name for RDS"
  type        = string
  default     = ""
}
variable "cluster_identifier" {
  description = "RDS cluster identifier"
  type        = string
  default     = "my-rds-cluster"
}
variable "common_tags" {
  description = "Common tags for RDS resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    BusinessDivision = "DevOps"
  }
} 
variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}   
variable "rds_storage_type" {
  description = "RDS storage type"
  type        = string
  default     = "gp2"
}
variable "rds_storage_size" {
  description = "RDS storage size in GB"
  type        = number
  default     = 20
}
variable "rds_multi_az" {
  description = "RDS multi AZ"
  type        = bool
  default     = false
}
variable "rds_publicly_accessible" {
  description = "RDS publicly accessible"
  type        = bool
  default     = false
}
variable "rds_enable_iam_database_authentication" {
  description = "Enable IAM database authentication for RDS"
  type        = bool
  default     = false
}
variable "rds_enable_performance_insights" {
  description = "Enable performance insights for RDS"
  type        = bool
  default     = false
}
variable "rds_performance_insights_retention_period" {
  description = "Performance insights retention period in days"
  type        = number
  default     = 7
}
variable "rds_enable_cloudwatch_logs_exports" {
  description = "Enable CloudWatch logs exports for RDS"
  type        = list(string)
  default     = []
}
variable "rds_enable_enhanced_monitoring" {
  description = "Enable enhanced monitoring for RDS"
  type        = bool
  default     = false
}
variable "rds_monitoring_interval" {
  description = "Monitoring interval in seconds for RDS"
  type        = number
  default     = 60
}
variable "rds_monitoring_role_arn" {
  description = "Monitoring role ARN for RDS"     
  type        = string  
  default     = ""
}
variable "rds_tags" {
  description = "Tags for RDS resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    BusinessDivision = "DevOps"
  }
}
variable "rds_instance_identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "my-rds-instance"
  
}