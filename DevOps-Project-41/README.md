# 🚀 End-to-End DevOps Project: Deploying Swiggy Clone with Terraform, Jenkins, SonarQube, Trivy & Docker

[![AWS](https://img.shields.io/badge/AWS-EC2%20%7C%20VPC%20%7C%20IAM-232F3E?logo=amazon-aws&logoColor=white)](#)
[![Terraform](https://img.shields.io/badge/Terraform-1.5+-7B42BC?logo=terraform&logoColor=white)](#)
[![Jenkins](https://img.shields.io/badge/Jenkins-CI%2FCD-D24939?logo=jenkins&logoColor=white)](#)
[![SonarQube](https://img.shields.io/badge/SonarQube-Code%20Quality-4E9BCD?logo=sonarqube&logoColor=white)](#)
[![Trivy](https://img.shields.io/badge/Trivy-Security%20Scanning-1904DA?logo=aquasecurity&logoColor=white)](#)
[![Docker](https://img.shields.io/badge/Docker-Containerization-2496ED?logo=docker&logoColor=white)](#)
[![NodeJS](https://img.shields.io/badge/Node.js-20%20LTS-339933?logo=node.js&logoColor=white)](#)

---

## 📖 Overview

In this production-ready DevOps implementation guide, we build a complete automated CI/CD and DevSecOps pipeline from scratch. Starting from **Infrastructure as Code (IaC)** using **Terraform on AWS**, we set up and configure **Jenkins**, integrate **SonarQube** for continuous code quality analysis, enforce **Quality Gates**, run **Trivy vulnerability scans** on filesystem and container images, and automate containerized deployment of a **Swiggy Clone** web application 🍔☕.

---

## 🎥 Project Video Walkthrough

Watch the complete, end-to-end video tutorial explaining every step of this project:

[![DevOps Real-time Project | Deployment of SWIGGY App](https://img.youtube.com/vi/x55z7rk0NAU/maxresdefault.jpg)](https://youtu.be/x55z7rk0NAU?si=k1MGk-iOHn5Zxl0h)

> 📺 **Watch Full Video:** [DevOps Real-time Project | Deployment of SWIGGY App (YouTube)](https://youtu.be/x55z7rk0NAU?si=k1MGk-iOHn5Zxl0h)  
> *Author: Kastro Kiran V*

---

## 🏗️ Architecture & Pipeline Flow

```
[ Git / GitHub ] ───► [ Jenkins CI Server ]
                             │
                             ├─► 1. Clean Workspace & Git Checkout
                             ├─► 2. SonarQube Static Analysis & Quality Gate Check
                             ├─► 3. NPM Dependencies Installation
                             ├─► 4. Trivy Filesystem Vulnerability Scan
                             ├─► 5. Docker Image Build & Tagging
                             ├─► 6. Trivy Container Image Security Scan
                             ├─► 7. Push to DockerHub Registry
                             └─► 8. Deploy Container (Docker Run on Port 3000) ──► [ Live Users ]
```

### 📋 Prerequisites & Port Requirements

Ensure your AWS EC2 instance has appropriate resources (Recommended: `t2.large` or `t3.large`, 2–4 vCPUs, 8 GB RAM, 30 GB EBS Storage) and the following inbound ports opened in your Security Group:

| Service | Port | Protocol | Purpose |
| :--- | :--- | :--- | :--- |
| **SSH** | `22` | TCP | Remote EC2 Administration |
| **Jenkins** | `8080` | TCP | Jenkins CI/CD Automation Web UI |
| **SonarQube** | `9000` | TCP | SonarQube Code Quality Dashboard |
| **Swiggy App** | `3000` | TCP | Live Deployed React/Node Application |

---

## 🛠️ Step 1: Provision AWS Infrastructure with Terraform

We use Terraform to define our cloud infrastructure declaratively, ensuring repeatable and reproducible deployments.

🔗 **GitHub Repository for Terraform Code:**  
👉 [Terraform-Script-Swiggy-sandeep](https://github.com/sandeepallakonda/Terraform-Script-Swiggy-sandeep)

### 📂 Key Terraform Files:

- `main.tf` → Terraform backend configuration, provider pinning, and core infrastructure setup.
- `provider.tf` → AWS provider definition, specifying target region and credentials.
- `resource.tf` → Provisions EC2 instance, VPC, Subnets, Security Groups, IAM Roles, and Key Pairs.
- `variables.tf` / `outputs.tf` → Dynamic input variables (AMI, instance types) and useful outputs (public IP address, DNS).

### ⚡ Terraform Execution Commands:

```bash
# 1. Initialize provider plugins and backend
terraform init

# 2. Review execution plan and dry-run infrastructure diff
terraform plan

# 3. Provision EC2 instance, networking, and security groups
terraform apply -auto-approve

# (When finished with project) Teardown all cloud resources to avoid costs
# terraform destroy -auto-approve
```

![Terraform Infrastructure Architecture](https://miro.medium.com/v2/resize:fit:1400/1*7W1lBunIq2SFzfcLvWCQ2w.png)

🎉 **Your EC2 instance and networking stack are now provisioned and running!**

---

## 💻 Step 2: Connect to EC2 & Verify Services

You can connect directly from your browser using **AWS EC2 Instance Connect**:

1. Navigate to **AWS Management Console → EC2 → Instances**.
2. Select your provisioned instance.
3. Click **Connect → EC2 Instance Connect → Connect**.

![AWS EC2 Instance Connect](https://miro.medium.com/v2/resize:fit:1400/1*xdnlQEj7lRimMYDjObON5w.png)

### 🔗 Verify Running Services:

Once your setup script/userdata has finished running, access the web dashboards:

- **Jenkins Web UI:**  
  `http://<EC2-PUBLIC-IP>:8080`

![Jenkins Service Dashboard](https://miro.medium.com/v2/resize:fit:1400/1*3UYzLvuudWWIeZ-2MaA5_g.png)

- **SonarQube Dashboard:**  
  `http://<EC2-PUBLIC-IP>:9000`

![SonarQube Service Dashboard](https://miro.medium.com/v2/resize:fit:1400/1*nGT2HssK1hz_Tvb7h5F6qA.png)

---

## 🔧 Step 3: Jenkins Plugins & Tool Configuration

### 🧩 1. Install Necessary Jenkins Plugins

Navigate to **Manage Jenkins → Plugins → Available Plugins**, search for and install:

- ✅ **Eclipse Temurin installer (JDK):** Provides Java runtimes required by Jenkins and the SonarQube Scanner.
- ✅ **Pipeline Stage View:** Visualizes pipeline stages cleanly in real-time.
- ✅ **SonarQube Scanner:** Enables static code analysis and transmits findings directly to the SonarQube dashboard.
- ✅ **NodeJS:** Allows Jenkins to manage and switch Node.js versions for front-end dependency builds.
- ✅ **Docker (Common, Pipeline, API):** Grants pipeline access to Docker commands for building, tagging, and pushing images.

![Jenkins Available Plugins Setup](https://miro.medium.com/v2/resize:fit:1400/1*gAFhDYcSrej5utgEq1w5Iw.png)

---

### ⚙️ 2. Global Tool Configuration

Once plugins are installed, configure runtime versions under **Manage Jenkins → Tools (Global Tool Configuration)**:

1. **JDK Installation:**
   - **Name:** `jdk17`
   - **Source:** Install automatically from adoptium.net (Java 17 LTS).
2. **SonarQube Scanner Installations:**
   - **Name:** `sonar-scanner`
   - **Version:** `sonar-scanner (v6.2.1.4610)` or latest stable.
3. **NodeJS Installations:**
   - **Name:** `node20`
   - **Version:** `NodeJS 20.x` (LTS).
4. **Docker Installations:**
   - **Name:** `docker`
   - **Version:** Latest Docker CLI.

![Jenkins Global Tool Configuration](https://miro.medium.com/v2/resize:fit:1400/1*N5XVYd3GVjlwYJBX6VDJ7g.png)

💾 Click **Apply** and **Save**.

---

## 🔐 Step 4: Integrate SonarQube with Jenkins

### 1. Generate SonarQube User Authentication Token

1. Access SonarQube at `http://<EC2-IP>:9000` (Default credentials: `admin` / `admin`).
2. Go to **Administration → Security → Users**.
3. Under the **Tokens** column for `Administrator`, click the token icon.
4. Name the token `sonar-token` and click **Generate**.
5. Copy the generated token string.

![Generate SonarQube User Token](https://miro.medium.com/v2/resize:fit:1400/1*KpZ4tDQqCg3s5bXtZzZ6UQ.png)

---

### 2. Store SonarQube Token in Jenkins Credentials

1. Go to **Manage Jenkins → Credentials → System → Global credentials → Add Credentials**.
2. **Kind:** `Secret text`
3. **Secret:** Paste the generated SonarQube token.
4. **ID:** `sonar-token`
5. **Description:** `SonarQube Authentication Token`
6. Click **Create**.

![Add SonarQube Token to Jenkins Credentials](https://miro.medium.com/v2/resize:fit:1400/1*QVOhw-uaWO0cwhU3NogfJQ.png)

---

### 3. Create Quality Gate Webhook in SonarQube

To allow SonarQube to notify Jenkins when Quality Gate checks pass or fail:

1. In SonarQube, navigate to **Administration → Configuration → Webhooks**.
2. Click **Create**.
3. **Name:** `jenkins-webhook`
4. **URL:** `http://<EC2-PUBLIC-IP>:8080/sonarqube-webhook/`
5. Click **Create**.

![Configure Webhook in SonarQube](https://miro.medium.com/v2/resize:fit:1400/1*F3xnB_UAW-PFtiSxxDsrBg.png)

---

### 4. Configure SonarQube Server in Jenkins System Settings

1. Go to **Manage Jenkins → System (Configure System)**.
2. Scroll to the **SonarQube servers** section.
3. Check **Enable injection of SonarQube server configuration as environment variables**.
4. Click **Add SonarQube**:
   - **Name:** `sonar-server` *(must match the name used in your Jenkinsfile)*
   - **Server URL:** `http://<EC2-PUBLIC-IP>:9000`
   - **Server authentication token:** Select `sonar-token` from the dropdown.
5. Click **Save**.

![Configure SonarQube Server in Jenkins System Settings](https://miro.medium.com/v2/resize:fit:1400/1*salrr873BLv73sBhTTwX7g.png)

---

## 🐳 Step 5: Configure DockerHub Credentials in Jenkins

To enable Jenkins to authenticate and push the built Docker image to DockerHub:

1. Go to **Manage Jenkins → Credentials → System → Global credentials → Add Credentials**.
2. Fill in the fields:
   - **Kind:** `Username with password`
   - **Username:** Your DockerHub username
   - **Password:** Your DockerHub password or Personal Access Token
   - **ID:** `docker-creds` *(referenced in pipeline script)*
   - **Description:** `DockerHub Registry Credentials`

![Add DockerHub Credentials in Jenkins](https://miro.medium.com/v2/resize:fit:1400/1*0pk1zhj3HG9dQ6M0FzMvQA.png)

3. Click **Create** to save the credentials.

![DockerHub Global Credentials Saved](https://miro.medium.com/v2/resize:fit:1400/1*2JjM_5Z3izTRbUvwfEa1og.png)

> 💡 **Tip:** Ensure the `jenkins` system user has permissions to interact with the Docker daemon on the EC2 host:
> ```bash
> sudo usermod -aG docker jenkins
> sudo systemctl restart jenkins
> ```

---

## 📜 Step 6: Create Jenkins Pipeline Job

🔗 **GitHub Repository for Application Code:**  
👉 [DevOps-Project-Swiggy](https://github.com/NotHarshhaa/DevOps-Projects/tree/master/DevOps-Project-41/DevOps-Project-Swiggy)

1. Go to Jenkins Dashboard → **New Item**.
2. Enter item name: `Swiggy-DevOps-Pipeline`.
3. Select **Pipeline** and click **OK**.

![Create Jenkins Pipeline Project](https://miro.medium.com/v2/resize:fit:1400/1*3leTOYl9nCciqYwajS6rFw.png)

4. Scroll down to the **Pipeline** script definition block and paste the declarative `Jenkinsfile`:

### 📄 Declarative Jenkinsfile:

```groovy
pipeline {
    agent any

    tools {
        jdk 'jdk17'
        nodejs 'node20'   // Node.js 20 LTS
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        DOCKER_IMAGE = 'sandeepallakonda/swiggy'
        DOCKER_TAG   = 'latest'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout from Git') {
            steps {
                git branch: 'master', 
                    url: 'https://github.com/NotHarshhaa/DevOps-Projects/tree/master/DevOps-Project-41/DevOps-Project-Swiggy'
            }
        }

        stage('SonarQube Code Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh """
                        $SCANNER_HOME/bin/sonar-scanner \
                          -Dsonar.projectKey=Swiggy \
                          -Dsonar.projectName=Swiggy \
                          -Dsonar.sources=.
                    """
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    timeout(time: 2, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }

        stage('Trivy Filesystem Security Scan') {
            steps {
                sh "trivy fs . --exit-code 0 --severity HIGH,CRITICAL -f table -o trivy-fs-report.txt"
                archiveArtifacts artifacts: 'trivy-fs-report.txt', allowEmptyArchive: true
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-creds', toolName: 'docker') {
                        sh """
                            docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                            docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                        """
                    }
                }
            }
        }

        stage('Trivy Image Vulnerability Scan') {
            steps {
                sh "trivy image ${DOCKER_IMAGE}:${DOCKER_TAG} --exit-code 0 --severity HIGH,CRITICAL -f table -o trivy-image-report.txt"
                archiveArtifacts artifacts: 'trivy-image-report.txt', allowEmptyArchive: true
            }
        }

        stage('Deploy to Container') {
            steps {
                sh """
                    docker rm -f swiggy || true
                    docker run -d --name swiggy -p 3000:3000 ${DOCKER_IMAGE}:${DOCKER_TAG}
                """
            }
        }
    }

    post {
        always {
            echo "Pipeline execution finished."
        }
        success {
            echo "🎉 Swiggy Application deployed successfully to production container!"
        }
        failure {
            echo "❌ Pipeline failed! Please review stage logs and security reports."
        }
    }
}
```

---

## 🚀 Step 7: Build, Scan & Deploy

Click **Build Now** on the Jenkins pipeline page.

### 📊 Pipeline Stage Flow:

1. **Clean Workspace** → Prepares fresh workspace directory.
2. **Checkout from Git** → Clones source code from GitHub repository.
3. **SonarQube Analysis** → Performs SAST code scanning and transmits metric data.
4. **Quality Gate** → Verifies SonarQube Quality Gate threshold status.
5. **Install Dependencies** → Installs NPM packages via Node 20.
6. **Trivy FS Scan** → Audits repository source dependencies for HIGH/CRITICAL CVEs.
7. **Docker Build & Push** → Builds production container image and pushes to DockerHub.
8. **Trivy Image Scan** → Scans the compiled container image layers for known vulnerabilities.
9. **Deploy Container** → Launches container exposed on port 3000.

![Jenkins Pipeline Stages Execution View](https://miro.medium.com/v2/resize:fit:1400/1*SLI-xw5LUx1lPIyx47FLxQ.png)

---

## 🌐 Live Application Verification

Open your web browser and navigate to:

👉 **`http://<EC2-PUBLIC-IP>:3000`**

![Swiggy App Live Deployed](https://miro.medium.com/v2/resize:fit:1400/1*hHU18yqR1pRvZW7e665ZyA.png)

🍔 **The Swiggy Clone web application is now successfully running live in Docker!**

---

## 🎯 Summary & Key DevOps Takeaways

By completing this project, you have implemented a real-world enterprise DevSecOps workflow:

- ☁️ **Infrastructure as Code (IaC):** Automated cloud resource provisioning with Terraform.
- 🔄 **Continuous Integration (CI):** Automated builds, linting, and dependency tracking with Jenkins.
- 🛡️ **DevSecOps & Code Quality:** SonarQube static code analysis + Quality Gate enforcement.
- 🔒 **Vulnerability Management:** Trivy multi-stage scanning on filesystems and container layers.
- 📦 **Containerization & CD:** Automated image packaging and production deployment with Docker.

---

## 🛠️ **Author & Community**

This project is crafted by [**Harshhaa**](https://github.com/NotHarshhaa) 💡.  
I’d love to hear your feedback! Feel free to share your thoughts.

---

### 📧 **Connect with me:**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-%230077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/harshhaa-vardhan-reddy) [![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/NotHarshhaa) [![Telegram](https://img.shields.io/badge/Telegram-26A5E4?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/prodevopsguy) [![Dev.to](https://img.shields.io/badge/Dev.to-0A0A0A?style=for-the-badge&logo=dev.to&logoColor=white)](https://dev.to/notharshhaa) [![Hashnode](https://img.shields.io/badge/Hashnode-2962FF?style=for-the-badge&logo=hashnode&logoColor=white)](https://hashnode.com/@prodevopsguy)

---

### 📢 **Stay Connected**

![Follow Me](https://imgur.com/2j7GSPs.png)
