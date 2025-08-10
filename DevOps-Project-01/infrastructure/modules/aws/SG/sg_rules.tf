# security group rules for SSH access for Linux instances

resource "aws_security_group_rule" "ssh_sg_ingress" {
  for_each = { for idx, rule in var.ssh_sg_ingress_rules : idx => rule }
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.ssh_sg.id
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ssh_sg_egress" {
  for_each = { for idx, rule in var.ssh_sg_egress_rules : idx => rule }
  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.ssh_sg.id
  
  lifecycle {
    create_before_destroy = true
  }
}
# security group rules for SSH access for jenkins and SonarQube instances
resource "aws_security_group_rule" "jenkins_sg_ingress" {
  for_each = { for idx, rule in var.jenkins_sg_ingress_rules : idx => rule }
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.jenkins_sg.id
}

resource "aws_security_group_rule" "jenkins_sg_egress" {
  for_each = { for idx, rule in var.jenkins_sg_egress_rules : idx => rule }
  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.jenkins_sg.id
}
# security group rules for Remote access for windows instances
resource "aws_security_group_rule" "WinRD_sg_ingress" {
  for_each = { for idx, rule in var.WinRD_sg_ingress_rules : idx => rule }
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.WinRD_sg.id
}

resource "aws_security_group_rule" "WinRD_sg_egress" {
  for_each = { for idx, rule in var.WinRD_sg_egress_rules : idx => rule }
  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.WinRD_sg.id
}
# security group rules for access to RDS instances
resource "aws_security_group_rule" "DB_sg_ingress" {
  for_each = { for idx, rule in var.DB_sg_ingress_rules : idx => rule }
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.rds_sg.id
}

resource "aws_security_group_rule" "DB_sg_egress" {
  for_each = { for idx, rule in var.DB_sg_egress_rules : idx => rule }
  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.rds_sg.id
}
# VPC Internal Security Group Rules
resource "aws_security_group_rule" "vpc_internal_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = aws_security_group.vpc_internal_sg.id
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "vpc_internal_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpc_internal_sg.id
  
  lifecycle {
    create_before_destroy = true
  }
}