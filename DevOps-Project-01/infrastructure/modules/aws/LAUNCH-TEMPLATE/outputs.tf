output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.launch_template.id
}

output "launch_template_arn" {
  description = "ARN of the launch template"
  value       = aws_launch_template.launch_template.arn
}