resource "aws_iam_role_policy" "iam-policy" {
  name   = var.iam-policy
  role   = aws_iam_role.iam-role.id
  policy = file("${path.module}/iam-policy.json")
}