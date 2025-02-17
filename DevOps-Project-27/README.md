# 🚀DevSecOps: Deploy Reddit App to Amazon Elastic Kubernetes Service (EKS) using ArgoCD and monitor its performance ✨

![](https://miro.medium.com/v2/resize:fit:4800/format:webp/1*vEZw9zoaHUGTVnu9OY84dg.png)

# 🚀 Introduction

In the fast-paced world of modern software development, the convergence of development, security, and operations, known as **DevSecOps**, has become essential for delivering secure and reliable applications at scale. As organizations strive to accelerate their release cycles while maintaining high standards of security and reliability, implementing robust DevSecOps practices becomes paramount.

In this blog post, we’ll embark on an exciting journey into the realm of DevSecOps, exploring how to deploy a popular application, **Reddit**, to **Amazon Elastic Kubernetes Service (EKS)** using **ArgoCD**, a GitOps continuous delivery tool, and how to monitor its performance for optimal results.

We’ll delve into each aspect of this process, from setting up the infrastructure on AWS EKS, orchestrating the deployment using ArgoCD, to implementing comprehensive monitoring solutions to ensure the health and performance of our Reddit application.

Join us as we unravel the intricacies of DevSecOps, combining the agility of modern development practices with the robustness of security and operational excellence. By the end of this journey, you’ll gain valuable insights into building resilient and secure cloud-native applications, empowering you to embrace DevSecOps principles in your own projects with confidence and success. Let’s dive in! 🌐🔐

---

## 🤝 Why ArgoCD and AWS EKS?

ArgoCD and Amazon Elastic Kubernetes Service (EKS) are two powerful tools that complement each other seamlessly, offering a comprehensive solution for deploying and managing applications in Kubernetes clusters. Let’s explore why ArgoCD and EKS make a compelling combination:

### 1. **GitOps Workflow**

ArgoCD follows the GitOps methodology, where the desired state of the Kubernetes cluster is defined declaratively in Git repositories. This approach brings numerous benefits, including version-controlled configurations, auditability, and the ability to easily roll back changes. By leveraging Git as the single source of truth, ArgoCD ensures consistency and reliability in application deployments.

### 2. **Declarative Configuration Management**

EKS provides a managed Kubernetes service, abstracting away the complexities of cluster provisioning and management. With EKS, you can focus on deploying and running containerized applications without worrying about the underlying infrastructure. ArgoCD complements EKS by providing declarative configuration management for Kubernetes resources, simplifying the deployment process, and promoting infrastructure-as-code practices.

### 3. **Continuous Deployment**

ArgoCD automates the deployment process, continuously monitoring the Git repositories for changes and reconciling the cluster state to match the desired state defined in the Git repository. This enables rapid and reliable application deployments, allowing teams to iterate and release new features with confidence.

### 4. **Integration with Kubernetes**

EKS seamlessly integrates with ArgoCD, providing a scalable and reliable platform for running Kubernetes workloads. ArgoCD utilizes Kubernetes-native resources such as Custom Resource Definitions (CRDs) and controllers to manage applications and synchronize their state with the cluster.

### 5. **Robust Monitoring and Observability**

Both ArgoCD and EKS offer robust monitoring and observability features. EKS integrates with popular monitoring solutions such as Prometheus and Grafana, allowing you to gain insights into cluster health, performance metrics, and application behavior. ArgoCD provides visibility into the deployment process, including synchronization status, application health, and audit logs, enabling teams to troubleshoot issues effectively.

---

## 🛠️ Steps to Implement

### **Step 1: Setup Jenkins Server**

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/uniquesreedhar/Reddit-Project.git
   cd Reddit-Project/Jenkins-Server-TF/
   ```

2. **Modify Backend.tf:**
   - Create an S3 bucket and a DynamoDB table.
  
3. **Install Terraform and AWS CLI:**

   ```bash
   # Install Terraform
   sudo apt install wget -y
   wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install terraform

   # Install AWS CLI 
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   sudo apt-get install unzip -y
   unzip awscliv2.zip
   sudo ./aws/install

   # Configure AWS CLI
   aws configure
   ```

   Provide your AWS Access Key ID, Secret Access Key, region name, and output format.

4. **Run Terraform Commands:**

   ```bash
   terraform init
   terraform validate
   terraform plan -var-file=variables.tfvars
   terraform apply -var-file=variables.tfvars --auto-approve
   ```

   - This will create an instance on AWS.

5. **Access Jenkins:**

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*eHkSo3ZcX5sgr5qG4XbyRw.png)

   - Copy the public IP of the instance and access Jenkins on your favorite browser:

     ```
     <public_ip>:8080
     ```
  
6. **Get Jenkins Password:**

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*wfz8_u1Wz8P1jxrmWo5HFg.png)

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*DTwHnnG6mU1Gp963QTgwiA.png)

   - Connect to the instance and retrieve the password.
  
7. **Create Jenkins User:**

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*dc-Uk2gjpl4u0AbnP473NA.png)

   - (Optional) Create a user if you don’t want to keep the default password.

8. **Install Required Plugins:**

   ![](https://miro.medium.com/v2/format:webp/1*BGE_C4xCqhHsfeG8qZoOVg.png)

   - Navigate to **Manage Jenkins → Plugins → Available Plugins** and install the following plugins without restarting:
     1. Eclipse Temurin Installer
     2. SonarQube Scanner
     3. NodeJs Plugin
     4. Docker Plugins (Docker, Docker commons, Docker pipeline, Docker API, Docker Build step)
     5. Owasp Dependency Check
     6. Terraform
     7. AWS Credentials
     8. Pipeline: AWS Steps
     9. Prometheus Metrics Plugin

9. **Access SonarQube Console:**

    ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*JPuXX4DXx7_qR5YAzVmY8g.png)

    ```
    <public_ip>:9000
    ```

    - Both Username and Password are "admin". Update the password and configure as needed.

10. **Create and Configure Credentials:**
    
    ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*ZA6hQO0d1PHQZNgFrbyEGg.png)

    ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*yCq1go61epUjOMIUamEjKg.png)

    ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*IIRUP1M-QAbQ6KQhRpiMrA.png)

    ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*j1-JvDzJ8X55crLNLqtevQ.png)

    - Navigate to **Manage Jenkins → Credentials → Global** and create credentials for AWS, GitHub, and Docker.

---

### **Step 2: Create EKS Cluster with Jenkins Pipeline**

1. **Create a New Jenkins Pipeline:**
   
   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*kyYceX4XO0fZ3CQawKTgnA.png)

   - Click on **New Item**, give a name, select **Pipeline**, and click **OK**.

2. **Configure Pipeline:**

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*iHoDWlt81vRk3DPRp-GTVw.png)

   - Navigate to the Pipeline section, provide the GitHub URL of your project, and specify the credentials and the path to the Jenkinsfile.

3. **Build the Pipeline:**

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*Q7GjCivSKGaBwKeKDpHPOg.png)

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*n-BIMoCrgRNbJ0r-JcnQaQ.png)

   - Click **Apply** and then **Build**. This will create an EKS cluster.

---

### **Step 3: Create Jenkins Job to Build and Push the Image**

1. **Create a New Jenkins Job:**

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*catvz_JkK2AgFHTxAJ6kuA.png)

   - Click on **New Item**, give a name, select **Pipeline**, and click **OK**.

2. **Configure Jenkins Job:**

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*FL8E-6tBUcSfC3T-7HKgDA.png)

   - In the pipeline section:
     - Choose **Script from SCM**.
     - Set up **Git** with your GitHub credentials.
     - Set the branch as `main` and the pipeline path as `Jenkins-Pipeline-Code/Jenkinsfile-Reddit`.

3. **Build the Pipeline:**

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*1g4YMnR0wunUa2wzbfKetA.png)

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*xhhUXkFyD1dbDpULMmIQyg.png)

   - Before building, create a GitHub token as secret text with the ID `githubcred` to update the built image in the deployment.yml file.

4. **Check Scanning Results:**

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*u-2lJcZvAVVF-iDSgDoHlw.png)

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*Qyjmz2jomCI6kmzoz-L7-w.png)

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*K50IVirdbReldv4u_1E55A.png)

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*T8BUpm7B-6moqGwswDJpVA.png)

   - View Trivy scan results, SonarQube analysis, and Dependency Checker outputs.
   
   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*shX8E0GqQQWMjDo5xADvXA.png)

5. **Update Deployment File:**
   - The deployment file will be updated with the tag of the Jenkins build number.

---

### **Step 4: Configure EKS and ArgoCD**

1. **Update EKS Cluster Config:**

   ```bash
   aws eks update-kubeconfig --name Reddit-EKS-Cluster
   ```

2. **Install ArgoCD:**

   ```bash
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.4.7/manifests/install.yaml
   ```

3. **Expose ArgoCD Server:**

   ```bash
   kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
   ```

4. **Retrieve ArgoCD Server Info:**

   ```bash
   export ARGOCD_SERVER=`kubectl get svc argocd-server -n argocd -o json | jq --raw-output '.status.loadBalancer.ingress[0].hostname'`
   export ARGO_PWD=`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
   ```

5. **Access ArgoCD Console:**

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*qH77YEPSTEnt6Jnx86lmzQ.png)

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*d1T6guyj7tTjNWLtZE7oDg.png)

   - Login using the DNS name and credentials.

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*XwciX8TFK4RiTyfFFfJNxA.png)

