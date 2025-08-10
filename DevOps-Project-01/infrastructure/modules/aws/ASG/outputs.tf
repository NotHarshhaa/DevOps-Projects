output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.linux_asg.name
}

output "asg_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.linux_asg.arn
}