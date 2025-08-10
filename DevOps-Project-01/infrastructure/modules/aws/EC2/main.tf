
resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  security_groups = var.security_group_ids
  key_name      = var.key_name
  #associate_public_ip_address = true
  user_data     = var.user_data   # data.template_file.windows-userdata.rendered or data.template_file.linux-userdata.rendered
  iam_instance_profile = var.iam_instance_profile_name
  tags = merge(var.tags, {
    Name = var.name
    Environment = var.environment
  })

  root_block_device {
  volume_size = 30
  volume_type = "gp3"
  encrypted   = true
  delete_on_termination = true
  tags = {
  Name = "OS disk"
  owners = "sudarshan darade"
  }
  }
  # attach 10 GB of additional Disk volume
# ebs_block_device {
#   device_name = "data disk"   # for Linux instances, you might want to change this to a different device name as "/dev/xvda"
#   volume_size = 10
#   volume_type = "gp3"
#   encrypted = true
#   delete_on_termination = true
#   tags = {
#     Name = "data disk"
#     owners = "sudarshan darade"
#   }
}
