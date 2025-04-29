# Step-10: Provision EKS Cluster and Install Dependencies on Jenkins Slave

<details>
<summary><strong>1. Provisioned EKS Cluster with Terraform</strong></summary>

<br/>

To provision an Amazon Elastic Kubernetes Service (EKS) cluster using Terraform, follow these steps:

## Steps Overview:

1. **Install Terraform:**
   - Ensure Terraform is installed. You can download it from the [official Terraform website](https://www.terraform.io/downloads).

2. **Configure AWS Credentials:**
   - Set up your AWS credentials either via AWS CLI or environment variables.

3. **Create Terraform Configuration:**
   - Create a `.tf` file (e.g., `eks-cluster.tf`) to define your EKS configuration.

4. **Initialize Terraform:**

   ```bash
   terraform init
   ```

5. **Define EKS Cluster Configuration:**
   Example Terraform configuration:

   ```hcl
   provider "aws" {
     region = "us-west-2" # Change to your region
   }

   module "eks" {
     source            = "terraform-aws-modules/eks/aws"
     cluster_name      = "my-eks-cluster"
     subnets           = ["subnet-xxxxx", "subnet-yyyyy", "subnet-zzzzz"]
     vpc_id            = "vpc-xxxxx"
     tags              = { Terraform = "true", Environment = "dev" }
   }
   ```

6. **Apply Terraform Configuration:**

   ```bash
   terraform apply
   ```

7. **Update Kubeconfig:**
   - After provisioning, update `kubeconfig` using Terraform outputs to access the EKS cluster.

8. **Access the EKS Cluster:**

   ```bash
   kubectl config use-context <cluster-name>
   kubectl get nodes
   ```

9. **Destroy Resources (Optional):**

   ```bash
   terraform destroy
   ```

</details>

---

<details>
<summary><strong>2. Install kubectl in Jenkins Slave</strong></summary>

<br/>

To install `kubectl` on a Jenkins slave, you have two options:

### Option 1: Installing kubectl in Jenkins Pipeline

- Add the following to your Jenkins pipeline:

  ```groovy
  pipeline {
      agent any

      stages {
          stage('Install kubectl') {
              steps {
                  script {
                      sh 'curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"'
                      sh 'chmod +x kubectl'
                      sh 'sudo mv kubectl /usr/local/bin/'
                  }
              }
          }
      }
  }
  ```

### Option 2: Installing kubectl in Jenkins Slave Image

- Modify your Dockerfile to include `kubectl` installation:

  ```Dockerfile
  FROM jenkins/jnlp-slave

  USER root

  RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
      && chmod +x kubectl \
      && mv kubectl /usr/local/bin/

  USER jenkins
  ```

- Build and use the custom Jenkins slave Docker image.

</details>

---

<details>
<summary><strong>3. Install AWS CLI v2 in Jenkins Slave</strong></summary>

<br/>

You can install AWS CLI v2 on a Jenkins slave by either adding steps to the pipeline or modifying the Jenkins slave image.

### Option 1: Installing AWS CLI v2 in Jenkins Pipeline

- Add this stage to your pipeline:

  ```groovy
  pipeline {
      agent any

      stages {
          stage('Install AWS CLI v2') {
              steps {
                  script {
                      sh 'curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"'
                      sh 'unzip awscliv2.zip'
                      sh 'sudo ./aws/install'
                  }
              }
          }
      }
  }
  ```

### Option 2: Installing AWS CLI v2 in Jenkins Slave Image

- Modify the Dockerfile as follows:

  ```Dockerfile
  FROM jenkins/jnlp-slave

  USER root

  RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
      && unzip awscliv2.zip \
      && sudo ./aws/install

  USER jenkins
  ```

- Build and deploy the custom image for Jenkins slaves.

</details>

---

<details>
<summary><strong>4. Download Kubernetes Credentials and Cluster Configuration</strong></summary>

<br/>

To download Kubernetes credentials and cluster configuration using `kubectl`:

1. **Install kubectl:**
   - If not already installed, download kubectl from the official Kubernetes website or package manager.

2. **Retrieve Kubernetes Credentials:**
   - Use the following command to get the credentials and configuration:

     ```bash
     kubectl config view --minify --raw
     ```

   - To save it to a file:

     ```bash
     kubectl config view --minify --raw > my-cluster-config.yaml
     ```

3. **Set Active Context (Optional):**
   - If you have multiple clusters:

     ```bash
     kubectl config use-context <context-name>
     ```

4. **Access the Cluster:**
   - Once you have the configuration, use `kubectl` to interact with the cluster:

     ```bash
     kubectl get pods
     kubectl get services
     ```

Ensure to securely manage the downloaded configuration, as it contains sensitive information such as authentication tokens.

</details>
