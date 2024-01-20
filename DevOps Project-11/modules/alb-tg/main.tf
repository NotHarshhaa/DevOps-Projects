# Creating ALB for Web Tier
resource "aws_lb" "web-elb" {
  name = var.alb-name
  internal           = false
  load_balancer_type = "application"
  subnets            = [data.aws_subnet.public-subnet1.id, data.aws_subnet.public-subnet2.id]
  security_groups    = [data.aws_security_group.web-alb-sg.id]
  ip_address_type    = "ipv4"
  enable_deletion_protection = false
  tags = {
    Name = var.alb-name
  }
}

# Creating Target Group for Web-Tier 
resource "aws_lb_target_group" "web-tg" {
  name = var.tg-name
  health_check {
    enabled = true
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id

  tags = {
    Name = var.tg-name
  }

  lifecycle {
    prevent_destroy = false
  } 
  depends_on = [ aws_lb.web-elb ]
}


# Creating ALB listener with port 80 and attaching it to Web-Tier Target Group
resource "aws_lb_listener" "web-alb-listener" {
  load_balancer_arn = aws_lb.web-elb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-tg.arn
  }

  depends_on = [ aws_lb.web-elb ]
}