# resource for rds DB instance
resource "aws_db_instance" "rds_instance" {
  identifier              = var.rds_instance_identifier
  instance_class          = var.rds_instance_class
  engine                  = var.rds_engine
  engine_version          = var.rds_engine_version
  username                = var.rds_master_username
  password                = var.rds_master_password
  db_name                 = var.rds_database_name
  allocated_storage       = var.rds_storage_size
  backup_retention_period = var.rds_backup_retention_period
  skip_final_snapshot     = var.rds_skip_final_snapshot
  vpc_security_group_ids  = var.vpc_security_group_ids
  db_subnet_group_name    = var.db_subnet_group_name    
  storage_type            = var.rds_storage_type
  multi_az                = var.rds_multi_az
  apply_immediately        = true
  publicly_accessible = true
  tags = merge(
    {
    Name        = var.rds_instance_identifier
    Environment = var.environment
    },
    var.common_tags
  )
  lifecycle {
    ignore_changes = [
      password,
      username,
      db_name,
      backup_retention_period,
      skip_final_snapshot,
      vpc_security_group_ids,
      db_subnet_group_name,
      allocated_storage,
      storage_type,
      multi_az,
      apply_immediately
    ]
  }
}
