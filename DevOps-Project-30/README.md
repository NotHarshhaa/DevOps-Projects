# CICD PROJECT: Production Level Blog APP Deployment using EKS, Nexus, SonarQube, Trivy with Monitoring Tools

![s](https://miro.medium.com/v2/resize:fit:700/1*9CvhrnA6Fg1LTmMjr3n3Kg.gif)

=> **Tools Used:**

* **Jenkins:** For managing the CI/CD pipeline.  
* **SonarQube:** For static code analysis.  
* **Nexus:** For managing dependencies and artifacts.  
* **Trivy:** For scanning vulnerabilities in files and Docker images.  
* **Docker:** To containerize applications.  
* **Prometheus:** For monitoring metrics from services.  
* **Blackbox Exporter:** For probing application availability.  
* **Grafana:** For visualizing metrics.  
* **Kubernetes (AWS EKS):** For managing containerized workloads.  
* **Terraform:** For EKS deployment.

**Prerequisites:**

- Basic Understanding of CI/CD: Familiarity with Continuous Integration and Continuous Deployment.
- AWS Account: Access to create and manage EC2 instances and EKS.  
- Git Knowledge: Experience using Git and GitHub.  
- Linux Commands: Basic experience with terminal commands and SSH access.  
- Jenkins, Docker, and Kubernetes knowledge: Understanding of basic setup and usage.

**Table of Contents:**

- **Step 1:** Set up Git Repository and create Security Token  
- **Step 2:** Setup required servers (Jenkins, Sonarqube, Nexus, Monitoring tools)  
- **Step 3:** Set up Jenkins, Sonarqube and Nexus  
- **Step 4:** Install Jenkins Plugins, and Configure Nexus, Trivy, SonarQube and DockerHub to use Jenkins  
- **Step 5:** Create a complete CICD pipeline  
- **Step 6:** Create the EKS cluster, Install AWS CLI, Kubectl and Terraform  
- **Step 7:** Assign a custom domain to the deployed application  
- **Step 8:** Monitor the application

## **Step 1. Set up Git Repository and create Security Token**

a.&gt; **Create the Repo:** We will need to setup a private git repo, it is assumed you already know how to do one. If not [click here](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository) to read the official GitHub docs. You can decide to make it *public or private* for production use, it is best to set it to `private` this way it is more secured and not exposed to the public.

However; by choice I will be leaving my repo `public` , this way you can get access to it and the source files used for this project. [Repo Link](https://github.com/ougabriel/full-stack-blogging-app.git)

b.&gt; **Create a Security Token:** After setting up the git repo, we will have to create a `security token` ; this will help us authenticate easily. Another major importance is that it ensures secured, managed access to your repositories without exposing your actual password.

c.&gt; **Install GitBash in your local system and clone the repo:**

Again, it is assumed you already know how to install Git Bash, it is quite easy to do this for Windows and Mac. Download the OS and follow the installation prompts. [Click Here](https://github.com/git-guides/install-git) to get started and install Git. Having Git on your local system is a advisable because it makes it easier to push and commits code.

After installing Git Bash, we need to clone the [repo](https://github.com/ougabriel/full-stack-blogging-app.git) we will be using, this [repo](https://github.com/ougabriel/full-stack-blogging-app.git) contains the source code needed for this project. [Click Here to CLONE it.](https://github.com/ougabriel/full-stack-blogging-app.git)

```go
git clone https://github.com/ougabriel/full-stack-blogging-app.git
```

I am running the `git clone` command in VS Studio

![s](https://miro.medium.com/v2/resize:fit:700/1*fddWNJ-zAHGtCA1RItSOAg.png)

When this is done make sure to `cd` into the project directory

```go
cd FullStack-Blogging-App/
```

## **Step 2: Setup required servers (Jenkins, Sonarqube, Nexus, Monitoring tools)**

Here, we are going to deploy 2 EC2 instance for Nexus and Sonarqube

To create two `t2.medium`Ubuntu EC2 instances on AWS, follow these steps:

**a.&gt; Log in to AWS Console:** Go to the AWS Management Console and sign in to your account.  
**b.&gt; Navigate to EC2:** In the search bar, type “EC2” and select EC2to go to the EC2 dashboard.  
**c.&gt; Launch Instance:** Click on Launch instances.  
**d. &gt; Configure Instance Details:** -Name: Give a name to your instances. -AMI: Choose an Amazon Machine Image (AMI) by selecting Ubuntu Server 20.04 LTS. -Instance type: Select `t2.medium`from the dropdown.  
**e.&gt; Key Pair (SSH login):** \-Select an existing key pair or create a new one to securely connect via SSH.  
**f.&gt; Network settings:** Create or Choose your preferred VPC and subnet. -Ensure that `Auto-assign publi IP` is enabled for external access. -Configure Security Group: Allow SSH (port 22) access by specifying your IP range of 2000 –11000.  
**g.&gt; 7. Configure storage:** -The storage size should be 20GB  
**h.&gt; 8. Set the Number of Instances:** -In the Number of instances field, enter 2 to create two instances.  
**i.&gt; Launch Instances:** -Review your settings and click Launch.  
**j.&gt;10. Connect:** -Once the instances are running, you can use the SSH keyto connect via terminal:

```go
ssh -i /path/to/your-key.pem ubuntu@<public-ip>
```

Next; we are going to create a separate EC2 instance with a large storage size of 25GB and Instance type of `t2.large`for Jenkins.

Now, repeate the same process and create an EC2 instance of size 25GB and Instance type of `t2.large`, use the same `security group` and dont forget to make sure `Auto-assign publi IP` is enabled for external access.

![s](https://miro.medium.com/v2/resize:fit:700/1*IPdn89vFOIL4lQkmtKHv2g.png)

Best way to connect to the 3 instances is to use [MobaXterm](https://mobaxterm.mobatek.net/documentation.html#1_2), a third party app that can be used to `ssh` into any system. [Find the guide here](https://mobaxterm.mobatek.net/documentation.html#1_2).

## **Step 3: Set up Jenkins, Sonarqube and Nexus**

**3.1 Jenkins set up:** To configure Jenkins for use, we need to install some few things.

a.&gt; SSH into the Jenkins instance

`ssh -i <path-to-your-keyp.pem ubuntu@<jenkins-vm-public-ip>`

b.&gt; Update and install java

```go
sudo apt update
sudo apt install openjdk-17-jre-headless  -y
```

c.&gt; Install Jenkins: Using scripts make it easier to install packages, and helps to save time spent on running single commands.

```go
#!/bin/bash

# Update system packages
sudo apt-get update -y

# Install Java (Jenkins requires Java to run)
sudo apt-get install -y openjdk-11-jdk

# Import Jenkins GPG key and add Jenkins apt repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package lists to include Jenkins repository
sudo apt-get update -y

# Install Jenkins
sudo apt-get install -y jenkins

# Start Jenkins
sudo systemctl start jenkins

# Enable Jenkins to start at boot
sudo systemctl enable jenkins

# Print the initial Jenkins admin password
echo "Jenkins installed successfully!"
echo "You can access Jenkins at http://<your-server-ip>:8080"
echo "Use the following command to retrieve your initial Jenkins admin password:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
```

Run the following command to run the script

```go
vi install_jenkins.sh  #paste the script into the editor. Press Ctrl wq! to save and exit
```

```go
chmod +x install_jenkins.sh
./install_jenkins.sh
```

After the installation; you can login to Jenkins by using `http://<your-jenkins-public-ip>:8080` . You can get the jenkins initial password here `sudo cat /var/lib/jenkins/secrets/InitialAdminPassword`

![s](https://miro.medium.com/v2/resize:fit:700/1*zENajUwkX2icXVPHbvrpdA.png)

login to Jenkins

![s](https://miro.medium.com/v2/resize:fit:700/1*Kc1Hi6IhjBfTHJoigHGC1g.png)

After running the `sudo cat /var/lib/jenkins/secrets/InitialAdminPassword` copy and paste the output to login to Jenkins. When you login click on `suggested plugins` this will help to download all the neccessary plugins plugins required for Jenkins to function. &gt; Next, type in login details (you can use `admin` for both username and password and type in your email)

When this is done correctly we can now access the Jenkins page.

![s](https://miro.medium.com/v2/resize:fit:700/1*Y57UDxJRY5rwLNfXv74cfQ.png)

d.&gt; Install Docker:

```go
#!/bin/bash

# Update existing list of packages
sudo apt-get update

# Install prerequisite packages
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker official GPG key
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the Docker stable repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package index again
sudo apt-get update

# Install Docker Engine, CLI, and containerd
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start Docker
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker

# Verify Docker installation
sudo docker --version

# Add current user to the Docker group to avoid using sudo (optional)
sudo usermod -aG docker $USER

echo "Docker installation completed. Please log out and log back in to apply the group changes."
```

To use the script: i&gt; Copy the script to a file (e.g., `install_docker.sh`). ii.&gt;Make the script executable: `chmod +x install_docker.sh` iii.&gt;Run the script: `./install_docker.sh`

This will install Docker and add your user to the Docker group to avoid using `sudo` for Docker commands.

![s](https://miro.medium.com/v2/resize:fit:700/1*ZeQzwgbTCdFikK8g76E4uQ.png)

Check `docker` version by running the command `docker --version`

***NOTE: This docker script will be used on all other VMs or Instances in this project. You can copy, paste and run the script to have docker installed on all the instances***

**3.2. Nexus set up**

For Nexus: SSH into the VM &gt; Run the command `sudo apt update` &gt; Next, copy and paste the `docker` script used earlier and install the script.

When this is done. We will be running `Nexus` as a docker container

```go
sudo docker run -d -p 8081:8081 sonatype/nexus3
```

![s](https://miro.medium.com/v2/resize:fit:700/1*nwW8WFHRScKVWi2i2zBhsg.png)

Confirm that the `Nexus` container is running `sudo docker ps`

![s](https://miro.medium.com/v2/resize:fit:700/1*r7TVxs-YYsEkspFTldaioA.png)

We can access `Nexus` on `http://<nexus-ip>:8081` &gt; the page may take sometime to come up, just give it some time.

![s](https://miro.medium.com/v2/resize:fit:700/1*iq74y7NHegAn-Q7Wg4YtSA.png)

Sign in: To be able to login, click on the signin button and run this command on the terminal

![s](https://miro.medium.com/v2/resize:fit:644/1*4VkGSjsltH23ssmA5R96vg.png)

```go
sudo docker exec -it <sonar-docker-container-name> /bin/bash
```

```go
cat /nexus-data/admin.password
```

To login, use `admin` as username and the generated password. &gt; Click on `Accept Anonymous Access`

![s](https://miro.medium.com/v2/resize:fit:700/1*LhoEyK0F3djMkda6Q5KDrg.png)

**3.3. Sonarqube setup**

SSH into the sonarqube VM and update it &gt; Install docker with the same script used earlier &gt; check if docker is installed `docker --version` &gt; Next, create a sonarqube container by running the command `sudo docker run -d -p 9000:9000 sonarqube:lts-community` &gt; check the container is running `sudo docker ps`

![s](https://miro.medium.com/v2/resize:fit:700/1*QTNNcsBUQIyHUSCMqwrP9Q.png)

Access `sonarqube` on `http://<sonarqube-ip:9000` &gt; login using `admin` as username and password

![s](https://miro.medium.com/v2/resize:fit:700/1*HW5QLy_RfL6R__W1BPfLeQ.png)

## **Step 4: Install Jenkins Plugins, and Configure Nexus, Trivy, SonarQube and DockerHub to use Jenkins**

**a.&gt; Install Jenkins Plugin**

In the Jenkins page, we need to install some additional plugins we need for this project.

on the left menu, click on ‘manage jenkins’ &gt; click on plugins &gt; available plugins &gt; in the search bar; type and select the following plugins.

***sonarqube scanner, eclipse temurin installer, config file provide, maven integration, pipeline maven integration, kubernetes, kubernetes credential, kubernetes CLI, kubernetes client API, docker, docker pipeline***

\&gt;After selecting them, click on `install` &gt; Restart Jenkins when the installation is done.

**b.&gt; Configure the Plugins:**

When you install plugins, it is a good practice to configure based on your needs. To do this; click on ‘manage jenkins’ &gt; click on ‘tools’

For docker: give a name and leave as default

![s](https://miro.medium.com/v2/resize:fit:700/1*mLaRb27d8RH8FuisSLdlmQ.png)

For maven: give it a name and leave as default

For JDK: click on add &gt; install automatically &gt; click on ‘adoptium.net’ &gt; select jdk 17+35 &gt; Save the configuration

![s](https://miro.medium.com/v2/resize:fit:700/1*Mz201KcoQGFNcaeCjVq6rg.png)

for sonarqube scanner

![s](https://miro.medium.com/v2/resize:fit:700/1*Dhy-SYDm7gO8Y5WJYcKfaQ.png)

**c.&gt; Configure SonarQube Scanner and SonarQube Server**

* Generate token for SonarQube Scanner**:**

To generate a token; at the top menu, click on ‘administration’ &gt; security &gt; in the dropdown menu, click on ‘users’ &gt; then ‘Tokens’ &gt; type in a name and generate the token &gt; copy the token generated

![s](https://miro.medium.com/v2/resize:fit:700/1*FXCJzmxLLSUlq5wSy2KWSw.png)

![s](https://miro.medium.com/v2/resize:fit:700/1*JajxaKPhgD51libZ2hXnDw.png)

After generating the token we need to add this token to our `jenkins` credentials, login to your `jenkins` , click on ‘Manage Jenkins’ &gt; Credentials &gt; Global &gt; click on ‘Add Credentials’ &gt; in the pop page, for ‘kind’ select `Secret text` &gt; paste the SonarQube token into the `secret` box &gt; Create

![](https://miro.medium.com/v2/resize:fit:700/1*IXlUQYZuFetOpzwpzLZ-gg.png)

* Add SonarQube Server Credentials to Jenkins

In ‘Managed Jenkins’ &gt; Click on System &gt; under SonarQube Servers click on `Add SonarQube`

![s](https://miro.medium.com/v2/resize:fit:700/1*1R3JhZvEjXfdgPYYCjIr_Q.png)

\&gt; for URL type in `http://<your-sonarqube-ip:9000` &gt;

![s](https://miro.medium.com/v2/resize:fit:700/1*5d9YpaRVnsg8RR-Vnh6Mjg.png)

**d.&gt; Configure Jenkins to use Trivy**

In the jenkins, click on ‘New Items’ &gt; Select ‘pipeline’ &gt; give a name for the pipeline &gt; and create it. &gt; when it is created, select the pipeline to start building. &gt; click on ‘configure’

In the `jenkins` VM terminal, run the following commands to install `trivy` plugins . This is important if not our `trivy` pipeline commands will not run.

```go
wget https://github.com/aquasecurity/trivy/releases/download/v0.43.0/trivy_0.43.0_Linux-64bit.deb
sudo dpkg -i trivy_0.43.0_Linux-64bit.deb
```

**e.&gt; Configure Jenkins to use Nexus**

\&gt; copy th `maven-releases` and `maven-snapshots`URL

![s](https://miro.medium.com/v2/resize:fit:700/1*E2M3CVu8P-2eFOjYuTbacA.png)

Depending on where you have your source code open, edit the `pom.xml` file and paste it there. (if you have the source code on `vscode` like I did, make sure to push the changes to github)

![s](https://miro.medium.com/v2/resize:fit:700/1*DLIZejEQMY73xLDyQlfbPw.png)

To complete the setup, Jenkins needs authentication to the Nexus Server.

go to Managed Jenkins &gt; Managed Files &gt; Add ‘A new config file’ &gt; Select ‘Global Maven settings.xml’ &gt; scroll down, for `ID`change it to ‘maven-settings’ or any name you can remember &gt; In the pop page, edit the `server` section &gt; Change username and password with your Nexus login credentials . (*In the server section make sure by removing the comments and making sure it looks like this.*)

```go
 <servers>
 
    <server>
      <id>maven-releases</id>
      <username>admin</username>
      <password>admin</password>
    </server>
   
    <server>
      <id>maven-snapshots</id>
      <username>admin</username>
      <password>admin</password>
    </server>
    
  </servers>
```

in the Nexus login page, edit the `deployment policy` for both `maven-releases` and `maven-snapshots` &gt; change it to `allow redeploy`

This will ensure there is no re-build error when the jenkins pipeline attempts to re-send the `artifacts`

![s](https://miro.medium.com/v2/resize:fit:700/1*ECMjbAfYRx4EzmAmgfDO9g.png)

Add credentials to jenkins, in managed jenkins &gt; credentials &gt; global &gt; type in the username and password of the Nexus credentials and create it

![s](https://miro.medium.com/v2/resize:fit:700/1*09DWlvjZbF_xj6gOQezkAQ.png)

**rf.&gt; Configure Jenkins to Dockerhub authentication**

Before building the artifact, we need a registry to store the image. We will doing this with `dockerhub`

\&gt; Log into your [dockerhub](https://hub.docker.com/) and create a **private** repo, you can give it any name .

We will be adding this newly created dockerhub repo into the `Docker Build & Tag`stage of the pipeline

![s](https://miro.medium.com/v2/resize:fit:700/1*Td_GN3RzUZCCHIUzOs5ETg.png)

After creating the `dockerhub` repo, we need to create a `jenkins` credential for it.

Go to ‘managed jenkins’ &gt; click on ‘credentials’ &gt; &gt; global &gt; then ‘Add credentials’ &gt; for kind, select ‘username and password’ &gt; type in your `dockerhub` username and password in their respective fields &gt; for `ID` give it a name so you can can identify it.

![s](https://miro.medium.com/v2/resize:fit:700/1*_Zr5s-jKj2FUZjiSkawofg.png)

We will need to add the credentials to system settings, go to managed jenkins &gt; systems &gt; edit the docker section and select the newly docker credentials you just created.

![s](https://miro.medium.com/v2/resize:fit:700/1*xPj0l8lF2woNP8XAKZEXrw.png)

## **Step 5: Create a complete CICD pipeline**

This pipeline should be changed to fit your `docker image` and `dockerhub` details. This is not the end of the pipeline, because we still going to integrate Email Push Notification within the pipeline that tells us when the pipeline fails or succeeds.

```go
pipeline {
    agent any
    tools {
        jdk "jdk"
        maven "maven"
    }
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }
    
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ougabriel/full-stack-blogging-app.git'
            }
        }
        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }
        stage('Trivy FS') {
            steps {
                sh "trivy fs . --format table -o fs.html"
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqubeServer') {
                    sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Blogging-app -Dsonar.projectKey=Blogging-app \
                          -Dsonar.java.binaries=target'''
                }
            }
        }
        stage('Build') {
            steps {
                sh "mvn package"
            }
        }
        stage('Publish Artifacts') {
            steps {
                withMaven(globalMavenSettingsConfig: 'maven-settings', jdk: 'jdk', maven: 'maven', mavenSettingsConfig: '', traceability: true) {
                        sh "mvn deploy"
                }
            }
        }
        stage('Docker Build & Tag') {
            steps {
                script{
                withDockerRegistry(credentialsId: 'dockerhub-cred', url: 'https://index.docker.io/v1/') {
                sh "docker build -t ugogabriel/gab-blogging-app ."
                }
                }
            }
        }
        stage('Trivy Image Scan') {
            steps {
                sh "trivy image --format table -o image.html ugogabriel/gab-blogging-app:latest"
            }
        }
        stage('Docker Push Image') {
            steps {
                script{
                withDockerRegistry(credentialsId: 'dockerhub-cred', url: 'https://index.docker.io/v1/') {
                    sh "docker push ugogabriel/gab-blogging-app"
                }
                }
            }
        }
    }  // Closing stages
}  // Closing pipeline
```

Run the build, and click on stages to see the pipeline stages

![s](https://miro.medium.com/v2/resize:fit:700/1*L_BVlWCtjuhkUMEtCtOeLA.png)

## **Step 6: Create the EKS cluster, Install AWS CLI, Kubectl and Terraform**

We will need to create a VM, install and use`terraform` to deploy the EKS service into the machine and install and use`kubectl` to interact with this EKS cluster.

**a.&gt; Create the VM:** Login to the AWS console and create a new EC2 instance (t2 medium, 15GB) as we did before &gt; use the same `keypair` and `security group` as the other instances and make sure the `public IP` is enabled. &gt; Create the instance.

**b.&gt; Install AWS CLI:** The AWS CLI (Command Line Interface) allows you to interact with AWS services directly from your terminal.

```go
# Update the package list
sudo apt update

# Install curl if not already installed
sudo apt install curl -y

# Download the AWS CLI v2 installation file
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Install unzip and extract the downloaded zip file
sudo apt install unzip -y
unzip awscliv2.zip

# Run the AWS CLI installer
sudo ./aws/install

# Verify the installation
aws --version
```

After the installation we need to connect the cluster to our AWS; to do this we need to create a `access key` that will be to authenticate to AWS services.

\&gt; In your AWS console &gt; click on your profile &gt; security credentials &gt; and Create access key

![s](https://miro.medium.com/v2/resize:fit:700/1*5sewfFjH30xdhpRJDBe_AQ.png)

Run the following command `aws configure`in your AWS console &gt; copy and paste the access key and security access keys in the prompts.

![s](https://miro.medium.com/v2/resize:fit:700/1*yolxqqz86E8E6dK-3rMiQw.png)

Follow the prompts as shown below

![s](https://miro.medium.com/v2/resize:fit:700/1*3zmbMSuEJyF1582l1zBGsw.png)

**c.&gt; Install Terraform:** Install `terraform` in this instance by running this command

```go
sudo apt install terraform --classic
```

We need 3 `tf` files for our `terraform` script. Which is the `main.tf` , `output.tf` and `variable.tf` . ***(find the files in the given github repo for this project)***

```go
vi output.tf
vi main.tf
vi variable.tf
```

Run this command individually, copy and paste the `terraform` scripts into the editor &gt; save and exit.

![s](https://miro.medium.com/v2/resize:fit:700/1*Cmc256p9GYJJz_2r1cqleg.png)

To deploy the resources, we need to first run the following commands

***(optional: make sure to change the*** `main.tf` ***region and the availabilty zone to suite your region)***

* **Important**: in the `variable.tf`script you MUST change the `default = "gabkeypair` to the name of your AWS instance `keypair`if the name is different from this.

* `terraform init` : to initialize the project, It downloads the necessary provider plugins and sets up the backend where Terraform will store state data.

* `terraform plan` : Prepares an execution plan, showing what actions Terraform will take to deploy the infrastructure. It lists the resources that will be created, modified, or destroyed. In this case, you would see a plan indicating that **17 resources** are going to be deployed.

![s](https://miro.medium.com/v2/resize:fit:700/1*EF2O40R_5uLR_xNBoLpoMw.png)

* `terraform apply`: Executes the plan and actually deploys the infrastructure. Terraform will create, modify, or delete resources as outlined in the execution plan.

preferrably; run this command

```go
terraform apply --auto-approve
```

***Make sure to run the commands in the order given above***

When you run the command, it will take sometime for all the changes or all the services to be fully deployed.

After the installation when you run `kubectl get nodes` you will notice the error `Command kubectl not found` this is because the `kubectl` command is not yet installed.

```go
sudo snap install kubectl --classic
```

![s](https://miro.medium.com/v2/resize:fit:700/1*negFmPb_0TQ7jOc50qKWww.png)

After installing `kubectl` we need to confirm if our `nodes` are ready; run the command `kubectl get nodes` . You should get another error as shown below.

![s](https://miro.medium.com/v2/resize:fit:700/1*c3zAO_FyuYZiY6-AP8LYHQ.png)

This is because you are yet to connect the EKS cluster to AWS services, do that using this command;

```go
aws eks --region eu-west-2 update-kubeconfig --name <cluster-name>
```

Run the command again this time to the `nodes` ready

![s](https://miro.medium.com/v2/resize:fit:700/1*qIZqsyXe9CPmn1ljAlI72w.png)

**d.&gt; Setup Service Account and RBAC**

**RBAC is one of the most important concepts of Kubernetes.** In order to be able to perform deployments and authentication with this cluster we need to create a `service account` and give it necessary permissions. RBAC (Role Based Access Control) we will create roles, rolebinding, a token for the secret which we will be used for authentication. Copy and paste the following commands into the `vi` editor

Create a `namespace`

```go
kubectl create namespace webapps
```

Service Account &gt; `vi serviceaccount.yaml`

```go
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jenkins
  namespace: webapps
```

Role &gt; `vi role.yaml`

```go
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: webapps
  name: role
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["get", "list", "create", "delete", "patch", "watch"]
```

Rolebinding &gt; `vi rolebinding.yaml`

```go
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: rolebinding
  namespace: webapps
subjects:
- kind: ServiceAccount
  name: jenkins # The service account created earlier
  namespace: webapps
roleRef:
  kind: Role
  name: role  # The role created earlier
  apiGroup: rbac.authorization.k8s.io
```

Token for Service Account Secret &gt; `vi sa-secret.yaml`

```go
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: mysecretname
  namespace: webapps  # Make sure to specify the correct namespace
  annotations:
    kubernetes.io/service-account.name: jenkins  # The service account name
```

Apply all the `yaml` files,

```go
kubectl apply -f serviceaccount.yaml
kubectl apply -f role.yaml
kubectl apply -f rolebinding.yaml
kubectl apply -f sa-secret.yaml
```

If you check the `git repo` for this project, you will see the `deployment-service.yml` which will be deployed to this EKS cluster. We will need to create an `imagePullSecret`for it to pull our `docker image from the dockerhub private registry` . When working with private registry, you will need to provide an authentication secret that helps it get access to the private registry. Run the following command. (change `username` and `password` to that of your dockerhub credentials).

```go
kubectl create secret docker—registry regcred \
--docker—server=https://index.docker.io/v1/ \
--docker—username=<your—username> \
--docker—password=<your—password>
--namespace=webapps
```

`regcred` *is the name of the* `imagePullSecret` *. This is already added to the* `deployment.yaml` *file in the git repo.*

**e.&gt; Authenticate Jenkins with EKS using secret**

If you run the command, `kubectl get secrets -n webapps` you will notice we have two secrets.

![s](https://miro.medium.com/v2/resize:fit:700/1*u7MaNDWa6AFQxT8CcTJUIQ.png)

One for pulling the image from the dockehub private registry and the other for the `service account` authentication. Run the command `kubectl describe secret mysecretname -n webapps` to get the `authentication token` for our service account secret.

![s](https://miro.medium.com/v2/resize:fit:700/1*BAA3-DCJCKZ-4rx4jQ5OOg.png)

Go to jenkins, click on ‘manage jenkins’ &gt; Credentials &gt; Global &gt; Add credentials &gt; for `kind` select ‘secret text’ &gt; paste the token within the ‘secret’ box &gt; give it a name &gt; Create

![s](https://miro.medium.com/v2/resize:fit:700/1*c7Nq-k6CFfsBef2dV4g41g.png)

**f.&gt; Install Kubectl on Jenkins, Modify the Pipeline and Setup Email Notification**

We will be inserting `kubectl` command in the pipeline, we will need to install it on the Jenkins machine so that `kubectl` command syntax can be able to work.

```go
sudo snap install kubectl --classic
```

Now, we will be modifying the pipeline to deploy our kubernetes resources. we will be adding 3 more stages to the pipeline script for this purpose.

**g.&gt; Setup Email Notifications**

Copy and paste the following into the browser to generate an email authentication password. (GMAIL only)

```go
https://myaccount.google.com/apppasswords
```

for other email accounts, you can do this.

```go
For Hotmail/OutlookGo to your Microsoft Account Security page.
Click on Advanced security options.
Under App passwords, click on Create a new app password.
Use the generated app password in your application (e.g., Jenkins) instead of your regular password.For Yahoo:Go to your Yahoo Account Security page.
Enable Two-step verification if not already enabled.
After enabling 2FA, select Generate app passwords.
Use the app password in your application (e.g., Jenkins) instead of your regular password.
```

Click on ‘manage jenkins’ &gt; systems &gt; scroll down till you find `Email Notification` &gt; fill in the boxes as shown &gt; test the connection

![s](https://miro.medium.com/v2/resize:fit:700/1*et5B_nY8hTlXL7O9hL-Xhw.png)

***Make sure port 465 is open in your AWS NSG (Network Security Group).***

Within the same page, configure the same thing for `Extended Email notification` , this time you will add a credential named `email cred` containing the username and generated password of the email you used earlier.

![s](https://miro.medium.com/v2/resize:fit:700/1*2mcXsv2Ev_BMzOFbXEovPg.png)

To see the 2 new stages (k8s-deploy and k8s verify) added to the pipeline please check the [jenkinsfile in the git repo](https://github.com/ougabriel/full-stack-blogging-app/tree/main). Trigger the pipeline to deploy the application

## **Step 7: Assign a custom domain to the deployed application**

![s](https://miro.medium.com/v2/resize:fit:700/1*Qy26mTb5vi7YmUpaNblGlA.png)

![s](https://miro.medium.com/v2/resize:fit:700/1*gP5g-35J7kqEu_rq5QIkSQ.png)

Add the URL link into an existing Domain from any domain name provider for example (godaddy) using the `CNAME` type. Perform an nslookup to verify it is up. Then try it on the browser to view the app.

***Note: this is optional. I dont need this app to have any special domain url but you can try it for practice***

## **Step 8: Monitor the application**

Create another EC2 instance of `t2large` and `25GB` &gt; install grafana, prometheus and blackbox on the instance using the following command.

**a.&gt; Set Up Blackbox Exporter:** Blackbox Exporter is used for probing endpoints and checking their availability.

Install Blackbox Exporter

Download and run Blackbox Exporter:

```go
wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.21.0/blackbox_exporter-0.21.0.linux-amd64.tar.gz
 tar xvfz blackbox_exporter-0.21.0.linux-amd64.tar.gz
 cd blackbox_exporter-0.21.0.linux-amd64
 ./blackbox_exporter
```

Configure Blackbox Exporter &gt; `vi blackbox.yaml`

```go
modules:
  http_2xx:
    prober: http
    timeout: 5s
    http:
      method: GET
      valid_http_versions: [ "1" ]
      valid_http_mimes: [ "application/json" ]
      valid_http_status_codes: []  # Defaults to 2xx
```

**b.&gt; Set Up Prometheus:** Prometheus will be used to collect metrics from various sources, including the Blackbox Exporter.

Install Prometheus &gt; `sudo apt install prometheus -y`

Create the Prometheus config file &gt; `vi prometheus.yaml`

```go
global:
  scrape_interval: 15s
  evaluation_interval: 15s

crape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]  # Look for an HTTP 200 response
    static_configs:
      - targets:
          - http://prometheus.io
          - https://prometheus.io
######blog app url link
          - aeac8ab098ec448ca94c681962c91277-1539973516.eu-west-2.elb.amazonaws.com  #the blogging app url link to probe
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: 18.175.135.0:9115  # Blackbox Exporter address
```

***Make sure to change the*** `blackbox exporter address` ***and*** `blog app url link`***to that which points to your VM IP. and change the blog app url link***

Run Prometheus &gt; `prometheus --config.file=prometheus.yaml`

**c.&gt; Set Up Grafana:** Grafana will be used for visualizing metrics collected by Prometheus.

```go
# Update package list and install necessary dependencies
sudo apt-get update
sudo apt-get install -y software-properties-common curl

# Add Grafana GPG key
curl https://packages.grafana.com/gpg.key | sudo apt-key add -

# Add Grafana APT repository
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

# Update package list again and install Grafana
sudo apt-get update
sudo apt-get install -y grafana

# Start Grafana service
sudo systemctl start grafana-server

# Enable Grafana to start on boot
sudo systemctl enable grafana-server

# Print the status of Grafana service
sudo systemctl status grafana-server
```

**d.&gt; Verify Installations:** Do this on the termline

```go
#for blackbox
curl http://localhost:9115

#for blackbox exporter metrics
curl http://localhost:9115/metrics

#for prometheus
curl http://localhost:9090/metrics

#for grafana
sudo systemctl status grafana-server
```

Open `grafana` and `prometheus` using your VM IP and their port

```go
#for grafana
http://<monitoring-vm-ip>:3000

#for prometheus
http://<monitoring-vm-ip>:9090

#for blackbox
http://<monitoring-vm-ip>:9115
```

**e.&gt; Add data source and create dashboard:**

* Open Grafana in your web browser: &gt; Log in with the default credentials (\`admin/admin\`) &gt; click on Administration &gt; Add Prometheus as a data source &gt; Set the URL to your Prometheus instance &gt; Click `Save & Test`.

* On the left pane click on ‘import dashboard’ &gt; for ID type in `7587`  
    and click `Load` &gt; select a data source (prometheus) &gt; click import

![s](https://miro.medium.com/v2/resize:fit:700/1*gAWoFnl1suEEWDNKVjaVEA.png)

* Prometheus: collects and stores metrics.  
* Blackbox Exporter: probes your application endpoints and provides metrics to Prometheus.  
* Grafana: visualizes the metrics collected by Prometheus.

By setting up these components, you’ll be able to monitor your application’s health and performance effectively.

### **The End**

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
