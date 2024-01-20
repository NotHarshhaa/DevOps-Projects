# 8 Creating DB subnet group for RDS Instances
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.sg-name
  subnet_ids = [data.aws_subnet.private-subnet1.id, data.aws_subnet.private-subnet2.id]
}


# Creating Aurora RDS Cluster, username and password used only for practice, otherwise follow DevOps best practices to keep it secret
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "aurora-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.02.2"
  master_username         = var.rds-username
  master_password         = var.rds-pwd
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  database_name           = var.db-name
  port                    = 3306
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [data.aws_security_group.db-sg.id]
  tags = {
    Name = var.rds-name
  }
}

# Creating RDS Cluster instance
resource "aws_rds_cluster_instance" "primary_instance" {
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  identifier         = "primary-instance"
  instance_class     = "db.r5.large"
  engine             = aws_rds_cluster.aurora_cluster.engine
  engine_version     = aws_rds_cluster.aurora_cluster.engine_version
}

# Creating RDS Read Replica Instance
resource "aws_rds_cluster_instance" "read_replica_instance" {
  count              = 1
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  identifier         = "read-replica-instance-${count.index}"
  instance_class     = "db.r5.large"
  engine             = aws_rds_cluster.aurora_cluster.engine

  depends_on = [aws_rds_cluster_instance.primary_instance]
}