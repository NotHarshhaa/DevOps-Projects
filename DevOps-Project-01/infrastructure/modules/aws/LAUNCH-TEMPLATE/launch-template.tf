# Launch Template Resource
resource "aws_launch_template" "launch_template" {
  name          = var.template_name
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = base64encode(templatefile("${path.module}/user-data/${var.user_data_script}", {}))
  
  tags = {
    Name = var.template_name
    Owner = "${var.business_division}-${var.environment}"
  }

  monitoring {
    enabled = true
  }

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }
  
  network_interfaces {
    associate_public_ip_address = var.public_ip
    security_groups             = var.security_group_ids
    delete_on_termination       = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.instance_name
      Owner = "${var.business_division}-${var.environment}"
    }
  }
}
