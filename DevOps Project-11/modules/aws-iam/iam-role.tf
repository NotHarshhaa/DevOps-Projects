resource "aws_iam_role" "iam-role" {
  name               = var.iam-role
  assume_role_policy = file("${path.module}/iam-role.json")
} 