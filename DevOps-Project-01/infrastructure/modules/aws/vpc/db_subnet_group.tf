resource "aws_db_subnet_group" "db_subnet_group" {
  count      = var.vpc_create_database_subnet_group ? 1 : 0
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = [aws_subnet.DB_subnet1.id, aws_subnet.DB_subnet2.id]

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}