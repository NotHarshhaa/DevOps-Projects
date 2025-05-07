# vpc
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# 2 private subnets
resource "aws_subnet" "private_1" {
  cidr_block        = var.private_subnets_cidr[0]
  availability_zone = var.aws_azs[0]

  vpc_id = aws_vpc.main.id


}

resource "aws_subnet" "private_2" {
  cidr_block        = var.private_subnets_cidr[1]
  availability_zone = var.aws_azs[1]
  vpc_id            = aws_vpc.main.id

}

# 2 public subnets

resource "aws_subnet" "public_1" {
  cidr_block              = var.public_subnets_cidr[0]
  availability_zone       = var.aws_azs[0]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

}

resource "aws_subnet" "public_2" {
  cidr_block              = var.public_subnets_cidr[1]
  availability_zone       = var.aws_azs[1]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

}

# internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

}

# route table for public subnet
resource "aws_route_table" "public_1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table" "public_2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

}

# route table for private subnet
resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.main.id
}


resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_2.id
}


# route for public subnet
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_1.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_2.id
}

# route for private subnetclear

# #  elasetic ip
# # Elastic IPs for NAT Gateways
# resource "aws_eip" "nat_1" {
#   depends_on = [aws_internet_gateway.main]
#   tags = {
#     Name = "NAT Gateway EIP 1"
#   }
# }


# # nat gateway 2 if them

# resource "aws_nat_gateway" "nat_1" {
#   subnet_id     = aws_subnet.public_1.id
#   allocation_id = aws_eip.nat_1.id

#   tags = {
#     Name = "NAT Gateway 1"
#   }
# }
