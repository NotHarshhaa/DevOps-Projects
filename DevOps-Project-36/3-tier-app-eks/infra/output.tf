#
output "role_arn" {
  description = "ARN of the IAM role for GitHub Actions"
  value       = module.oidc.role_arn
}