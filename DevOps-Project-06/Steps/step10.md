# About Step-10

## 1. Provisioned the EKS cluster with Terraform.

Provisioning an Amazon Elastic Kubernetes Service (EKS) cluster using Terraform involves several steps, including setting up the required resources, configuring the cluster, and defining security settings. Here's a high-level overview of how you can provision an EKS cluster using Terraform:

1. **Install Terraform:**
   Make sure you have Terraform installed on your machine. You can download it from the official Terraform website.

2. **Configure AWS Credentials:**
   Ensure you have AWS credentials configured on your machine. You can set them up using the AWS CLI or environment variables.

3. **Create a Terraform Configuration:**
   Create a directory for your Terraform configuration and create a `.tf` file (e.g., `eks-cluster.tf`) inside it. Define your EKS cluster configuration in this file.

4. **Initialize Terraform:**
   Open a terminal in your Terraform configuration directory and run the following command to initialize Terraform:

   ```bash
   terraform init
   ```

5. **Define EKS Cluster Configuration:**
   In your `.tf` file, define the resources needed for your EKS cluster. This includes creating a VPC, security groups, subnets, and the EKS cluster itself. Here's a simplified example:

   ```hcl
   provider "aws" {
     region = "us-west-2" # Change to your desired region
   }

   module "eks" {
     source            = "terraform-aws-modules/eks/aws"
     cluster_name      = "my-eks-cluster"
     subnets           = ["subnet-xxxxx", "subnet-yyyyy", "subnet-zzzzz"]
     vpc_id            = "vpc-xxxxx"
     tags              = { Terraform = "true", Environment = "dev" }
   }
   ```

6. **Apply the Configuration:**
   Run the following command to apply your Terraform configuration:

   ```bash
   terraform apply
   ```

   Terraform will show you a plan of what resources will be created or modified. If everything looks correct, type `yes` to proceed with the creation.

7. **Kubeconfig Configuration:**
   After the EKS cluster is provisioned, you'll need to update your `kubeconfig` to access the cluster. Terraform's EKS module should provide outputs with the necessary information to configure `kubeconfig`.

8. **Access the EKS Cluster:**
   You can now use `kubectl` to interact with your provisioned EKS cluster:

   ```bash
   kubectl config use-context <cluster-name>
   kubectl get nodes
   ```

9. **Destroy Resources (Optional):**
   If you want to tear down the provisioned resources, you can use the following command:

   ```bash
   terraform destroy
   ```

Remember that this is a simplified example. You might need to adjust the configuration based on your specific requirements, such as IAM roles, security groups, worker nodes, and more. Always consult the official Terraform documentation and the Terraform module documentation for the AWS EKS cluster you're using for more detailed guidance.

## 2. Installed kubectl in Jenkins Slave.

To install `kubectl` on a Jenkins slave, you need to add the installation steps to your Jenkins pipeline or the configuration of your Jenkins slave image. Below, I'll provide steps for installing `kubectl` in both scenarios:

### Option 1: Installing kubectl in Jenkins Pipeline:

You can add a stage to your Jenkins pipeline that installs `kubectl` on the Jenkins slave dynamically during the pipeline execution. Here's an example of how you can do it:

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

        // Other stages in your pipeline
    }

    // Post-build actions and notifications
}
```

### Option 2: Installing kubectl in Jenkins Slave Image:

If you have control over the image used for your Jenkins slaves, you can install `kubectl` in the image itself. This approach ensures that any Jenkins job running on that slave will have `kubectl` available. Below are steps to do this:

1. Modify the Dockerfile for your Jenkins slave image to include the installation of `kubectl`:

   ```Dockerfile
   FROM jenkins/jnlp-slave

   USER root

   RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
       && chmod +x kubectl \
       && mv kubectl /usr/local/bin/

   USER jenkins
   ```

2. Build the modified Docker image using the Docker CLI or your preferred Docker build process.

3. Configure your Jenkins to use the newly created Docker image for the Jenkins slave.

With either option, once `kubectl` is installed on the Jenkins slave, you can use it in your pipeline stages to interact with your Kubernetes clusters.

Remember to adapt the steps based on your Jenkins setup and your organization's security policies. Always ensure that you're using secure and reliable sources for downloading and installing software.

## 3. Installed AWS CLI v2 in Jenkins Slave to connect with AWS account.

To install AWS CLI version 2 on a Jenkins slave, you'll need to add the installation steps to your Jenkins pipeline or the configuration of your Jenkins slave image. Here's how you can do it:

### Option 1: Installing AWS CLI v2 in Jenkins Pipeline:

You can add a stage to your Jenkins pipeline that installs AWS CLI v2 on the Jenkins slave dynamically during the pipeline execution. Here's an example of how you can do it:

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

        // Other stages in your pipeline
    }

    // Post-build actions and notifications
}
```

### Option 2: Installing AWS CLI v2 in Jenkins Slave Image:

If you have control over the image used for your Jenkins slaves, you can install AWS CLI v2 in the image itself. This approach ensures that any Jenkins job running on that slave will have AWS CLI v2 available. Below are steps to do this:

1. Modify the Dockerfile for your Jenkins slave image to include the installation of AWS CLI v2:

   ```Dockerfile
   FROM jenkins/jnlp-slave

   USER root

   RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
       && unzip awscliv2.zip \
       && sudo ./aws/install

   USER jenkins
   ```

2. Build the modified Docker image using the Docker CLI or your preferred Docker build process.

3. Configure your Jenkins to use the newly created Docker image for the Jenkins slave.

With either option, once AWS CLI v2 is installed on the Jenkins slave, you can use it in your pipeline stages to interact with your AWS resources.

Remember to adapt the steps based on your Jenkins setup and your organization's security policies. Always ensure that you're using secure and reliable sources for downloading and installing software.

## 4. Downloaded Kubernetes credentials and cluster configuration from the cluster using the command

To download Kubernetes credentials and cluster configuration from a cluster, you typically use the `kubectl` command-line tool. The `kubectl` tool allows you to interact with Kubernetes clusters, including retrieving credentials for authentication.

Here's how you can download Kubernetes credentials and configuration using the `kubectl` command:

1. **Install `kubectl` (if not already installed):**
   If you don't have `kubectl` installed on your machine, you can download it from the official Kubernetes website or package manager.

2. **Retrieve Credentials:**
   Run the following command to retrieve the credentials and configuration for a specific cluster:

   ```bash
   kubectl config view --minify --raw
   ```

   This command will print the kubeconfig YAML to the terminal. If you want to save it to a file, you can redirect the output to a file:

   ```bash
   kubectl config view --minify --raw > my-cluster-config.yaml
   ```

3. **Set Active Context (Optional):**
   If you have multiple clusters defined in your kubeconfig file and want to set a specific context as active, you can use the following command:

   ```bash
   kubectl config use-context <context-name>
   ```

   Replace `<context-name>` with the name of the context you want to use.

4. **Access Cluster:**
   Once you have the cluster configuration downloaded, you can use it to access and interact with the Kubernetes cluster using `kubectl` commands. For example:

   ```bash
   kubectl get pods
   kubectl get services
   # ... and other kubectl commands
   ```

Remember to replace placeholders like `<context-name>` with actual values. The downloaded configuration includes authentication tokens and other sensitive information, so make sure to handle it securely.

Additionally, some clusters might have specific authentication mechanisms, such as using service accounts, certificates, or other methods. The method described here is a common way to retrieve and use cluster configuration when using kubeconfig files.
