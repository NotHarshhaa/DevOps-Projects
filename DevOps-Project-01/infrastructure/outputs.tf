output "Nat_gateway_ip" {
  description = "value of the NAT Gateway IP"
  value       = module.vpc.nat_gateway_ip
}
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}
output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}
output "elastic_ip_natgw" {
  description = "Public IP of the NAT Gateway"
  value       = module.vpc.nat_gateway_ip

}
# output "bastion_host_ip" {
#   description = "Public IP of the Bastion Host"
#   value       = module.bastion.instance_public_ip

# }

# output "instance_public_ips" {
#   value = {
#     for name, mod in module.EC2 :
#     name => mod.instance_public_ip
#   }
# }

# output "instance_private_ips" {
#   value = {
#     for name, mod in module.EC2 :
#     name => mod.instance_private_ip
#   }
# }

# output "instance_ids" {
#   value = {
#     for name, mod in module.EC2 :
#     name => mod.instance_id
#   }
# }
# output "instance_ami_ids" {
#   value = {
#     for name, mod in module.EC2 :
#     name => mod.ami_id
#   }
# }
# output "instance_names" {
#   value = {
#     for name, mod in module.EC2 :
#     name => mod.instance_name
#   }
# }
