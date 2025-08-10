output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
  
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}
output "DB_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [aws_subnet.DB_subnet1.id, aws_subnet.DB_subnet2.id]
}
output "nat_gateway_ip" {
  description = "Public IP of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  value       = var.vpc_create_database_subnet_group ? aws_db_subnet_group.db_subnet_group[0].name : null
}
