variable "role_name" {
  description = "Name of the IAM role for GitHub Actions"
  type        = string
  default     = "GitHubActionsRole"
}

variable "policy_name" {
  description = "Name of the IAM policy for GitHub Actions"
  type        = string
  default     = "GitHubActionsPolicy"
}

variable "github_repositories" {
  description = "List of GitHub repositories to grant access to"
  type = list(object({
    org    = string
    repo   = string
    branch = string
  }))
}

variable "policy_json" {
  description = "JSON policy document to attach to the IAM role"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}