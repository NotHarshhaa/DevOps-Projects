# 🚀 DevOps Project to Automate Infrastructure on AWS Using Terraform and GitLab CICD

Before starting, ensure you have a basic understanding of:

* Basic Terraform Knowledge

* Understanding of CI/CD

* GitLab CI Knowledge

## 📝 Prerequisites

1. **AWS Account Creation**

    * Check out the official site to create an AWS account [here](https://signin.aws.amazon.com/signup?request_type=register).

2. **GitLab Account**

    * Login to [GitLab](https://gitlab.com).

    * Sign in via GitHub/Gmail.

    * Verify email and phone.

    * Fill up the questionnaires.

    * Provide group name & project name as per your choice.

3. **Terraform Installed**

    * Check out the official website to install Terraform [here](https://developer.hashicorp.com/terraform/install).

        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720803204575/77686b19-dd44-4b8b-80c7-3803085e2af5.png)

4. **AWS CLI Installed**

    * Navigate to the IAM dashboard on AWS, then select "Users."

    * Enter the username and proceed to the next step.

        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720803238522/dff3c840-78ad-4c2a-ad76-d68f59c15363.png)

    * Assign permissions by attaching policies directly, opting for "Administrator access," and then create the user.

        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720803283541/12c6404f-2f5a-4523-a50e-a573e1a2d089.png)

        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720803345832/2f917349-88ef-4793-a3c6-6a93917cdb2a.png)

    * Locate "Create access key" in user settings, and choose the command line interface (CLI) option to generate an access key.

        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720803375154/2dfb24a4-f3ac-42dc-a028-e4d9238e6f85.png)

    * View or download the access key and secret access key either from the console or via CSV download.

        ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720803402328/eda06a70-5d70-4ac5-856d-2daa2f739760.png)

    ```bash
    sudo apt install unzip  
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"  
    unzip awscliv2.zip  
    sudo ./aws/install  
    aws configure (input created access key id and secret access key)  
    cat ~/.aws/config  
    cat ~/.aws/credentials  
    aws iam list-users (to list all IAM users in an AWS account)
    ```

5. **Code Editor (VS Code)**

    * Download it from [here](https://code.visualstudio.com/download).

## 📂 Project Structure

The project is divided into two parts:

1. **Manual Setup:** Write Terraform code, run Terraform commands, and create infrastructure manually.

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720803453942/aa0166a2-11e0-4ca5-9fb1-a686568b65a5.png)

2. **Automation:** Create a CI/CD pipeline script on GitLab to automate Terraform resource creation.

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720803481042/de7eb43b-7b20-438c-abe2-dbbcfdce035d.png)

### Part 1: Manual Setup

1. **Create a new folder named “cicdtf” and open it in VS Code to start writing the code.**

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720803528310/a0187ef8-044e-4085-8c88-86869e7281a9.png)

2. **Write Terraform code in the “cicdtf” folder:**

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720803563971/49c86485-a9cf-4a89-a6ea-2999c49bbc2b.png)

    * Create a file called `provider.tf` to define a provider.

    * Deploy a VPC, a security group, a subnet, and an EC2 instance.

### Folder Structure

#### 1\. VPC Module (`vpc` folder)

* **Files:**

  * `main.tf`: Defines resources like VPC, subnets, and security groups.

  * `variables.tf`: Declares input variables for customization.

  * `outputs.tf`: Specifies outputs like VPC ID, subnet IDs, etc.

#### 2\. EC2 Module (`web` folder)

* **Files:**

  * `main.tf`: Configures EC2 instance details, including AMI, instance type, and security groups.

  * `variables.tf`: Defines variables needed for EC2 instance customization.

  * `outputs.tf`: Outputs instance details like public IP, instance ID, etc.

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720803607484/882c8877-d5bb-466f-af48-48887d69b341.png)

* `main.tf` for VPC Module

