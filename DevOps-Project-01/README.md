# Deploy Java Application on AWS 3-Tier Architecture

![AWS](https://imgur.com/b9iHwVc.png)

### TABLE OF CONTENTS

1. [Goal](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-01/README.md#goal)
2. [Pre-Requisites](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-01/README.md#pre-requisites)
3. [Pre-Deployment](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-01/README.md#pre-deployment)
4. [VPC Deployment](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-01/README.md#vpc-deployment)
5. [Maven (Build)](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-01/README.md#maven-build)
6. [3-Tier Architecture](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-01/README.md#3-tier-architecture)
7. [Application Deployment](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-01/README.md#application-deployment)
8. [Post-Deployment](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-01/README.md#post-deployment)
9. [Validation](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-01/README.md#validation)

---

![3-tier application](https://imgur.com/3XF0tlJ.png)
---

# Project Overview

## Goal

The primary objective of this project is to deploy a scalable, highly available, and secure Java application using a 3-tier architecture. The application will be accessible to end-users via the public internet.

## Pre-Requisites

1. **AWS Free Tier Account**: Sign up for an [Amazon Web Services (AWS) Free Tier account](https://aws.amazon.com/free/) to use various AWS services for deployment.
2. **GitHub Account and Repository**: Create a [GitHub account](https://github.com/join) and a repository to host your Java source code. Migrate the provided Java source code from the [Java-Login-App repository](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-01/Java-Login-App) to your own GitHub repository.
3. **SonarCloud Account**: Create an account on [SonarCloud](https://sonarcloud.io/) for static code analysis and quality checks.
4. **JFrog Cloud Account**: Create an account on [JFrog Cloud](https://jfrog.com/start-free/) to manage your artifacts.

## Pre-Deployment Steps

1. **Create Global AMI (Amazon Machine Image)**:
   - Install [AWS CLI](https://aws.amazon.com/cli/).
   - Install [CloudWatch Agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html).
   - Install [AWS Systems Manager (SSM) Agent](https://docs.aws.amazon.com/systems-manager/latest/userguide/ssm-agent.html).

2. **Create Golden AMIs**:
   - **For Nginx**:
     - Install [Nginx](https://www.nginx.com/).
     - Configure custom memory metrics for CloudWatch.
   - **For Apache Tomcat**:
     - Install [Apache Tomcat](http://tomcat.apache.org/).
     - Configure Tomcat as a systemd service.
     - Install [JDK 11](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html).
     - Configure custom memory metrics for CloudWatch.
   - **For Apache Maven Build Tool**:
     - Install [Apache Maven](https://maven.apache.org/).
     - Install [Git](https://git-scm.com/).
     - Install [JDK 11](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html).
     - Update the Maven Home in the system PATH environment variable.

## VPC Deployment

Deploy AWS infrastructure resources as per the architecture diagram.

1. **VPC (Network Setup)**:
   - Create VPC networks:
     - `192.168.0.0/16` for Bastion Host.
     - `172.32.0.0/16` for application servers.
   - Set up NAT Gateway in the public subnet and update the route table for the private subnet.
   - Create a Transit Gateway and associate both VPCs for private communication.
   - Create Internet Gateways for each VPC and update route tables for inbound/outbound internet access.

2. **Bastion Host**:
   - Deploy a Bastion Host in the public subnet with an Elastic IP (EIP).
   - Create a security group allowing port 22 (SSH) from the public internet.

## Maven (Build)

1. Launch an EC2 instance using the Maven Golden AMI.
2. Clone the GitHub repository to [VSCode](https://code.visualstudio.com/), update `pom.xml` with SonarCloud and JFrog deployment details, and add `settings.xml` with JFrog credentials.
3. Update `application.properties` with JDBC connection string.
4. Push code changes to a feature branch, create a pull request, and merge changes to the master branch.
5. Clone the repository on the EC2 instance and build the source code using Maven with `-s settings.xml`.
6. Integrate the Maven build with SonarCloud and generate an analysis dashboard using the default quality gate profile.

## 3-Tier Architecture

1. **Database (RDS)**:
   - Deploy a Multi-AZ MySQL RDS instance in private subnets.
   - Create a security group allowing port 3306 from application instances and Bastion Host.

2. **Tomcat (Backend)**:
   - Create a private-facing Network Load Balancer and Target Group.
   - Create a Launch Configuration:
     - Use Tomcat Golden AMI.
     - Deploy `.war` artifacts from JFrog to the `webapps` folder.
     - Configure security groups to allow port 22 from Bastion Host and port 8080 from the private NLB.
   - Set up an Auto Scaling Group.

3. **Nginx (Frontend)**:
   - Create a public-facing Network Load Balancer and Target Group.
   - Create a Launch Configuration:
     - Use Nginx Golden AMI.
     - Update `proxy_pass` rules in `nginx.conf` and reload the Nginx service.
     - Configure security groups to allow port 22 from Bastion Host and port 80 from the public NLB.
   - Set up an Auto Scaling Group.

## Application Deployment

1. The deployment of artifacts is handled by user data scripts during the launch of EC2 instances in the application tier.
2. Log into the MySQL database from the application server using MySQL CLI and create the database and table schema to store user login data (as described in the README.md file in the GitHub repo).

## Post-Deployment

1. Configure a Cron job to push Tomcat application logs to an S3 bucket and rotate logs by deleting them from the server after upload.
2. Set up CloudWatch alarms to send email notifications if database connections exceed 100.

## Validation

1. Ensure administrators can log into EC2 instances via the session manager and Bastion Host.
2. Verify that end-users can access the application from a public internet browser.

## Final Note

If you find this repository useful for learning, please give it a star on GitHub. Thank you!

### Authored by [Harshhaa Reddy](https://github.com/NotHarshhaa)
