# Real Time CI/CD Pipeline for Java Application to Deploy on Apache Server

![](https://miro.medium.com/v2/resize:fit:700/1*OgmkAQpgv2JPwHIQcVomWA.png)

## **Introduction:**

In today’s fast-paced software development environment, Continuous Integration and Continuous Deployment (CI/CD) pipelines have become essential tools for delivering high-quality software efficiently. In this blog post, we’ll explore how to set up a real-time CI/CD pipeline for a Java application, enabling seamless deployment onto an Apache server.

CI/CD pipelines automate the process of building, testing, and deploying code changes, enabling developers to release updates quickly and reliably. By integrating CI/CD into your development workflow, you can improve collaboration, increase code quality, and accelerate time-to-market.

For Java applications, setting up a CI/CD pipeline involves configuring tools and scripts to automatically build the application, run tests, and deploy the artifacts to a server environment. In this tutorial, we’ll leverage popular CI/CD tools such as Jenkins, Maven, and Apache Maven to create a robust pipeline for a Java application.

Our goal is to demonstrate a step-by-step approach to building and deploying a Java application using a CI/CD pipeline. We’ll cover key concepts such as version control integration, automated testing, artifact generation, and deployment automation. By the end of this tutorial, you’ll have a comprehensive understanding of how to implement a CI/CD pipeline for your Java projects, paving the way for efficient and reliable software delivery.

Let’s dive in and explore how to set up a real-time CI/CD pipeline for deploying Java applications on an Apache server.

**STEPS:**

### **Step 1: Configuring Jenkins Server with Terraform**

1. Intially clone the github repository.

```go
git clone https://github.com/NotHarshhaa/DevOps-Projects/tree/master/DevOps-Project-32/JavaApp-CICD.git
```

2\. Install & Configure Terraform and AWS CLI on your local machine to create Jenkins Server on AWS Cloud.\\

```go
# Install Terraform 

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg - dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform -y

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install
```

3\. Configure Terraform.  
i. Navigate to Jenkins-Server-TF  
ii. Create a S3 bucket and DynamoDB tables as name in [backend.tf](http://backend.tf)  
iii. Create a Key pair with name in variables.tfvars

4\. Configure aws cli  
i. Create a user in AWS IAM.  
ii. Provide those keys by running “aws configure”.

5\. After setting all run the following.

```go
 terraform plan --var-file=variables.tfvars
```

![](https://miro.medium.com/v2/resize:fit:700/1*0clTIhDEepW4Ptj_hptaKA.png)

```go
 terraform apply--var-file=variables.tfvars
```

![](https://miro.medium.com/v2/resize:fit:700/1*wqaBKHS3z-Q3iOzI7AQ-BA.png)

6\. If everything goes right this will create an instance in AWS console.

![](https://miro.medium.com/v2/resize:fit:700/1*jQNWWOonDksOKGpzV0Am9A.png)

7\. SSH into the instance using the created key pair.

8\. Now access the Jenkins server.

```go
#Paste this on your favorite browser
<ec2_instance_public_ip>
#To know the  admin password run this on the server
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

9\. Navigate to Manage Jenkins → Plugins → Available plugins  
Install the following:

```go
1 → Eclipse Temurin Installer (Install without restart)

2 → SonarQube Scanner (Install without restart)

3 → emailext

4 → Docker

5 → Docker commons

6 → Docker pipeline

7 → Docker API

8 → Docker Build step

9 → Owasp Dependency Check
```

10\. Navigate to manage jenkins →system → Email Notification  
i. Before this create an app password in your google account by enabling 2 step verification  
ii. Then configure and test it.

![](https://miro.medium.com/v2/resize:fit:700/1*IJP2d2ydVJ6fQwYyeNxfbQ.png)

![](https://miro.medium.com/v2/resize:fit:700/1*F6O7bZQ8DijkKfVErZrQgw.png)

This will send you a mail like this.

![](https://miro.medium.com/v2/resize:fit:700/1*CZuznvBXzRJcTR8OWMU_dA.png)

Now login to the sonarqube

```go
# Paste it on your browser
<ec2_instance_public_ip>:9000
# The username and password are admin by default
```

![](https://miro.medium.com/v2/resize:fit:700/1*UozV6evho7T9nBdMPCjldA.png)

![](https://miro.medium.com/v2/resize:fit:700/1*miM2ydZyFKvdezC8zQ0_vA.png)

The console look like:

![](https://miro.medium.com/v2/resize:fit:700/1*67wOeKGYBr6IUJwZxm94FA.png)

Create a token navigating to Administration →Users → Create token

![](https://miro.medium.com/v2/resize:fit:700/1*1JmWXjythUfnykKheP2cNA.png)

Copy that and navigate to manage jenkins → credentials →Global\\

Select Kind as “Secret text” and secret as the copied token

![](https://miro.medium.com/v2/resize:fit:700/1*2DWxJeHbkBdBRvY_zFUv0Q.png)

Similar to that add the docker credentials.

![](https://miro.medium.com/v2/resize:fit:700/1*zElRigoWmcCeC8a80lwkcA.png)

Navigate to system and provide that token and server url.

![](https://miro.medium.com/v2/resize:fit:700/1*Hr2jmiXt8rjg2OfPTQBhFw.png)

To install the tools navigate to Manage Jenkins → Tools

To install jdk

![](https://miro.medium.com/v2/resize:fit:700/1*Zihvg7T9eL6uSbnfTHC3UA.png)

To install sonar scanner

![](https://miro.medium.com/v2/resize:fit:700/1*sUcFbHWulxqoie0aVMWQAA.png)

To install dependency checker

![](https://miro.medium.com/v2/resize:fit:700/1*PmYe_wBL75lJW9HTk5N1BA.png)

To install docker

![](https://miro.medium.com/v2/resize:fit:700/1*nFWqRB5jc_jpyGxwDtRcYg.png)

To install maven

![](https://miro.medium.com/v2/resize:fit:700/1*KJvNB-rgPh3BaihghgEHlg.png)

Then add the github credentials by generating the classic token for password.

![](https://miro.medium.com/v2/resize:fit:700/1*6TcUIh12PFTT-R8NrToqHQ.png)

Create the webhook in the sonarqube.  
i. Navigate to Administration → configuration → create webhook

![](https://miro.medium.com/v2/resize:fit:700/1*9CdScWywESjaILl6E8hbsA.png)

### **Step 2: Install and Configure Tomcat Server:**

1. Download tomcat file using wget command

```go
sudo wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz
```

Unzip tar file

```go
sudo tar -xvf apache-tomcat-9.0.65.tar.gz
```

Update tomcat users xml file for manager app login.

```go
cd /opt/apache-tomcat-9.0.65/conf
sudo vi tomcat-users.xml
# ---add-below-line at the end (2nd-last line)----
<user username="admin" password="admin1234" roles="admin-gui, manager-gui"/>
```

![](https://miro.medium.com/v2/resize:fit:700/1*VqiWtTdkbw3DfWNFp1V3nw.png)

Create a symbolic links for direct start and stop of tomcat

```go
sudo ln -s /opt/apache-tomcat-9.0.65/bin/startup.sh /usr/bin/startTomcat
sudo ln -s /opt/apache-tomcat-9.0.65/bin/shutdown.sh /usr/bin/stopTomcat
```

Run these:

```go
sudo vi /opt/apache-tomcat-9.0.65/webapps/manager/META-INF/context.xml

#then comment:
<!-- Valve className="org.apache.catalina.valves.RemoteAddrValve"
  allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->

sudo vi /opt/apache-tomcat-9.0.65/webapps/host-manager/META-INF/context.xml

#then comment:
<!-- Valve className="org.apache.catalina.valves.RemoteAddrValve"
  allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->

#After them
sudo stopTomcat
sudo startTomcat
```

To allow both the `ubuntu` and `jenkins` users to copy the `petclinic.war`

```go
sudo visudo 

#Scroll down to an appropriate section (e.g., just below the line with %sudo ALL=(ALL:ALL) ALL) and add the following lines:
ubuntu ALL=(ALL) NOPASSWD: /bin/cp /var/lib/jenkins/workspace/petclinic/target/petclinic.war /opt/apache-tomcat-9.0.65/webapps/ 
jenkins ALL=(ALL) NOPASSWD: /bin/cp /var/lib/jenkins/workspace/petclinic/target/petclinic.war /opt/apache-tomcat-9.0.65/webapps/
```

![](https://miro.medium.com/v2/resize:fit:700/1*B4LuPkJegu62KtfgphRuDA.png)

Since Port 8080 is being used by Jenkins, we have used Port 8083 to host Tomcat Server

```go
#Change this by navigating to 
cd /opt/apache-tomcat-9.0.65/conf
sudo vi server.xml
# change the connector port to 8083 instead of 8080
```

![](https://miro.medium.com/v2/resize:fit:700/1*GD_0udCgDFGGWsuABdPLBQ.png)

Access the tomcat server on port 8083 of the same ip.

![](https://miro.medium.com/v2/resize:fit:700/1*63fVR1lH_Z2-myU8d5YqKA.png)

### **Step 3 : Create the Jenkins Pipeline**

1. Go to new item and the upon pipeline script section paste the content in the Jenkinsfile.

2. Click on build.

3. Upon successful it look like:

![](https://miro.medium.com/v2/resize:fit:700/1*O1TaS0gzO6ll331NXNy1yA.png)

Sonarqube console as:

![](https://miro.medium.com/v2/resize:fit:700/1*HnCmek55aBt1u-SaUKh9yw.png)

Dependency checker as:

![](https://miro.medium.com/v2/resize:fit:700/1*sUVjVDfLJDBwcMCn6GkSlQ.png)

The trivy image scan results as:

![](https://miro.medium.com/v2/resize:fit:700/1*9S5QYL2XymXh6MtDvmgtpg.png)

The image will be pushed to the dockerhub:

![](https://miro.medium.com/v2/resize:fit:700/1*Sh9bMmPCw0-MjXYpfJ2v1Q.png)

The application can be accessible in 2 ways:

i. Through Apache Server

![](https://miro.medium.com/v2/resize:fit:700/1*mAGa6z2QgxaKBWVQSlRPxA.png)

ii. Through the container deployed on the same instance.

![](https://miro.medium.com/v2/resize:fit:700/1*aiX08eVBIhXHFx-4s8r65A.png)

![](https://miro.medium.com/v2/resize:fit:700/1*m4QlHuuSb3rSQwgoTeqk9g.png)

![](https://miro.medium.com/v2/resize:fit:700/1*ftzbIzjJIC_nSsDjmzMf6A.png)

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