```go
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

* **Define** `outputs.tf` in the VPC module:

    ```go
    output "pb_sn" {
      value = aws_subnet.main.id
    }
    
    output "sg" {
      value = aws_security_group.main.id
    }
    ```

* **Define** `variables.tf` in the EC2 module:

    ```go
    variable "subnet_id" {}
    variable "security_group_id" {}
    ```

3. **Initialize and Validate Terraform:**

```bash
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

4. **Backend Configuration:**

* Set up a backend using S3 and DynamoDB.

```go
# backend.tf
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "terraform/state"
    region = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}
```

5. **Push Code to GitLab:**

* Initialize the GitLab repository and create a `.gitignore` file.

* Create a branch named "dev" and push the code.

```bash
git remote add origin https://gitlab.com/your-repo.git
git checkout -b dev
git add .
git commit -m "initial commit"
git push -u origin dev
```

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720803932419/bcf139d7-9ea6-46f4-ac81-6d4b15f3f39e.png)

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720803976561/2527926c-5a9e-49a0-9c85-8fc42987bd88.png)

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720804004557/557a5711-82eb-4288-9f03-524830a54378.png)

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720804043190/55c3c40a-6596-414a-b086-3ad0b5402c02.png)

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720804073528/95b6d812-c601-4316-a09e-431f1c5c0fec.png)

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720804103990/7d5265bc-5379-488a-9d31-c16da7d6c9c5.png)

### Part 2: CI/CD Pipeline

1. **Create a GitLab CI/CD pipeline:**

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720804136384/ceddab5e-1cf6-49dd-a14b-50e97eb48431.png)

* Write a `.gitlab-ci.yml` file to automate Terraform commands.

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720804235396/11da153f-3a2b-400a-9e2c-c456df72ac52.png)

* Store access keys and secret access keys in GitLab CI/CD variables.

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720804274419/97b786ed-3daa-4956-ac9c-2da8005ca282.png)

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720804310585/22ff98bf-8e30-48e8-a9a6-134ad9536a59.png)

```yaml
# .gitlab-ci.yml
image: hashicorp/terraform:latest

variables:
  TF_LOG: DEBUG
  TF_IN_AUTOMATION: true

cache:
  paths:
    - .terraform/

stages:
  - validate
  - plan
  - apply
  - destroy

validate:
  script:
    - terraform init
    - terraform validate

plan:
  script:
    - terraform plan -out=planfile
  artifacts:
    paths:
      - planfile

apply:
  script:
    - terraform apply "planfile"
  when: manual

destroy:
  script:
    - terraform destroy -auto-approve
  when: manual
```

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720804363363/58b1f220-6a17-4f39-834a-82fe81011a7c.png)

2. **Logs and Execution:**

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720804397005/9c0963df-9771-4ca5-8b8e-e68193bc0ea0.png)

* Validate stage: `terraform init` and `terraform validate`

* Plan stage: `terraform plan`

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720804432688/07d02845-482b-45ba-b2d7-928b8075da09.png)

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720804470952/49e940ae-8a91-48a4-80f6-3d1edf3af634.png)

* Apply stage: `terraform apply`

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720804494527/39e0bc72-2e32-40e2-b149-bfc5aeaaaf5f.png)

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720804511156/2b1f5bb5-92be-4a40-9e1f-b7b6f7407777.png)

3. Destroy stage: `terraform destroy`

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720804633310/66ae858e-0b6f-4974-8406-146674f3d8ee.png)

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720804657672/534dddc3-d783-44a6-853b-40fa38d19f71.png)

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1720804693970/48c06297-afee-4dbb-800e-54c4ea725831.png)

### 🌟 Final Notes

* The pipeline performs the following steps:

  * Initializes Terraform with the specified backend configuration.

  * Applies the Terraform plan to create infrastructure resources (VPC, Subnet, Security Group, and EC2 instance).

  * Saves `.terraform` directory to cache for future use.

  * Cleans up the environment after the job is completed.

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
