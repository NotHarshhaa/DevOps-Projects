# outputs.tf file in vpc module

#Output the subnet ID
output "pb_sn" {
    value = aws_subnet.pb_sn.id  # This refers to the ID of the subnet created in the VPC module
}

# Output the security group ID
output "sg" {
    value = aws_security_group.sg.id  # This refers to the ID of the security group created in the VPC module
}
