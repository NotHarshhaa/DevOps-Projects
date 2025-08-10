output "instance_name" {
  description = "value of the EC2 instance name"
    value       = aws_instance.instance.tags["Name"]
}
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.instance.id
  }
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.instance.public_ip
}
output "instance_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.instance.private_ip
}
output "ami_id" {
  description = "AMI ID used for the EC2 instance"
  value       = aws_instance.instance.ami
  
}


