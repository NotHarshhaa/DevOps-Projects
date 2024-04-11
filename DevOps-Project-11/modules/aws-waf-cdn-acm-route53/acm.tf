resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain-name
  validation_method         = "DNS"
  subject_alternative_names = [var.domain-name, "www.${var.domain-name}"]

  lifecycle {
    create_before_destroy = true
  }
}

# ACM certificate validation resource using the certificate ARN and a list of validation record FQDNs.
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}