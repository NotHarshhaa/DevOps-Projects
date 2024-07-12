# Define an AWS VPC resource named "myvpc"
resource "aws_vpc" "myvpc" {
    cidr_block             = "10.0.0.0/16"          # Define the CIDR block for the VPC
    enable_dns_hostnames   = true                   # Enable DNS hostnames in the VPC
    enable_dns_support     = true                   # Enable DNS support in the VPC

    tags = {
        Name = "myvpc"                              # Set a tag for the VPC resource
    }
}

# Define an AWS subnet resource named "pb_sn"
resource "aws_subnet" "pb_sn" {
    vpc_id                  = aws_vpc.myvpc.id      # Reference the VPC ID from the "myvpc" resource
    cidr_block              = "10.0.1.0/24"         # Define the CIDR block for the subnet
    map_public_ip_on_launch = true                  # Enable automatic assignment of public IPs to instances
    availability_zone       = "us-east-1a"          # Specify the availability zone for the subnet

    tags = {
        Name = "pb_sn1"                             # Set a tag for the subnet resource
    }
}

# Define an AWS security group resource named "sg"
resource "aws_security_group" "sg" {
    vpc_id      = aws_vpc.myvpc.id                  # Reference the VPC ID from the "myvpc" resource
    name        = "my_sg"                           # Specify the name for the security group
    description = "Public Security Group"           # Provide a description for the security group

    # Define an ingress rule allowing inbound traffic on port 22 (SSH) from any IP address
    ingress {
        from_port   = 22                            # Specify the starting port for inbound traffic
        to_port     = 22                            # Specify the ending port for inbound traffic
        protocol    = "tcp"                         # Specify the protocol (TCP in this case)
        cidr_blocks = ["0.0.0.0/0"]                 # Allow inbound traffic from any IP address
    }

    # Define an egress rule allowing all outbound traffic (any port, any protocol) to any IP address
    egress {
        from_port   = 0                             # Specify the starting port for outbound traffic
        to_port     = 0                             # Specify the ending port for outbound traffic
        protocol    = "-1"                          # Specify all protocols for outbound traffic
        cidr_blocks = ["0.0.0.0/0"]                 # Allow outbound traffic to any IP address
    }
}
