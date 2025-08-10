# use VPC designer tool for proper subnetting of IP addresses https://vpcdesigner.com/

# Public Subnets
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-subnet-1"
    Environment = var.environment
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-subnet-2"
    Environment = var.environment
  }
}

# Private Subnets
resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.environment}-private-subnet-1"
    Environment = var.environment
  }
}

resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.environment}-private-subnet-2"
    Environment = var.environment
  }
}

# DB Subnets
resource "aws_subnet" "DB_subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.DB_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.environment}-DB-subnet-1"
    Environment = var.environment
  }
}
resource "aws_subnet" "DB_subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.DB_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.environment}-DB-subnet-2"
    Environment = var.environment
  }
}