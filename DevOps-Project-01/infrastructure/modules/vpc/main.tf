# ========================
# VPC Module - main.tf
# ========================

# ------------------------
# VPC
# ------------------------
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  instance_tenancy     = var.instance_tenancy

  tags = merge(
    {
      Name        = var.vpc_name != null ? var.vpc_name : "${var.environment}-vpc"
      Environment = var.environment
    },
    var.tags
  )
}

# ------------------------
# Internet Gateway (Optional)
# ------------------------
resource "aws_internet_gateway" "main" {
  count  = var.enable_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name        = "${var.environment}-igw"
      Environment = var.environment
    },
    var.tags
  )
}

# ------------------------
# Public Subnets
# ------------------------
resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]

  map_public_ip_on_launch = true

  tags = merge(
    {
      Name        = "${var.environment}-public-subnet-${count.index + 1}"
      Environment = var.environment
    },
    var.tags
  )
}

# ------------------------
# Private Subnets
# ------------------------
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]

  tags = merge(
    {
      Name        = "${var.environment}-private-subnet-${count.index + 1}"
      Environment = var.environment
    },
    var.tags
  )
}

# ------------------------
# Elastic IPs for NAT Gateway (Optional)
# ------------------------
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? var.nat_gateway_count : 0
  vpc   = true

  tags = merge(
    {
      Name        = "${var.environment}-nat-eip-${count.index + 1}"
      Environment = var.environment
    },
    var.tags
  )
}

# ------------------------
# NAT Gateways (Optional)
# ------------------------
resource "aws_nat_gateway" "main" {
  count         = var.enable_nat_gateway ? var.nat_gateway_count : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index % length(aws_subnet.public)].id

  tags = merge(
    {
      Name        = "${var.environment}-nat-${count.index + 1}"
      Environment = var.environment
    },
    var.tags
  )
}

# ------------------------
# Public Route Table
# ------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.enable_internet_gateway ? aws_internet_gateway.main[0].id : null
  }

  tags = merge(
    {
      Name        = "${var.environment}-public-rt"
      Environment = var.environment
    },
    var.tags
  )
}

# ------------------------
# Private Route Tables
# ------------------------
resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.enable_nat_gateway ? aws_nat_gateway.main[count.index % length(aws_nat_gateway.main)].id : null
  }

  tags = merge(
    {
      Name        = "${var.environment}-private-rt-${count.index + 1}"
      Environment = var.environment
    },
    var.tags
  )
}

# ------------------------
# Route Table Associations
# ------------------------
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# ------------------------
# VPC Flow Logs (Optional but recommended)
# ------------------------
resource "aws_iam_role" "flow_log" {
  name = "${var.environment}-vpc-flow-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "flow_log" {
  name = "${var.environment}-vpc-flow-log-policy"
  role = aws_iam_role.flow_log.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "flow_log" {
  name              = "/aws/vpc/${var.environment}-flow-logs"
  retention_in_days = 30

  tags = merge(
    {
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.flow_log.arn
  log_destination = aws_cloudwatch_log_group.flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}
