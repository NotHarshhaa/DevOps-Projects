# DevSecOps: OpenAI Chatbot UI Deployment in EKS with Jenkins and Terraform

![text](https://imgur.com/MdxoqmL.png)

## **Introduction:**

In today’s digital world, user engagement is key to the success of any application. Implementing DevSecOps practices is essential for ensuring security, reliability, and efficient deployment processes. In this project, we aim to implement DevSecOps for deploying an OpenAI Chatbot UI. We will use Kubernetes (EKS) for container orchestration, Jenkins for Continuous Integration/Continuous Deployment (CI/CD), and Docker for containerization.

**What is ChatBOT?**

ChatBOT is an AI-powered conversational agent trained on extensive human conversation data. It utilizes natural language processing techniques to understand user queries and provide human-like responses. By simulating natural language interactions, ChatBOT enhances user engagement and provides personalized assistance to users.

**Why ChatBOT?**

**1\. Personalized Interactions:** ChatBOT enables personalized interactions by understanding user queries and responding in a conversational manner, fostering engagement and satisfaction.  
  
**2\. 24/7 Availability:** Unlike human agents, ChatBOT is available 24/7, ensuring instant responses to user queries and delivering a seamless user experience round the clock.  
  
**3\. Scalability:** With ChatBOT deployed in our application, we can efficiently handle a large volume of user interactions, ensuring scalability as our user base expands.

**How We’re Deploying ChatBOT?**

**1\. Containerization with Docker:** We’re containerizing the ChatBOT application using Docker, which provides lightweight, portable, and isolated environments for running applications. Docker enables consistent deployment across different environments, simplifying the deployment process and ensuring consistency.

**2\. Orchestration with Kubernetes (EKS):** Kubernetes provides powerful orchestration capabilities for managing containerized applications at scale. We’re leveraging Amazon Elastic Kubernetes Service (EKS) to deploy and manage our Docker containers efficiently. EKS automates container deployment, scaling, and management, ensuring high availability and resilience.

**3\. CI/CD with Jenkins:** Jenkins serves as our CI/CD tool for automating the deployment pipeline. We’ve configured Jenkins to continuously integrate code changes, run automated tests, and deploy the ChatBOT application to EKS. By automating the deployment process, Jenkins accelerates the delivery of updates and enhancements, improving efficiency and reliability.

**4\. DevSecOps Practices:** Throughout the deployment pipeline, we’re integrating security practices into every stage to ensure the security of our ChatBOT application. This includes vulnerability scanning, code analysis, and security testing to identify and mitigate potential security threats early in the development lifecycle.

By implementing DevSecOps practices and leveraging modern technologies like Kubernetes, Docker, and Jenkins, we’re ensuring the secure, scalable, and efficient deployment of ChatBOT, enhancing user engagement and satisfaction.

# **STEPS:**

**Step:1 :- Create Jenkins Server.**

1. Clone the GitHub repository.

**GITHUB REPO**: [Chatbot-UI](https://github.com/NotHarshhaa/DevOps-Projects/tree/master/DevOps-Project-28/Chatbot-UI)

```
git clone https://github.com/NotHarshhaa/DevOps-Projects/DevOps-Project-28/Chatbot-UI
cd Jenkins-Server-TF
```

2\. Before proceeding to next steps. Do the following things.

i. Create a DynamoDB table named “Lock-Files”.  
ii. Create a Key-Pair and download the PEM file.  
iii. Create a user and save the access keys.  
iv. Create an S3 bucket.  
v. Download Terraform and AWS CLI.

```go
#Terraform Installation Script
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg - dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform -y

#AWSCLI Installation Script
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install
```

3\. Do some modifications to the backend.tf file such as changing the **bucket** name and **DynamoDB** table.

![](<https://miro.medium.com/v2/resize:fit:700/1*ts7vnOdjjkq38TSgWD0hCA.png>)

4\. **Configure AWS CLI:** Run the below command, and add your access keys.

```go
aws configure
```

5\. You have to replace the Pem File name with one that is already created on AWS.

6\. Initialize the backend by running the below command.

```go
terraform init
```

![](<https://miro.medium.com/v2/resize:fit:700/1*lrsh4lLt0pkl_FUqNEmtkQ.png>)

7\. Run the below command to get the blueprint of what kind of AWS services will be created.

```go
terraform plan -var-file=variables.tfvars
```

![](<https://miro.medium.com/v2/resize:fit:700/1*cWnWUtSM-7Ghf3up4_aVBQ.png>)

8\. Now, run the below command to create the infrastructure on AWS Cloud which will take 3 to 4 minutes maximum.

```go
terraform apply -var-file=variables.tfvars --auto-approve
```

![](<https://miro.medium.com/v2/resize:fit:700/1*_dJYuqhrheOXp1kYlX_oyg.png>)

9\. Upon success,this will create an ec2 server with name “Jenkins-server”.

![](<https://miro.medium.com/v2/resize:fit:700/1*o1ukLPW6LDdyINIjmiZ_Qg.png>)

10\. Connect to it with SSH.

![](<https://miro.medium.com/v2/resize:fit:700/1*wqenS9FQrkMp4rwQeIbCoQ.png>)

**Step:2 :- Configure Jenkins server.**

1. Access jenkins on port 8080 of ec2 public ip.

![](<https://miro.medium.com/v2/resize:fit:700/1*qkSouA0m8wPssyvu96rSyQ.png>)

2\. Now, run the below command to get the administrator password and paste it on your Jenkins.

```go
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

![](<https://miro.medium.com/v2/resize:fit:700/1*CcsGMffUT3qSMwCeia6QTQ.png>)

\\

3\. Install suggested plugins.

![](<https://miro.medium.com/v2/resize:fit:700/1*pG1vN9uSjicpWNCNp_mSlA.png>)

4\. Create user help us customize username and password of Jenkins.

![](<https://miro.medium.com/v2/resize:fit:700/1*sVt0BvCQ4P8M7AbwF03lfw.png>)

5\. Save and Continue all the rest.

![](<https://miro.medium.com/v2/resize:fit:700/1*LUVR7nRSBFItWW0InF-WJw.png>)

6\. Access SonarQube on port 9000 of Same Jenkins server.

```go
Username: admin
Password: admin
```

![](<https://miro.medium.com/v2/resize:fit:700/1*PKeiUg_xlPjXzh7TvVLXxw.png>)

7\. Customize the password.

![](<https://miro.medium.com/v2/resize:fit:700/1*s98Lzd9k9Jrt4LX_watlEg.png>)

8\. Navigate to Security → Users →Administrator.

![](<https://miro.medium.com/v2/resize:fit:700/1*kEMioYIWvnwnU0IYQLne1w.png>)

9\. Click on Tokens.

![](<https://miro.medium.com/v2/resize:fit:700/1*4EqtasaEgqAR5AsPCQfZng.png>)

10\. Create one and save it.

![](<https://miro.medium.com/v2/resize:fit:700/1*pGMqIxnXNX0K8A4BXqBhQQ.png>)

11\. Now go to Configuration → Webhooks →Create

![](<https://miro.medium.com/v2/resize:fit:700/1*MdKRzDovGiD7l62vArpN-A.png>)

12\. Then configure webhook and create.

```go
Name: Jenkins
URL : http://<public_ip>:8080/sonarqube-webhook/
```

![](<https://miro.medium.com/v2/resize:fit:700/1*5C6ISpNvZlo5UtIV-wqnsg.png>)

13\. Now in Jenkins Navigate to Manage Jenkins → Plugins →Available Plugins and install the following.

```go
1 → Eclipse Temurin Installer

2 → SonarQube Scanner

3 → NodeJs Plugin

4 → Docker

5 → Docker commons

6 → Docker pipeline

7 → Docker API

8 → Docker Build step

9 → Owasp Dependency Check

10 → Kubernetes

11 → Kubernetes CLI

12 → Kubernetes Client API

13 → Kubernetes Pipeline DevOps steps

10 → AWS Credentials

11 → Pipeline: AWS Steps
```

![](<https://miro.medium.com/v2/resize:fit:700/1*Xy-5yDv5sAAGIycYrmr5BQ.png>)

14\. Restart Jenkins after they got installed.

![](<https://miro.medium.com/v2/resize:fit:700/1*0t36RmSpki52UW8RdcVuCw.png>)

14\. Go to Manage Jenkins → Tools → Install JDK(17) and NodeJs(19)→ Click on Apply and Save.

![](<https://miro.medium.com/v2/resize:fit:700/1*3FEhZq1MdvM8-xOcdylqRA.png>)

![](<https://miro.medium.com/v2/resize:fit:700/1*A9W8okCbkWK8AOpLGkeMhQ.png>)

15\. Similarly install DP-check, Sonar-Scanner and Docker.

![](<https://miro.medium.com/v2/resize:fit:700/1*QuwYxeBhrqD3ARH0AXuG2A.png>)

![](<https://miro.medium.com/v2/resize:fit:700/1*EQQ8MTGZB4bjJ5LRvKVNkg.png>)

![](<https://miro.medium.com/v2/resize:fit:700/1*AYs2P3fDcpB5jD0F--ElbQ.png>)

16\. Go to Jenkins Dashboard → Manage Jenkins → Credentials. Add

Sonar-token as secret text.

![](<https://miro.medium.com/v2/resize:fit:700/1*acrmIpPIfkFRmXvbGPTTWg.png>)

Docker credentials.

![](<https://miro.medium.com/v2/resize:fit:700/1*wjeiXyzlQwDiq_w4_E3egA.png>)

GitHub Credentials.

![](<https://miro.medium.com/v2/resize:fit:700/1*NP7s2NxZs7lJ5MJ1AaZvvg.png>)

AWS access keys as AWS Credentials.

![](<https://miro.medium.com/v2/resize:fit:700/1*Py7A-_2MTbneLbV87qBfMw.png>)

17\. Manage Jenkins → Tools → SonarQube Scanner. Then add sonar-server and created sonar-token.

![](<https://miro.medium.com/v2/resize:fit:700/1*sER7niC7VvX0noF14i-5bQ.png>)

**Step :3 :- Create Jenkins Pipeline**

1. Up to this Let’s create a pipeline and see if anything gone wrong.  
    Click on “New Item” and give it a name selecting pipeline and then ok.

![](<https://miro.medium.com/v2/resize:fit:700/1*evthWnSh1otwLpbbivjWrw.png>)

2\. Under Pipeline section Provide

```go
Definition: Pipeline script from SCM
SCM : Git
Repo URL : Your Github Repo 
Credentials: Created GitHub Credentials
Branch: Main
Path: Your Jenkinsfile path in GitHub repo.
```

![](<https://miro.medium.com/v2/resize:fit:700/1*DFOwUj5EVLcuIUJMTsQuXg.png>)

![](<https://miro.medium.com/v2/resize:fit:700/1*TUEe9kTVR_-t5hELdddqBw.png>)

3\. Click on “Build”.

Upon successful execution you can see all stages as green.

![](<https://miro.medium.com/v2/resize:fit:700/1*vH3ZQzBTQfazn8rZpPHpxA.png>)

Sonar- Console.

![](<https://miro.medium.com/v2/resize:fit:700/1*sdJWXmeiDNKDPHGGA9rnYw.png>)

Dependency Check:

![](<https://miro.medium.com/v2/resize:fit:700/1*ltv8VPhnjt0yqL49WQGlyw.png>)

Trivy File scan:

![](<https://miro.medium.com/v2/resize:fit:700/1*VDbEBem5q-uo3rEESK3Oag.png>)

Trivy Image Scan:

![](<https://miro.medium.com/v2/resize:fit:700/1*Gz1tl6dkGuBOHiiODEDkwQ.png>)

Docker Hub:

![](<https://miro.medium.com/v2/resize:fit:700/1*FCDMfy25WENB4TDtno4Few.png>)

4\. Now access the application on port 3000 of Jenkins public ip.  
Note: Make sure you allowed port 3000 in Security Group of Jenkins Server.

![](<https://miro.medium.com/v2/resize:fit:700/1*vOZ6J7bD2nrk77wEj-6ZdA.png>)

5\. Click on openai.com(Blue in color)  
This will take you ChatGPT login page enter email and password.  
In API Keys Create Click on new secret key.

![](<https://miro.medium.com/v2/resize:fit:700/1*GVGNqaya_gSLWjeXBME0PA.png>)

Give a name and copy it.

![](<https://miro.medium.com/v2/resize:fit:700/1*JijsJ3OssDvGLhx7SfCl8A.png>)

6\. Come back to chatbot UI that we deployed and bottom of the page you will see OpenAI API key and give the Generated key and click on save (RIGHT MARK).

![](<https://miro.medium.com/v2/resize:fit:700/1*fq6FvOdFAyT10GkVy4DQ3g.png>)

UI look like:

![](<https://miro.medium.com/v2/resize:fit:700/1*aYBM20K6ZZ-S_02PUJc9AQ.png>)

7\. Now, You can ask questions and test it.

![](<https://miro.medium.com/v2/resize:fit:700/1*hcEqdo3AepDla-FjqqhVdA.png>)

**Step:4 :- Create EKS Cluster withy Jenkins**

1. Click on New item give it a name by choosing pipeline and then click “OK”.

![](<https://miro.medium.com/v2/resize:fit:700/1*-G8x16L7cQj4740teS6EUg.png>)

2\. Under Pipeline section provide:

```go
Definition: Pipeline script from SCM
SCM : Git
Repo URL : Your Github Repo 
Credentials: Created GitHub Credentials
Branch: Main
Path: Your EKS Cluster Jenkinsfile path in GitHub repo.
```

![](<https://miro.medium.com/v2/resize:fit:700/1*3SM0S-Ebf7lpy00u_86g-g.png>)

![](<https://miro.medium.com/v2/resize:fit:700/1*fO76KNV2HXlNgrPmX1vpxw.png>)

3\. Click on Build and on successful execution Your Jenkins UI resembles:

![](<https://miro.medium.com/v2/resize:fit:700/1*cQkkAfWwdkDIS0xYM7kbSA.png>)

This will create a cluster in AWS:

![](<https://miro.medium.com/v2/resize:fit:700/1*hOGblsNjL6HibXbw85nZxQ.png>)

4\. Now In the Jenkins server. Give this command to add context.

```go
aws eks update-kubeconfig --name <clustername> --region <region>
```

5\. It will Generate an Kubernetes configuration file.  
Navigate to the path of config file and copy it.

```go
cd .kube
cat config
```

6\. Save it in your local file explorer, at your desired location with any name as text file.

![](<https://miro.medium.com/v2/resize:fit:700/1*zWuxjE3LwckDSKK4KWgd1g.png>)

7\. Now in Jenkins Console add this file in Credentials section with id k8s as secret file.

![](<https://miro.medium.com/v2/resize:fit:700/1*AwQoO3iLCrKUM1pJrmsT4Q.png>)

**Step:5 :- Deployment on EKS**

1\. Now add this deployment stage in Jenkins file.

```go
stage('Deploy to kubernetes'){
            steps{
                withAWS(credentials: 'aws-key', region: 'us-east-1'){
                script{
                    withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                       sh 'kubectl apply -f k8s/chatbot-ui.yaml'
                  }
                }
            }
        }
     }
```

2\. Now rerun the Jenkins Pipeline again.

Upon Success:

![](<https://miro.medium.com/v2/resize:fit:700/1*BKc-909uo_EhK2W5VZ5nvQ.png>)

This create all the resources in the Cluster:

```go
kubectl get all
```

![](<https://miro.medium.com/v2/resize:fit:700/1*AyoKZWjLQjATodohBQX5jQ.png>)

This will create an Classic Load Balancer on AWS Console:

![](<https://miro.medium.com/v2/resize:fit:700/1*wa576USefwHkdXn2puGj_g.png>)

Copy the DNS Name and Paste it on your browser and use it:

Note: Do the same process and add key to get output.

![](<https://miro.medium.com/v2/resize:fit:700/1*d-T18E5kXaHXpFPpPiWYTQ.png>)

![](<https://miro.medium.com/v2/resize:fit:700/1*Ob-LMOzWFB7vCo6zYebAWA.png>)

The Complete Jenkins file:

```go
pipeline{
    agent any
    tools{
        jdk 'jdk17'
        nodejs 'node19'
    }
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages {
        stage('Checkout from Git'){
            steps{
                git branch: 'master', url: 'https://github.com/NotHarshhaa/DevOps-Project-28/Chatbot-UI.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Chatbot \
                    -Dsonar.projectKey=Chatbot '''
                }
            }
        }
        stage("quality gate"){
           steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token' 
                }
            } 
        }
        stage('OWASP FS SCAN') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.json"
            }
        }
        stage("Docker Build & Push"){
            steps{
                script{
                   withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){   
                       sh "docker build -t chatbot ."
                       sh "docker tag chatbot ProDevOpsGuyTech/chatbot:latest "
                       sh "docker push ProDevOpsGuyTech/chatbot:latest "
                    }
                }
            }
        }
        stage("TRIVY"){
            steps{
                sh "trivy image ProDevOpsGuyTech/chatbot:latest > trivy.json" 
            }
        }
        stage ("Remove container") {
            steps{
                sh "docker stop chatbot | true"
                sh "docker rm chatbot | true"
             }
        }
        stage('Deploy to container'){
            steps{
                sh 'docker run -d --name chatbot -p 3000:3000 sreedhar8897/chatbot:latest'
            }
        }
        stage('Deploy to kubernetes'){
            steps{
                withAWS(credentials: 'aws-key', region: 'us-east-1'){
                script{
                    withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                       sh 'kubectl apply -f k8s/chatbot-ui.yaml'
                  }
                }
            }
        }
      }
   }
}
```

**Step: 6 :- Clean Up**

1. This is so simple Firstly Delete the EKS Cluster By selecting destroy as the build option.

![](<https://miro.medium.com/v2/resize:fit:700/1*w526We1gSfFKIaIup7AgoQ.png>)

2\. Then destroy Jenkins server by running this on Local:

```go
terraform destroy -auto-approve -var-file=variables.tfvars
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
