# ASG Module for Linux Instances with Load Balancer and Auto Scaling

resource "aws_autoscaling_group" "linux_asg" {
  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }
  name                = var.asg_name
  vpc_zone_identifier = var.subnet_ids
  max_size            = 2
  min_size            = 1
  desired_capacity    = 1
  health_check_type   = "EC2"
  target_group_arns   = var.target_group_arns

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "Linux-ASG-Instance"
    propagate_at_launch = true
  }
}

