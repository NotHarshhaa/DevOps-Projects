# variables.tf file in web module

# Define a variable to hold the security group ID
variable "sg" {
    description = "The ID of the security group"
}

# Define a variable to hold the subnet ID
variable "sn" {
    description = "The ID of the subnet"
}