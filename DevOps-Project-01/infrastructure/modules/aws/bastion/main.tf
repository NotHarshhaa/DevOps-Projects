
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  security_groups = var.security_group_ids
  key_name      = var.key_name
  associate_public_ip_address = true
  user_data     = var.user_data
  iam_instance_profile = var.iam_instance_profile_name
  tags = {
    Name = var.name
  }
  
}