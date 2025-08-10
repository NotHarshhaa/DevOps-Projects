# outputs for RDS DB instances
output "name" {
  description = "rds instance identifier"
  value       = aws_db_instance.rds_instance.identifier
}
output "endpoint" {
  description = "rds instance endpoint"
  value       = aws_db_instance.rds_instance.endpoint
}
output "database_name" {
  description = "rds instance database name"
  value       = aws_db_instance.rds_instance.db_name
}
output "username" {
  description = "rds instance username"
  value       = aws_db_instance.rds_instance.username
}
output "port" {
  description = "rds instance port"
  value       = aws_db_instance.rds_instance.port
}
output "arn" {
  description = "rds instance arn"
  value       = aws_db_instance.rds_instance.arn
}
# outputs for RDS DB instances
output "db_instance_id" {
  description = "rds instance id"
    value       = aws_db_instance.rds_instance.id
  
}
output "db_instance_endpoint" {
  description = "rds instance endpoint"
    value       = aws_db_instance.rds_instance.endpoint
  
}
output "db_instance_port" {
  description = "rds instance port"
    value       = aws_db_instance.rds_instance.port 
}
output "db_instance_arn" {
  description = "rds instance arn"
    value       = aws_db_instance.rds_instance.arn
  
}
output "db_instance_db_name" {
  description = "rds instance db name"
    value       = aws_db_instance.rds_instance.db_name
  
}
output "db_instance_username" {
  description = "rds instance username"
    value       = aws_db_instance.rds_instance.username
}
output "db_instance_password" {
  description = "rds instance password"
    value       = aws_db_instance.rds_instance.password
}   
output "db_instance_db_subnet_group_name" {
  description = "rds instance db subnet group name"
    value       = aws_db_instance.rds_instance.db_subnet_group_name
}
output "db_instance_vpc_security_group_ids" {
  description = "rds instance vpc security group ids"
    value       = aws_db_instance.rds_instance.vpc_security_group_ids
}
output "db_instance_availability_zone" {
  description = "rds instance availability zone"
    value       = aws_db_instance.rds_instance.availability_zone
}
output "db_instance_backup_retention_period" {
  description = "rds instance backup retention period"
    value       = aws_db_instance.rds_instance.backup_retention_period
}

output "db_instance_allocated_storage" {
  description = "rds instance allocated storage"
    value       = aws_db_instance.rds_instance.allocated_storage
}
output "db_instance_storage_type" {
  description = "rds instance storage type"
    value       = aws_db_instance.rds_instance.storage_type
}
output "db_instance_multi_az" {
  description = "rds instance multi az"
    value       = aws_db_instance.rds_instance.multi_az
}
output "db_instance_apply_immediately" {
  description = "rds instance apply immediately"
    value       = aws_db_instance.rds_instance.apply_immediately
}
output "db_instance_skip_final_snapshot" {
  description = "rds instance skip final snapshot"
    value       = aws_db_instance.rds_instance.skip_final_snapshot
}
output "db_instance_instance_class" {
  description = "rds instance class"
    value       = aws_db_instance.rds_instance.instance_class
}
output "db_instance_instance_identifier" {
  description = "rds instance identifier"
    value       = aws_db_instance.rds_instance.id
}
output "db_instance_engine" {
  description = "rds instance engine"
    value       = aws_db_instance.rds_instance.engine
}
output "db_instance_engine_version" {
  description = "rds instance engine version"
    value       = aws_db_instance.rds_instance.engine_version
}
output "db_instance_name" {
  description = "rds instance name"
    value       = aws_db_instance.rds_instance.db_name
}
output "db_instance_tags" {
  description = "rds instance tags"
  value       = aws_db_instance.rds_instance.tags
}
output "db_instance_role" {
  description = "rds instance role"
  value       = var.Role
}