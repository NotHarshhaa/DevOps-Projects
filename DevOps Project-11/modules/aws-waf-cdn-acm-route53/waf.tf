# We have created one rule where any user if try to access our Application through TOR browser or any VPN, then the user will not be able to access the Application
resource "aws_wafv2_web_acl" "web_acl" {
  name  = var.web_acl_name
  scope = "CLOUDFRONT"
  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesAnonymousIpList"
    priority = 0

    override_action {
      none {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "BlockIPRuleMetrics"
      sampled_requests_enabled   = false
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
        rule_action_override {
          action_to_use {
            count {}
          }

          name = "SizeRestrictions_QUERYSTRING"
        }

        rule_action_override {
          action_to_use {
            count {}
          }

          name = "NoUserAgent_HEADER"
        }
      }
    }
  }


  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "BlockIPRuleMetrics"
    sampled_requests_enabled   = false
  }
}