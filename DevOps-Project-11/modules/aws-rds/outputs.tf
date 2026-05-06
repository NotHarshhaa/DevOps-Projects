output "rds_cluster_endpoint" {
  description = "The writer endpoint of the Aurora RDS cluster"
  value       = aws_rds_cluster.rds-cluster.endpoint
}

output "rds_reader_endpoint" {
  description = "The reader endpoint of the Aurora RDS cluster"
  value       = aws_rds_cluster.rds-cluster.reader_endpoint
}

output "rds_cluster_port" {
  description = "The port of the Aurora RDS cluster"
  value       = aws_rds_cluster.rds-cluster.port
}
