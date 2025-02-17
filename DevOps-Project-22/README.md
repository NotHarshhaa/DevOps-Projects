# AWS Fully Serverless Architecture with CI/CD

## **Introduction:**

Enter the world of serverless computing, where developers are freed from server management. Deploying code becomes a breeze, with a focus on deploying functions rather than wrestling with servers. Originally synonymous with FaaS, serverless technology began with **AWS Lambda** from **Amazon Web Services**. It has now evolved to cover various managed services like databases and storage, expanding its scope beyond its initial function-centric approach.

Despite its name, serverless doesn’t mean a server-free existence. Instead, it signals a shift in responsibility — developers no longer need to manage, provision, or see the underlying servers. This allows them to concentrate on crafting efficient code without the distractions of server intricacies.

In this article, we’ll explore a practical example of a Fully Serverless Architecture implemented using Terraform — a popular IaC tool and CI/CD implemented using GitHub Actions. The code repository we’ll be examining is hosted on GitHub: [GitHub Repository](https://github.com/NotHarshhaa/DevOps-Projects/tree/master/DevOps-Project-22)

I have a NodeJS Cloud Native API which I have used to deploy in this architecture. This API is specifically designed to make use of AWS serverless services.

**Architecture:**

![](https://miro.medium.com/v2/resize:fit:1146/1*NN5kTCl1ljuIJ-2dfT7bMQ.gif)

The aim of this project is to deploy API to AWS Public cloud using only serverless components.

### API code is available [here](https://github.com/NotHarshhaa/DevOps-Projects/tree/master/DevOps-Project-22/serverless-api)

Following are the serverless services used in this project:

- API Gateway
- Lambda
- Aurora Serverless (MySql)
- AWS Simple Storage Service (S3)
- AWS Secrets Manager
- AWS Certificate Manager (ACM)
- Cloudwatch Logs and Metrics
- Route53

Secrets Manager stores the database credentials securely and the credentials are rotated every 7 days.
Lambda is launched in the VPC private subnet. The access to secrets manager from within the VPC is through VPC Interface endpoint and access to S3 is through VPC Gateway Endpoint.

## Terraform

Terraform is an open-source infrastructure as code software tool that enables you to safely and predictably create, change, and improve infrastructure.

## Setting up Infrastructure using Terraform

The terraform init command initializes a working directory containing Terraform configuration files:

```
terraform init
```

The terraform plan command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure:

```
terraform plan
```

The terraform apply command executes the actions proposed in a Terraform plan to create, update, or destroy infrastructure:

```
terraform apply
```

The terraform destroy command is a convenient way to destroy all remote objects managed by a particular Terraform configuration:

```
terraform destroy
```

## **Key Services and Features:**

Let’s explore the key services and features of this AWS Architecture:

1. **AWS Lambda:**  
    AWS Lambda, the pioneer in serverless computing, introduces virtual functions that eliminate the need for manual server management. With a focus on short executions, Lambda operates on-demand, ensuring efficient resource utilization. Its automated scaling feature adapts seamlessly to varying workloads, guaranteeing optimal performance. Lambda is Integrated with many programming languages and a whole AWS suite of services and can easily be monitored through AWS CloudWatch. **AWS Lambda** serves as an ideal solution for executing our Cloud Native API code efficiently, all while maintaining minimal costs.

2. **Aurora Serverless:**  
    Aurora, a powerhouse in the realm of cloud databases, seamlessly supports both Postgres and MySQL. Positioned as “AWS cloud optimized,” Aurora boasts a remarkable 5x performance improvement over MySQL on RDS and over 3x the performance over Postgres on RDS. Offering up to 15 replicas with a replication process faster than MySQL. With instantaneous failover, it is inherently designed for High Availability (HA), although it comes at a slightly higher cost than RDS (20% more), its efficiency and performance make it a compelling choice to store our API’s structured data.

3. **Amazon Simple Storage Service (S3):**  
    S3 is one of the very popular offerings from AWS. S3 is highly available and durable object based storage service. S3 allows storing objects (files) in buckets with globally unique name. In this case, we are using S3 to store API’s binary image data (JPEG, JPG, PNG).

4. **API Gateway: AWS Lambda** coupled with **API Gateway** presents a hassle-free solution with zero infrastructure management. API Gateway not only supports HTTP, REST Protocols but also the WebSocket Protocol and also adeptly handles API versioning (such as v1, v2) and diverse environments (dev, test, prod). API Gateway also covers authentication and authorization, along with the ability to create API keys and manage request throttling. Additionally, it excels in transforming and validating requests and responses, allowing for the generation of SDKs and API specifications. With the added capability to cache API responses, API Gateway offer a comprehensive and efficient ecosystem for developing and managing APIs.

Some of the managed services used in this Architecture are:

1. **AWS CloudWatch:**
    Amazon CloudWatch is a robust monitoring and observability service provided by AWS, enabling users to collect and track metrics, collect and monitor log files, and set alarms. Logs and Metrics from Lambda functions are sent to CloudWatch for troubleshooting and observability purposes.

2. **VPC:** The foundation of AWS Infrastructure is the VPC, which isolates resources and provides a private network for the application. VPC can be divided into multiple public (With Internet connectivity) and private subnets.

3. **Amazon Route53:** A highly available, scalable, fully managed and *Authoritative* DNS. The only AWS service which provides 100% availability SLA. It is also a Domain Registrar. Route 53 translates human friendly hostnames into machine IP addresses.

# **Security Considerations:**

1. **AWS Certificate Manager (ACM):**
    Responsible for Managing, Provisioning and deploying TLS certificates. SSL/TLS certificates provides security in transit for HTTP websites (HTTPS). Supports both public and private TLS certificates. Free of charge. ACM is used to load/associate TLS certificates on Application load balancer, API Gateway, CloudFront, etc.

2. **AWS Secrets Manager:** AWS Secrets Manager is meant for storing secrets. It has the capability to rotate secrets every X days (automates the generation of new secrets on rotation by making use of Lambda in the background). It is tightly Integrated with Amazon RDS (MySQL, PostgreSQL, Aurora), so it can securely store the database credentials. Secrets that are stored in Secrets Manager are encrypted using Key Management Service (KMS).

3. **Security Groups:** Security groups act as firewall for all the instances like EC2, Lambda (through ENI), Interface Endpoints (through ENI), Databases, within the VPC. In the above architecture, Security groups were used to restrict access to database. Further, we can use security groups to restrict access to Interface endpoint that is responsible for accessing Secrets Manager.

4. **VPC Endpoints:** Utilizing VPC Endpoints, enables the establishment of connections to AWS services through a **private network** rather than relying on the public Internet. These endpoints are designed to be both redundant and horizontally scalable. **IGW** and **NATGW** can be avoided to access the AWS services. In our case, we used VPC Interface endpoint (deploys ENI within the subnet) to access secrets manager privately from within the VPC and VPC Gateway endpoint (deploys a Gateway, must be used as a target in the route tables) to access S3 privately from within the VPC.

5. **IAM ROLES:** Lambda functions in the private subnets are assigned an IAM role with necessary permissions to send Logs and Metrics to CloudWatch, access S3 bucket, access Aurora database and also to create, describe and delete Elastic Network Interface (ENI) for lambda within the VPC.

# **CI/CD:**

CI and CD stand for continuous integration and continuous delivery/ deployment. In very simple terms, **Continuous Integration** is a modern software development practice in which incremental code changes are made frequently and reliably to a central code repository like GitHub, Bit Bucket, etc. and **Continuous Delivery** is a software development practice that works in conjunction with CI, CD takes over during the final stages to ensure it’s packaged with everything it needs to deploy to any environment at any time (where as, **Continuous deployment** deploys the applications automatically, eliminating the need for human intervention). The CI/CD pipeline for the above architecture consists of the following:

![](https://miro.medium.com/v2/resize:fit:802/1*xo6Jp9JX8JBOMi5YIGkm_Q.jpeg)

1. **Git:** Git is a distributed version control system that tracks the changes in your application code. Application code can be committed and pushed to a remote cloud version control service like **Github**.

2. **Github Actions:** Github Actions is a feature of Github that Automates the building, testing and deployment of your application code. When a developer raises a Pull Request, a Github Actions workflow can be triggered to run a series of tests before merging the latest code to the main repository. In the above pipeline, after merging the latest code, another Github Actions Workflow can be triggered to build or package the latest code and deploy to Lambda using **AWS CLI** commands.

A **dedicated IAM user** with relevant permissions can be created for Github Actions for deployment. **Access keys** and **secret keys** can be passed through Github Actions Secrets in the workflow configuration.

# Serverless-api

This Cloud Native API is designed to run on AWS Infrastructure while making use of AWS serverless services like Secrets Manager, Lambda functions, API Gateway, etc.

## Prerequisites for running the application locally

```javascript
// install dependencies
npm install
// start the server script
npm start
// run test cases
npm test
```

## Endpoint URLs

```javascript
// 1. Route to check if the server is healthy
GET /healthz
// 2. GET route to retrieve user details
GET /v1/user/{userId}
// 3. POST route to add a new user to the database
POST /v1/user
// 4. PUT route to update user details
PUT /v1/user/{userId}
```

### Sample JSON Response for GET

```json
{
  "id": 1,
  "first_name": "Jane",
  "last_name": "Doe",
  "username": "jane.doe@example.com",
  "account_created": "2016-08-29T09:12:33.001Z",
  "account_updated": "2016-08-29T09:12:33.001Z"
}
```

### Sample JSON Request for POST

```json
{
  "username": "jane.doe@example.com",
  "password": "password",
  "first_name": "Jane",
  "last_name": "Doe",  
}
```

### Sample JSON Request for PUT

```json
{
  "password": "password",
  "first_name": "Jane",
  "last_name": "Doe",  
}
```

## Endpoint URLs

```javascript
// 1. GET route to retrieve product details
GET /v1/product/{productId}
// 2. POST route to add a new product to the database
POST /v1/product
// 3. PUT route to update product details
PUT /v1/product/{productId}
// 4. PATCH route to update product details partially
PUT /v1/product/{productId}
// 5. DELETE route to delete product details
PUT /v1/product/{productId}
```

### Sample JSON Response for GET

```json
{
  "id": 1,
  "name": null,
  "description": null,
  "sku": null,
  "manufacturer": null,
  "quantity": 1,
  "date_added": "2016-08-29T09:12:33.001Z",
  "date_last_updated": "2016-09-29T09:12:33.001Z",
  "owner_user_id": 1
}
```

### Sample JSON Request for POST

```json
{
  "name": null,
  "description": null,
  "sku": null,
  "manufacturer": null,
  "quantity": 1
}
```

### Sample JSON Request for PUT

```json
{
  "name": null,
  "description": null,
  "sku": null,
  "manufacturer": null,
  "quantity": 1
}
```

### Sample JSON Request for PATCH

```json
{
  "name": null,
  "description": null,
  "sku": null,
  "manufacturer": null,
  "quantity": 1
}
```

---

## 🛠️ Author & Community  

This project is crafted by **[Harshhaa](https://github.com/NotHarshhaa)** 💡.  
I’d love to hear your feedback! Feel free to share your thoughts.  

📧 **Connect with me:**

- **GitHub**: [@NotHarshhaa](https://github.com/NotHarshhaa)
- **Blog**: [ProDevOpsGuy](https://blog.prodevopsguy.xyz)  
- **Telegram Community**: [Join Here](https://t.me/prodevopsguy)  

---

## ⭐ Support the Project  

If you found this helpful, consider **starring** ⭐ the repository and sharing it with your network! 🚀  

### 📢 Stay Connected  

![Follow Me](https://imgur.com/2j7GSPs.png)
