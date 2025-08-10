resource "aws_security_group" "ssh_sg" {
  name        = "ssh-sg"
  description = "Security group for SSH access"
  
  depends_on = [ var.vpc_id ] # Ensure VPC is created before SG
  vpc_id =  var.vpc_id
  
  lifecycle {
    create_before_destroy = true
  }
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere, consider restricting this in production
#     description = "Allow SSH access"
# }
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere, consider restricting this in production
#     description = "Allow HTTP access"
#   }
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS from anywhere, consider restricting this in production
#     description = "Allow HTTPS access"
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1" # Allow all outbound traffic
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow all outbound traffic"
#   }
  
  tags = {
    Name        = "ssh-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Security group for jenkins console access"
  
  depends_on = [ var.vpc_id ] # Ensure VPC is created before SG
  vpc_id =  var.vpc_id
  
  lifecycle {
    create_before_destroy = true
  }
#   ingress {
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Allow jenkins from anywhere, consider restricting this in production
#     description = "Allow jenkins access"
# }
#   ingress {
#     from_port   = 9090
#     to_port     = 9090
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere, consider restricting this in production
#     description = "Allow sonar-server access"
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1" # Allow all outbound traffic
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow all outbound traffic"
#   }

  tags = {
    Name        = "jenkins-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "WinRD_sg" {
  name        = "WinRD-sg"
  description = "Security group for jenkins console access"
  
  depends_on = [ var.vpc_id ] # Ensure VPC is created before SG
  vpc_id =  var.vpc_id
  
  lifecycle {
    create_before_destroy = true
  }
#   ingress {
#     from_port   = 
#     to_port     = 3389
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Allow jenkins from anywhere, consider restricting this in production
#     description = "Allow jenkins access"
# }
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere, consider restricting this in production
#     description = "Allow sonar-server access"
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1" # Allow all outbound traffic
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow all outbound traffic"
#   }

  tags = {
    Name        = "WinRD-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${local.name}-rds-sg"
  description = "Allow DB traffic from allowed sources"
  vpc_id      = var.vpc_id
  
  lifecycle {
    create_before_destroy = true
  }

  # ingress {
  #   description      = "Allow DB traffic"
  #   from_port        = var.db_port
  #   to_port          = var.db_port
  #   protocol         = "tcp"
  #   security_groups  = var.allowed_sg_ids  # EC2 SGs that need DB access
  # }

  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  tags = {
    Name = "${local.name}-rds-sg"
  }
}

# Security Group for VPC Internal Traffic
resource "aws_security_group" "vpc_internal_sg" {
  name        = "vpc-internal-sg"
  description = "Allow all traffic within VPC"
  vpc_id      = var.vpc_id
  
  lifecycle {
    create_before_destroy = true
  }

  # ingress {
  #   description = "Allow all traffic from VPC"
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = [data.aws_vpc.selected.cidr_block]
  # }

  # egress {
  #   description = "Allow all outbound traffic"
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  tags = {
    Name = "vpc-internal-sg"
    Environment = var.environment
  }
}