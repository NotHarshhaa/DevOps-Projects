 # 2 private subnet for database
resource "aws_subnet" "rds_1" {
  cidr_block        = "10.0.5.0/24"
  availability_zone = "ap-south-1a"
  vpc_id            = module.eks_network.vpc_id

  tags = {
    Name = "RDS Private Subnet 1"
  }
}

resource "aws_subnet" "rds_2" {
  cidr_block        = "10.0.6.0/24"
  availability_zone = "ap-south-1b"
  vpc_id            = module.eks_network.vpc_id

  tags = {
    Name = "RDS Private Subnet 2"
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.environment}-rds-sg"
  vpc_id      = module.eks_network.vpc_id
  description = "allow inbound access from the ECS only"

  ingress {
    protocol        = "tcp"
    from_port       = 5432
    to_port         = 5432
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "postgres" {
  identifier            = "${var.prefix}-${var.environment}-db"
  allocated_storage     = var.db_default_settings.allocated_storage
  max_allocated_storage = var.db_default_settings.max_allocated_storage
  engine                = "postgres"
  engine_version        = 14.15
  instance_class        = var.db_default_settings.instance_class
  username              = var.db_default_settings.db_admin_username
  password              = random_password.dbs_random_string.result
  port                  = 5432
  publicly_accessible   = false
  db_subnet_group_name  = aws_db_subnet_group.postgres.id
  ca_cert_identifier    = var.db_default_settings.ca_cert_name
  storage_encrypted     = true
  storage_type          = "gp3"
  kms_key_id            = aws_kms_key.env_kms.arn
  skip_final_snapshot   = true
  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  backup_retention_period    = var.db_default_settings.backup_retention_period
  db_name                    = var.db_default_settings.db_name
  auto_minor_version_upgrade = true
  deletion_protection        = false
  copy_tags_to_snapshot      = true

  tags = {
    environment = var.environment
  }
}

resource "random_password" "dbs_random_string" {
  length           = 10
  special          = false
  override_special = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
}

resource "aws_secretsmanager_secret" "db_link" {
  name                    = "db/${aws_db_instance.postgres.identifier}"
  description             = "DB link"
  kms_key_id              = aws_kms_key.env_kms.arn
  recovery_window_in_days = 7
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_secretsmanager_secret_version" "dbs_secret_val" {
  secret_id     = aws_secretsmanager_secret.db_link.id
  secret_string = "postgresql://${var.db_default_settings.db_admin_username}:${random_password.dbs_random_string.result}@${aws_db_instance.postgres.address}:${aws_db_instance.postgres.port}/${aws_db_instance.postgres.db_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "postgres" {
  name        = "${var.prefix}-${var.environment}-rds-db-subnet-group"
  description = "Subnet group for RDS instance"
  subnet_ids = [
    aws_subnet.rds_1.id,
    aws_subnet.rds_2.id
  ]
  # subnet_ids =["subnet-0f42a1b9efaf4e602", "subnet-0395e32fc16981198"]

  tags = {
    Name        = "${var.prefix}-${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_kms_key" "env_kms" {
  description             = "KMS key for RDS and Secrets Manager"
  deletion_window_in_days = 7

  tags = {
    Name        = "${var.prefix}-${var.environment}-rds-kms-key"
    Environment = var.environment
  }
}

resource "aws_kms_alias" "env_kms_alias" {
  name          = "alias/${var.environment}-rds-kms-key"
  target_key_id = aws_kms_key.env_kms.id
}