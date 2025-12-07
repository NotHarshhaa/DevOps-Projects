# AWS Infrastructure for Java Application

This directory contains Terraform configurations to set up the AWS infrastructure for the Java application deployment. The infrastructure follows AWS best practices and implements a secure, scalable, and highly available architecture.

## Architecture Overview

The infrastructure consists of:

- VPC with public and private subnets across multiple availability zones
- Application Load Balancer (ALB) in public subnets
- EC2 instances in private subnets managed by Auto Scaling Groups
- RDS MySQL database in private subnets
- Bastion host for secure SSH access
- CloudWatch monitoring and logging

## Prerequisites

1. **AWS Account and Credentials**
   - AWS account with appropriate permissions
   - AWS CLI installed and configured
   - Access key and secret key with necessary permissions

2. **Tools**
   - Terraform >= 1.0.0
   - AWS CLI >= 2.0.0

## Directory Structure

```
infrastructure/
├── main.tf           # Main Terraform configuration
├── variables.tf      # Input variables
├── README.md         # This file
├── modules/
│   ├── vpc/         # VPC and networking
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── security/    # Security groups
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── environments/    # Environment-specific configurations (optional)
    ├── dev/
    └── prod/
```

## Usage

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Configure Variables**
   Create a `terraform.tfvars` file:
   ```hcl
   environment        = "dev"
   aws_region        = "us-east-1"
   vpc_cidr          = "192.168.0.0/16"
   public_subnets    = ["192.168.1.0/24", "192.168.2.0/24"]
   private_subnets   = ["192.168.3.0/24", "192.168.4.0/24"]
   db_username       = "admin"
   db_password       = "your-secure-password"
   key_name          = "your-key-pair-name"
   ```

3. **Plan the Infrastructure**
   ```bash
   terraform plan -out=tfplan
   ```

4. **Apply the Infrastructure**
   ```bash
   terraform apply tfplan
   ```

## Module Outputs

### VPC Module Outputs

The VPC module provides the following outputs for integration with other modules:

**Basic Resources:**
- `vpc_id` - ID of the VPC
- `vpc_name` - Name of the VPC (from tags)
- `vpc_cidr_block` - CIDR block of the VPC

**Subnets:**
- `public_subnet_ids` - List of public subnet IDs
- `private_subnet_ids` - List of private subnet IDs
- `public_subnet_cidrs` - List of public subnet CIDR blocks
- `private_subnet_cidrs` - List of private subnet CIDR blocks

**Networking Components:**
- `internet_gateway_id` - ID of the Internet Gateway
- `public_route_table_ids` - List of public route table IDs
- `private_route_table_ids` - List of private route table IDs

**NAT Gateways:**
- `nat_gateway_ids` - List of NAT Gateway IDs
- `nat_gateway_elastic_ips` - List of Elastic IP addresses associated with NAT Gateways

**Usage Example:**
```hcl
module "vpc" {
  source = "./modules/vpc"
  # ... variables
}

# Access outputs
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnet_ids
}
```

## Security Considerations

1. **Network Security**
   - All application servers are in private subnets
   - Only the ALB is exposed to the internet
   - Bastion host for secure SSH access

2. **Database Security**
   - RDS instance in private subnet
   - Access restricted to application servers
   - Automated backups enabled

3. **Access Management**
   - IAM roles for EC2 instances
   - Security groups with minimal required access
   - VPC flow logs enabled

## Monitoring and Logging

1. **CloudWatch Metrics**
   - CPU utilization
   - Memory usage
   - Network traffic
   - Database connections

2. **CloudWatch Logs**
   - Application logs
   - VPC flow logs
   - Load balancer access logs

## Cost Optimization

1. **Resource Sizing**
   - Right-sized instances based on workload
   - Auto Scaling for optimal resource utilization

2. **Storage Management**
   - Automated cleanup of old logs
   - Lifecycle policies for backups

## Maintenance

1. **Backup Strategy**
   - Automated RDS backups
   - Retention period configurable
   - Point-in-time recovery enabled

2. **Updates and Patches**
   - Use AWS Systems Manager for updates
   - Automated security patches
   - Rolling updates for zero downtime

## Troubleshooting

1. **Common Issues**
   - Check security group rules
   - Verify subnet configurations
   - Review CloudWatch logs

2. **Support**
   - Create GitHub issues for bugs
   - Contact maintainers for critical issues

## Contributing

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 