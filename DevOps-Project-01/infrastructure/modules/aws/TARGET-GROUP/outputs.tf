output "linux_tg_arn" {
  description = "ARN of the Linux target group"
  value       = aws_lb_target_group.linux_tg.arn
}

output "linux_tg_id" {
  description = "ID of the Linux target group"
  value       = aws_lb_target_group.linux_tg.id
}

output "tomcat_tg_arn" {
  description = "ARN of the Tomcat target group"
  value       = aws_lb_target_group.tomcat_tg.arn
}

output "tomcat_tg_id" {
  description = "ID of the Tomcat target group"
  value       = aws_lb_target_group.tomcat_tg.id
}