6. **Create ArgoCD Application:**
   - Click on **Create App**, edit the YAML, and replace `repoURL` with your GitHub project URL:

   ```yaml
   project: default
   source:
     repoURL: 'https://github.com/uniquesreedhar/Reddit-Project.git'
     path: K8s/
     targetRevision: HEAD
   destination:
     server: 'https://kubernetes.default.svc'
     namespace: default
   syncPolicy:
     automated:
       prune: true
       selfHeal: true
   ```

7. **Deploy and Sync:**

    ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*RWjBNQD23A2Mnimg0pB-zw.png)

    ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*2NZnMDr_7J0gXvmzxbqXog.png)

    - Deploy and sync your Reddit application with EKS.

---

## 🔍 Monitoring

### **Implement Prometheus and Grafana:**

1. **Deploy Prometheus and Grafana:**

   ```bash
   kubectl apply -f https://raw.githubusercontent.com/uniquesreedhar/Reddit-Project/main/Prometheus/
   ```

2. **Expose Prometheus and Grafana:**

   ```bash
   kubectl expose pod <prometheus-pod> --port=8080 --target-port=9090 --name=prometheus-lb --type=LoadBalancer
   kubectl expose pod <grafana-pod> --port=8081 --target-port=3000 --name=grafana-lb --type=LoadBalancer
   ```

