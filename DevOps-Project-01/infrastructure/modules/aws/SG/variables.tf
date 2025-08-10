
variable "business_division" {
  description = "Business Division of project"
  type        = string
  default     = "DevOps"
}
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the instance"
  type        = list(string)
  default     = []
  
}
variable "tags" {
  description = "Tags to apply to the EC2 instance"
  type        = map(string)
  default     = {}
  
}
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}
variable "vpc_id" {
  description = "VPC ID to associate with the security group"
  type        = string
  default     = ""# This should be set to the VPC ID from the VPC module
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}
variable "ssh_sg_ingress_rules" {
  description = "List of ingress rules for the SSH security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  
}
variable "ssh_sg_egress_rules" {
  description = "List of egress rules for the SSH security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"              # -1 means ALL protocols
      cidr_blocks = ["0.0.0.0/0"]     # All destinations
    }
  ]
  
}

variable "jenkins_sg_ingress_rules" {
  description = "List of ingress rules for the Jenkins security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  
}
variable "jenkins_sg_egress_rules" {
  description = "List of egress rules for the Jenkins security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"              # -1 means ALL protocols
      cidr_blocks = ["0.0.0.0/0"]     # All destinations
    }
  ] 
}

variable "WinRD_sg_ingress_rules" {
  description = "List of ingress rules for the Jenkins security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  
}
variable "WinRD_sg_egress_rules" {
  description = "List of egress rules for the Jenkins security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"              # -1 means ALL protocols
      cidr_blocks = ["0.0.0.0/0"]     # All destinations
    }
  ] 
}

variable "DB_sg_ingress_rules" {
  description = "List of ingress rules for the Jenkins security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 5432    # port for Postgres SQL
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 3306   # port for MySQL
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22   # port for ssh to Database
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  
}
variable "DB_sg_egress_rules" {
  description = "List of egress rules for the Jenkins security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"              # -1 means ALL protocols
      cidr_blocks = ["0.0.0.0/0"]     # All destinations
    }
  ] 
}

variable "VPC_internal_sg_ingress_rules" {
  description = "List of ingress rules for the Jenkins security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0    # port for Any Traffic
      to_port     = 0
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]
  
}
variable "VPC_internal_sg_egress_rules" {
  description = "List of egress rules for the Jenkins security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0    # port for Any Traffic
      to_port     = 0
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      }
  ]
  
}