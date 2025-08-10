# 1. Create the Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# 2. IAM Role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "ec2-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# 3. Attach AWS Managed Policy (or your own)
resource "aws_iam_role_policy_attachment" "ec2_ssm_role_policy_attachments" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchFullAccessV2",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ])

  role       = aws_iam_role.ec2_role.name
  policy_arn = each.value
}
resource "aws_iam_role_policy_attachment" "ECR" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}
resource "aws_iam_role_policy_attachment" "EC2" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
resource "aws_iam_role_policy_attachment" "s3" {
    role       = aws_iam_role.ec2_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Database access policies
resource "aws_iam_role_policy_attachment" "rds_full_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_role_policy_attachment" "dynamodb_full_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "elasticache_full_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElastiCacheFullAccess"
}

resource "aws_iam_role_policy_attachment" "documentdb_full_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDocDBFullAccess"
}

# Custom policy for RDS Connect
resource "aws_iam_policy" "rds_connect_policy" {
  name        = "RDSConnectPolicy"
  description = "Policy for RDS database connections"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "rds-db:connect"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_connect_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.rds_connect_policy.arn
}

# Optional: Attach a custom inline policy
# resource "aws_iam_policy" "custom_policy" {
#   name        = "CustomEC2Policy"
#   description = "Custom policy for EC2 actions"
#   policy      = file("policies/ec2-custom-policy.json")
# }

# resource "aws_iam_role_policy_attachment" "custom_attach" {
#   role       = aws_iam_role.ec2_role.name
#   policy_arn = aws_iam_policy.custom_policy.arn
# }