3. **Access Grafana:**

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*qDLFfmYrXd5Qlm1JpwJsvA.png)

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*0rEaeCv0BIppt4rdimmRdg.png)

   - Copy the public IP and access it through `<public_ip>:8081`.

4. **Login to Grafana:**

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*CT-bSQ_aSYIVQL6XnH5xPQ.png)

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*qBkeca25xx_LW9ZvFoaIXw.png)

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*PR7S_0not9VTPcsmKD0zQw.png)

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*NBf-Ue92V0Ur1JMtbYuyPw.png)

   - Default credentials: `admin/admin`.

5. **Add Prometheus Data Source in Grafana:**

   - Navigate to **Add Data Source → Prometheus**.
   - Set up and start monitoring.

---

## 📈 Analyzing and Interpreting Metrics

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*wGf0Hrp5qBsfErwJruOfuw.png)

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*hFbOPfxmW0HCVnI8qXpHug.png)

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*9nhFyD5K4xMNuz5zhK9vvg.png)

   ![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*0TQyPda68KP79Jaw0YogfQ.png)

After setting up monitoring, you'll have access to detailed metrics from Prometheus, displayed on Grafana dashboards. These metrics help in identifying bottlenecks, understanding application behavior under load, and ensuring that everything runs smoothly. This proactive approach helps in maintaining high availability and performance, ensuring your application is always up and running.

---

## 🔄 Conclusion

By integrating Jenkins, ArgoCD, AWS EKS, and monitoring tools like Prometheus and Grafana, you create a robust pipeline that automates the deployment, security scanning, and monitoring of your applications. This setup is ideal for embracing DevSecOps practices, allowing your teams to focus on delivering value while ensuring security and reliability.

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
