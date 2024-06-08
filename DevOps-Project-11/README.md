# Two-Tier AWS Infrastructure with Terraform

[![LinkedIn](https://img.shields.io/badge/Connect%20with%20me%20on-LinkedIn-blue.svg)](https://www.linkedin.com/in/harshhaa-vardhan-reddy/)
[![GitHub](https://img.shields.io/github/stars/NotHarshhaa.svg?style=social)](https://github.com/NotHarshhaa)
[![AWS](https://img.shields.io/badge/AWS-%F0%9F%9B%A1-orange)](https://aws.amazon.com)
[![Terraform](https://img.shields.io/badge/Terraform-%E2%9C%A8-lightgrey)](https://www.terraform.io)

![two-tier](https://imgur.com/X4dGBg6.gif)

## Overview

Welcome to the Terraform project for deploying a Two-Tier architecture on AWS! This project adopts a modular and security-enhanced approach to create a scalable and maintainable infrastructure.

## Features

- **Modular Structure:** The project is organized into dedicated modules for each AWS service, promoting reusability and maintainability.
- **Security Focus:** Utilize IAM roles and policies to ensure a secure infrastructure.
- **Infrastructure as Code (IaC):** Deploy and manage your infrastructure using Terraform, enabling version control and reproducibility.
- **Service-Specific Modules:** Each module corresponds to a specific AWS service, allowing for targeted management.

## Getting Started

Follow these steps to deploy the Two-Tier architecture:

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/NotHarshhaa/DevOps-Projects
   cd DevOps-Projects/DevOps Project-11/
   ```

2. **Plan and Apply:**

    ```bash
    terraform init
    terraform plan -var-file=variables.tfvars
    terraform apply -var-file=variables.tfvars --auto-approve
    ```

3. **Cleanup:**
When done the exploration, run the following to destroy the infrastructure

    ```bash
    terraform destroy -var-file=variables.tfvars --auto-approve
    ```

## Project Highlights

- **VPC: The Foundation**: Create a robust Virtual Private Cloud (VPC) to establish a secure and isolated environment for your application.

- **Load Balancing Magic**: Harness the power of the Application Load Balancer (ALB) to intelligently distribute incoming traffic across multiple EC2 instances, ensuring optimal performance and high availability.

- **Auto Scaling Wonders**: Leverage the Auto Scaling Group to dynamically adjust the number of EC2 instances based on demand. This ensures your application scales seamlessly, providing resilience and cost efficiency.

- **Database Sorcery**: Dive into the world of managed databases with Amazon RDS. Easily deploy, scale, and manage relational databases without the operational overhead.

- **DNS Mastery**: Achieve domain registration and DNS management excellence with Amazon Route 53. Seamlessly connect your applications to the internet while ensuring high availability and low-latency responses.

- **Web Application Firewall (WAF) Protection**: Safeguard your applications from web exploits and ensure a secure user experience with AWS WAF, a web application firewall that helps protect your web applications from common web exploits.

- **Content Delivery Network (CDN) Acceleration**: Boost the delivery of your content globally with a Content Delivery Network. Accelerate load times, enhance user experience, and reduce latency using Amazon CloudFront.

- **SSL Certificate Management with ACM**: Ensure secure communication between your users and the application with Amazon Certificate Manager (ACM). Easily provision, manage, and deploy SSL/TLS certificates.

- **IAM for Robust Security**: Implement robust security measures with Identity and Access Management (IAM). Define granular permissions and access controls to secure your AWS resources.

- **Infrastructure as Code (IaC) Excellence**: Embrace Infrastructure as Code (IaC) with Terraform, facilitating the provisioning and management of AWS resources in a declarative and scalable manner.

These project highlights showcase the comprehensive AWS services integrated into the Two-Tier architecture, providing a solid foundation for your applications with security, scalability, and performance at the forefront.

## Detailed Guide

For an in-depth walkthrough of the project, check out the detailed guide on [Hashnode](https://harshhaa.hashnode.dev/deploy-two-tier-architecture-on-aws-using-terraform).

## Connect with Me

- GitHub: [GitHub Profile](https://github.com/NotHarshhaa)
- LinkedIn: [LinkedIn Profile](https://www.linkedin.com/in/harshhaa-vardhan-reddy/)

## Contributions

Feel free to contribute and adapt this project to suit your needs. We welcome your ideas and improvements.

## License

This project is licensed under the [MIT License](LICENSE).
