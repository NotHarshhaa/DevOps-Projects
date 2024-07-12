# Define an AWS EC2 instance resource named "server" # main.tf file in web module


resource "aws_instance" "server" {
    ami             = "ami-04a81a99f5ec58529"   # Specify the AMI ID (Amazon Machine Image) for the instance
    instance_type   = "t2.micro"                # Specify the instance type (e.g., t2.micro)
    subnet_id       = var.sn                    # Use the subnet ID variable from the VPC module's output
    security_groups = [var.sg]                  # Use the security group ID variable from the VPC module's output

    tags = {
        Name = "my_server"                     # Set a tag for the EC2 instance for identification
    }
}