
output "name" {
  description = "Name of the IAM instance profile"
  value = aws_iam_instance_profile.ec2_instance_profile.name
  
}
output "role_name" {
  description = "Name of the IAM role"
  value = aws_iam_role.ec2_role.name
  
}
output "flow_log" {
  description = "flow log role arn"
  value = aws_iam_role.flow_log.arn
}