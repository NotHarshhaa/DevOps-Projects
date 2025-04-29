# 🚀 Implementation of the Entire Advanced CI/CD Pipeline with Major DevOps Tools

![DevOps Pipeline](https://imgur.com/WcCpKVU.png)

A comprehensive end-to-end CI/CD pipeline leveraging **Terraform**, **Ansible**, **Jenkins**, **SonarQube**, **JFrog**, **Docker**, **EKS**, **Prometheus**, and **Grafana**.

---

## 🧩 Pipeline Architecture Overview

> Below is a step-by-step implementation breakdown of the complete DevOps CI/CD process.

<details>
<summary><strong>🔧 Step 1: Infrastructure Provisioning (Terraform)</strong></summary>

- Provisioned **VPC**, **Security Groups**, **Ansible Controller**, **Jenkins Master**, and **Agent Instances** using Terraform.  
🔗 [Step Details](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step1.md#L1)

</details>

<details>
<summary><strong>🔐 Step 2: SSH Configuration</strong></summary>

- Set up password-less authentication between Ansible Controller and Agent nodes.  
🔗 [Step Details](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step2.md#L1)

</details>

<details>
<summary><strong>⚙️ Step 3: Jenkins Setup (Ansible)</strong></summary>

- Configured Jenkins Master and Agent nodes.  
- Agent configured as **Maven Build Server**.  
🔗 [Step Details](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step3.md#L1)

</details>

<details>
<summary><strong>🔗 Step 4: Jenkins Master-Agent Integration</strong></summary>

- Connected Jenkins Master to Agent with credentials.  
🔗 [Step Details](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step4.md#L1)

</details>

<details>
<summary><strong>🌐 Step 5: GitHub Integration</strong></summary>

- Added GitHub credentials.  
- Created **Multibranch Pipeline Job**.  
🔗 [Step Details](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step5.md#L1)

</details>

<details>
<summary><strong>🚨 Step 6: Webhook Trigger Setup</strong></summary>

- Configured GitHub webhook trigger using **Multibranch Scan Webhook Trigger Plugin**.  
🔗 [Step Details](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step6.md#L1)

</details>

<details>
<summary><strong>🧪 Step 7: SonarQube Integration</strong></summary>

- Generated access token in SonarCloud.  
- Installed SonarQube scanner plugin.  
- Added SonarQube server and scanner to Jenkins.  
- Configured `sonar-project.properties`.  
- Added **code quality**, **unit test**, and **build** stages in `Jenkinsfile`.  
🔗 [Step-by-step Setup](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step7.md#L3)

</details>

<details>
<summary><strong>📦 Step 8: JFrog Artifactory Integration</strong></summary>

- Configured JFrog credentials.  
- Installed Artifactory plugin in Jenkins.  
🔗 [Details](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step8.md#L1)

</details>

<details>
<summary><strong>🐳 Step 9: Docker Image & Push to JFrog</strong></summary>

- Built Docker image from `.jar`.  
- Pushed to JFrog Artifactory using **Docker Pipeline Plugin**.  
- Added **Docker Build & Publish** stage to Jenkinsfile.  
🔗 [Details](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step9.md#L1)

</details>

<details>
<summary><strong>☸️ Step 10: EKS Cluster Setup</strong></summary>

- Created **EKS cluster** via Terraform.  
- Installed `kubectl` and AWS CLI in Jenkins slave.  
- Configured Kube credentials using:
  ```
  aws eks update-kubeconfig --region <region_name> --name <cluster_name>
  ```

🔗 [Details](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step10.md#L3)

</details>

<details>
<summary><strong>🚀 Step 11: Kubernetes Deployment</strong></summary>

- Pulled Docker image using Kubernetes secrets.  
- Deployed it to EKS cluster using **Deployment** and **Service** resources.  
- Exposed via LoadBalancer.  
🔗 [Details](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step11.md#L1)

</details>

<details>
<summary><strong>📊 Step 12: Monitoring (Prometheus & Grafana)</strong></summary>

- Added Prometheus Helm repo.  
- Enabled monitoring in EKS cluster.  
- Changed Prometheus and Grafana services to `LoadBalancer` for browser access.  
🔗 [Details](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step12.md#L1)

</details>

---

## 👨‍💻 Author & Community

This project is maintained by **[Harshhaa](https://github.com/NotHarshhaa)** 🚀

### 💬 Connect with Me:

- 🐙 **GitHub**: [@NotHarshhaa](https://github.com/NotHarshhaa)  
- 📝 **Blog**: [ProDevOpsGuy](https://blog.prodevopsguy.xyz)  
- 💬 **Telegram**: [Join Community](https://t.me/prodevopsguy)  
- 👔 **LinkedIn**: [Harshhaa Vardhan Reddy](https://www.linkedin.com/in/harshhaa-vardhan-reddy/)

---

## ⭐ Support the Project

If you found this helpful:

- ⭐ Star this repo  
- 🔁 Share it with your peers  
- ✅ Follow for more DevOps content  

---

## 📢 Stay Updated

![Follow Me](https://imgur.com/2j7GSPs.png)
