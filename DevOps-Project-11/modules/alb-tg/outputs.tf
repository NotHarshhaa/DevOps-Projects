output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.alb.arn
}

output "target_group_arn" {
  description = "The ARN of the ALB target group"
  value       = aws_lb_target_group.tg.arn
}
