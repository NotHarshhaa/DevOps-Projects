resource "null_resource" "set_hostname" {
  for_each = module.EC2
  triggers = {
    instance_name = each.value.instance_name
    instance_id   = each.value.instance_id
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./keys/terraform-key.pem") # Update with your key file
      host        = each.value.instance_private_ip


      bastion_host        = module.bastion.instance_public_ip
      bastion_user        = "ubuntu"
      bastion_private_key = file("./keys/terraform-key.pem")
    }

    inline = [
      "sudo hostnamectl set-hostname ${each.value.instance_name}",
      "echo ${each.value.instance_name} | sudo tee /etc/hostname",
      "echo '127.0.0.1 ${each.value.instance_name}' | sudo tee -a /etc/hosts"
    ]
  }

  depends_on = [module.EC2]
}

resource "null_resource" "setup_ssh_key_on_instances" {
  depends_on = [module.bastion, module.EC2, module.IAM, module.vpc]
  # for_each   = module.EC2
  # triggers = {
  #   instance_name = each.value.instance_name
  #   instance_id   = each.value.instance_id
  # }

  provisioner "local-exec" {
    command = <<EOT
      sleep 30 
      ssh -o StrictHostKeyChecking=no -i ./keys/terraform-key.pem ubuntu@${module.bastion.instance_public_ip} "mkdir /home/ubuntu/key"
      scp -o StrictHostKeyChecking=no -i ./keys/terraform-key.pem ./keys/terraform-key.pem ubuntu@${module.bastion.instance_public_ip}:/home/ubuntu/key/terraform-key.pem
      ssh -o StrictHostKeyChecking=no -i ./keys/terraform-key.pem ubuntu@${module.bastion.instance_public_ip} "chmod 400 /home/ubuntu/key/terraform-key.pem"
    EOT
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./keys/terraform-key.pem") # Update with your key file
      host        = module.bastion.instance_public_ip

    }
    script = "${path.module}/scripts/ssh-copy-bastion.sh"
  }
  provisioner "local-exec" {
    command = <<EOT
      ssh -o StrictHostKeyChecking=no -i ./keys/terraform-key.pem ubuntu@${module.bastion.instance_public_ip} "rm -rf  /home/ubuntu/key/terraform-key.pem"
    EOT
  }
}