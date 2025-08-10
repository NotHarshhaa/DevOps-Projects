# Define Local Values in Terraform
locals {
  owners      = var.business_division
  environment = var.environment
  name        = "${var.business_division}-${var.environment}"
  Role        = var.Role
  #name = "${local.owners}-${local.environment}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
}

locals {
  ec2-instances = {

    jenkins_instance = {
      ami                       = data.aws_ami.ubuntu.id
      instance_type             = var.instance_type
      subnet_id                 = module.vpc.public_subnet_ids[0]
      iam_instance_profile_name = var.iam_instance_profile_name
      key_name                  = var.key_name
      security_group_ids        = [module.SG.ssh_sg_id, module.SG.jenkins_sg_id]
      user_data                 = file("scripts/jenkins-master.sh")
      tags = {
        Role = var.Role[0]
      }
      common_tags = {
        Role        = var.Role[0]
        owners      = local.owners
        environment = local.environment
      }
    }
    jenkins_agent_sonarqube = {
      ami                       = data.aws_ami.ubuntu.id
      instance_type             = var.instance_type
      subnet_id                 = module.vpc.public_subnet_ids[0]
      iam_instance_profile_name = var.iam_instance_profile_name
      key_name                  = var.key_name
      security_group_ids        = [module.SG.ssh_sg_id, module.SG.jenkins_sg_id]
      user_data                 = file("scripts/sonarqube.sh")
      tags = {
        Role = var.Role[1]
      }
      common_tags = {
        Role        = var.Role[1]
        owners      = local.owners
        environment = local.environment
      }
    }
    jenkins_agent_Jrog = {
      ami                       = data.aws_ami.ubuntu.id
      instance_type             = var.instance_type
      subnet_id                 = module.vpc.public_subnet_ids[0]
      iam_instance_profile_name = var.iam_instance_profile_name
      key_name                  = var.key_name
      security_group_ids        = [module.SG.ssh_sg_id, module.SG.jenkins_sg_id]
      user_data                 = file("scripts/jfrog.sh")
      tags = {
        Role = var.Role[2]
      }
      common_tags = {
        Role        = var.Role[2]
        owners      = local.owners
        environment = local.environment
      }
    }
  }
  launch_templates = {
    nginx = {
      user_data_script = "nginx-userdata.sh"
      public_ip = true
      instance_name = "frontend-ASG-instance"
    }
    tomcat = {
      user_data_script = "tomcat-userdata.sh"
      public_ip = false
      instance_name = "backend-ASG-instance"
    }
  }
  
  target_groups = {
    frontend = {
      vpc_id = module.vpc.vpc_id
    }
    backend = {
      vpc_id = module.vpc.vpc_id
    }
  }
  
  asg_groups = {
    frontend = {
      asg_name = "frontend-asg"
      instance_type = var.instance_type
      key_name = var.key_name
      launch_template_id = module.LAUNCH-TEMPLATE["nginx"].launch_template_id
      subnet_ids = module.vpc.public_subnet_ids
      target_group_arns = [module.TARGET-GROUP["frontend"].linux_tg_arn]
    }
    backend = {
      asg_name = "backend-asg"
      instance_type = var.instance_type
      key_name = var.key_name
      launch_template_id = module.LAUNCH-TEMPLATE["tomcat"].launch_template_id
      subnet_ids = module.vpc.private_subnet_ids
      target_group_arns = [module.TARGET-GROUP["backend"].tomcat_tg_arn]
    }
  }
  
  loadbalancer = {
    external = {
      lb_name = "frontend-alb"
      listener_port = 80
      security_group_ids = [module.SG.ssh_sg_id]
      subnet_ids = module.vpc.public_subnet_ids
      target_group_arn = module.TARGET-GROUP["frontend"].linux_tg_arn
      load_balancer_behavior = false
    }
    internal = {
      lb_name = "backend-alb"
      listener_port = 8080
      security_group_ids = [module.SG.vpc_internal_sg_id]
      subnet_ids = module.vpc.private_subnet_ids
      target_group_arn = module.TARGET-GROUP["backend"].tomcat_tg_arn
      load_balancer_behavior = true
    }
  }
}