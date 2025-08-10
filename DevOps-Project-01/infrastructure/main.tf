module "vpc" {
  source                                 = "./modules/aws/vpc"
  aws_region                             = var.aws_region
  business_division                      = var.business_division
  environment                            = var.environment
  vpc_cidr                               = var.vpc_cidr
  public_subnet_cidrs                    = var.public_subnet_cidrs
  private_subnet_cidrs                   = var.private_subnet_cidrs
  DB_subnet_cidrs                        = var.DB_subnet_cidrs
  availability_zones                     = var.availability_zones
  vpc_create_database_subnet_group       = var.vpc_create_database_subnet_group
  vpc_create_database_subnet_route_table = var.vpc_create_database_subnet_route_table
  vpc_enable_nat_gateway                 = var.vpc_enable_nat_gateway

}
module "EC2" {
  source = "./modules/aws/EC2"

  for_each = local.ec2-instances

  ami                       = each.value.ami
  instance_type             = each.value.instance_type
  subnet_id                 = each.value.subnet_id
  key_name                  = each.value.key_name
  security_group_ids        = each.value.security_group_ids
  name                      = each.key
  user_data                 = lookup(each.value, "user_data", null)
  tags                      = each.value.tags
  iam_instance_profile_name = module.IAM.name
}

module "SG" {
  source = "./modules/aws/SG"
  vpc_id = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
}

module "IAM" {
  source = "./modules/aws/IAM"
}

module "LAUNCH-TEMPLATE" {
  for_each = local.launch_templates
  source = "./modules/aws/LAUNCH-TEMPLATE"
  
  template_name = "${each.key}-launch-template"
  instance_type = var.instance_type
  key_name = var.key_name
  security_group_ids = [module.SG.ssh_sg_id,module.SG.vpc_internal_sg_id]
  iam_instance_profile_name = module.IAM.name
  user_data_script = each.value.user_data_script
  public_ip = each.value.public_ip
  instance_name = each.value.instance_name
}

module "TARGET-GROUP" {
  for_each = local.target_groups
  source = "./modules/aws/TARGET-GROUP"
  vpc_id = each.value.vpc_id
}

module "LOADBALANCER" {
  for_each = local.loadbalancer
  source = "./modules/aws/LOADBALANCER"
  
  lb_name = each.value.lb_name
  listener_port = each.value.listener_port
  security_group_ids = each.value.security_group_ids
  subnet_ids = each.value.subnet_ids
  target_group_arn = each.value.target_group_arn
  load_balancer_behavior = each.value.load_balancer_behavior
}
module "ASG" {
  for_each = local.asg_groups
  source = "./modules/aws/ASG"
  
  asg_name = each.value.asg_name
  instance_type = each.value.instance_type
  key_name = each.value.key_name
  launch_template_id = each.value.launch_template_id
  subnet_ids = each.value.subnet_ids
  target_group_arns = each.value.target_group_arns
}
module "DATABASE" {
  source                  = "./modules/aws/DATABASE/RDS_INSTANCE"
  rds_instance_identifier = "my-rds-db"
  rds_engine              = "mysql"
  rds_engine_version      = "8.0"
  rds_instance_class      = "db.t3.micro"
  rds_storage_size        = 20
  rds_master_username     = "admin"
  rds_master_password     = "admin123"
  subnet_ids              = module.vpc.DB_subnet_ids
  vpc_security_group_ids  = [module.SG.DB_sg_id]
  db_subnet_group_name    = module.vpc.db_subnet_group_name
  rds_publicly_accessible = false
  rds_skip_final_snapshot = true
  rds_tags = {
    Environment = "dev"
  }
}
module "bastion" {

  source = "./modules/aws/bastion"
  name   = "bastion"
  #ami           = data.aws_ami.ubuntu.id
  instance_type             = var.instance_type
  subnet_id                 = module.vpc.public_subnet_ids[0]
  key_name                  = var.key_name
  security_group_ids        = [module.SG.ssh_sg_id, module.SG.DB_sg_id]
  iam_instance_profile_name = module.IAM.name
  user_data                 = file("scripts/bastion.sh")
  tags = {
    Name        = "${local.name}-bastion"
    Environment = local.environment
    Role        = "bastion"
  }

}

module "monitoring" {
  source   = "./modules/aws/MONITORING"
  asg_name = module.ASG["frontend"].asg_name
}

