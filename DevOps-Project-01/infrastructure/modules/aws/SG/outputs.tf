
output "ssh_sg_id" {
  value = aws_security_group.ssh_sg.id
  description = "List of security group IDs created for the EC2 instances"
  
}
output "jenkins_sg_id" {
  value = aws_security_group.jenkins_sg.id
  description = "Security group ID for Jenkins access"
  
}
output "WinRD_sg_id" {
  value = aws_security_group.WinRD_sg.id
  description = "Security group ID for Windows Remote Desktop access"
  
}
output "DB_sg_id" { 
  value = aws_security_group.rds_sg.id
  description = "Security group ID for DB access"
}

output "vpc_internal_sg_id" {
  value = aws_security_group.vpc_internal_sg.id
  description = "Security group ID for VPC internal traffic"
}