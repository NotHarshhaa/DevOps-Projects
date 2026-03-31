# -----------------------------------------------------------------------------
# Root Outputs — Two-Tier AWS Architecture
# These values are printed to the console after a successful `terraform apply`.
# -----------------------------------------------------------------------------

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer (HTTP entry point)"
  value       = module.alb.alb_dns_name
}

output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution (HTTPS entry point)"
  value       = module.route53.cloudfront_domain_name
}

output "rds_endpoint" {
  description = "Writer endpoint of the Aurora MySQL cluster"
  value       = module.rds.rds_cluster_endpoint
}

output "rds_reader_endpoint" {
  description = "Reader endpoint of the Aurora MySQL cluster (read replicas)"
  value       = module.rds.rds_reader_endpoint
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (useful for cache invalidation)"
  value       = module.route53.cloudfront_distribution_id
}
