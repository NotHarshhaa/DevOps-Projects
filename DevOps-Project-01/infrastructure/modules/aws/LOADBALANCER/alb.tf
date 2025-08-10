# Load Balancer for ASG
resource "aws_lb" "alb" {
  name               = var.lb_name
  internal           = var.load_balancer_behavior
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = false
  idle_timeout               = 60
  tags = {
    Name = var.lb_name
  }
}


