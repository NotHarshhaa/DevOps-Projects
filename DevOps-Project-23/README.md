# DevSecOps: Blue-Green Deployment of Swiggy-Clone on AWS ECS with AWS Code Pipeline

![](https://miro.medium.com/v2/resize:fit:802/1*sHlD2d3AfaxzYEDlegzHhg.png)

# **Introduction:**

In the realm of modern software development, DevSecOps practices are gaining prominence for their emphasis on integrating security seamlessly into the software development lifecycle. One critical aspect of this approach is implementing efficient deployment strategies that not only ensure reliability but also maintain security standards. In this blog post, we will delve into the concept of Blue-Green deployment and demonstrate how to apply it to a Swiggy-clone application hosted on AWS ECS (Elastic Container Service) using AWS Code Pipeline.

**What is Blue-Green Deployment?**  
Blue-Green deployment is a technique used to minimize downtime and risk during the release of new versions of an application. In this approach, two identical production environments, termed ‘Blue’ and ‘Green’, are maintained. At any given time, only one environment (e.g., Blue) serves live traffic while the other (e.g., Green) remains idle. When a new version is to be deployed, the new version is deployed to the idle environment (Green). Once the deployment is validated, traffic is seamlessly switched to the updated environment (Green), allowing for quick rollback to the previous version if issues arise.

**Setting up AWS ECS for Swiggy-Clone:**  
To demonstrate Blue-Green deployment, we’ll use AWS ECS to host our Swiggy-clone application. ECS is a highly scalable container orchestration service provided by AWS.

Implementing Blue-Green Deployment with AWS CodePipeline:  
AWS CodePipeline is a fully managed continuous integration and continuous delivery (CI/CD) service that automates the build, test, and deployment phases of your release process. **Let’s see how to set up a Blue-Green deployment pipeline using AWS CodePipeline:**

**1\. Source Stage:** Connect your CodePipeline to your source code repository (e.g., GitHub). Trigger the pipeline when changes are detected in the repository.

**2\. Build Stage:** Use AWS CodeBuild to build your Swiggy-clone Docker image from the source code. Run any necessary tests during this stage.

**3\. Deploy Stage:** Configure AWS CodeDeploy for ECS to manage the deployment of your application to ECS clusters. Here’s where Blue-Green deployment strategy comes into play:  

- A. Define two ECS services: Blue and Green.  
- B. Use CodeDeploy to deploy the new version of your Swiggy-clone application to the Green service.  
- C. After deployment, automate the ALB routing to gradually shift traffic from the Blue service to the Green service based on predefined health checks.  
- D. Monitor the deployment process and rollback automatically if issues occur during the transition.

## GitHub Source Code Repo: [HERE](https://github.com/NotHarshhaa/DevOps-Projects/tree/master/DevOps-Project-23/Swiggy_clone)

# **Step:-1 : Create a Sonar Server**

1. To run Static Code Analysis we need a sonar server.

2. Create a key-pair for this purpose.  
    i. Navigate to key-pairs in AWS Console and click on “Create key- pair”.

![](https://miro.medium.com/v2/resize:fit:802/1*0wK1e8bOHEJlFiwztNGciA.png)

ii. Provide a name and select key-pair rype as .pem then click on create.  
The .pem file will be downloaded to your local.

![](https://miro.medium.com/v2/resize:fit:802/1*RETZJ22lP-5L26Un9MxysA.png)

3\. Navigate to EC2 console and click on “Launch Instance”.

![](https://miro.medium.com/v2/resize:fit:802/1*mzG2HspPsn-sPLpFcwi52A.png)

4\. Give a name for it.

![](https://miro.medium.com/v2/resize:fit:802/1*i-3qfzDM0ertdiSji3K8lw.png)

5\. Select AMI as “Ubuntu” and instance type as “t2.medium”.

![](https://miro.medium.com/v2/resize:fit:802/1*DkV0Lqe2WGSYjC1KSDf31g.png)

6\. Under key-pair select the created one.

![](https://miro.medium.com/v2/resize:fit:802/1*LMS5n7J2Z1Rh6dXuh0pt8Q.png)

7\. Click on “Launch Instance” by leaving other things as default.

![](https://miro.medium.com/v2/resize:fit:802/1*I8hsTduz9elVF0tPtOzLgQ.png)

8.Once the instance is up and running select it and click on “connect”.  
You can use EC2 instance connect or SSH with the pem file you downloaded.

![](https://miro.medium.com/v2/resize:fit:802/1*Hy6OmfFPTZ5Ajl_mSdVqng.png)

9\. Install docker.

```go
# Installing Docker 
sudo apt update
sudo apt install docker.io -y
sudo usermod -aG docker ubuntu
sudo systemctl restart docker
sudo chmod 777 /var/run/docker.sock
```

![](https://miro.medium.com/v2/resize:fit:802/1*gptHLF_z4uBT6NEu26-Jtw.png)

10\. Run sonarqube as a docker container.

```go
# Run Docker Container of Sonarqube
#!/bin/bash
docker run -d  --name sonar -p 9000:9000 sonarqube:lts-community
```

![](https://miro.medium.com/v2/resize:fit:802/1*tciW44uP3T7YW9dFVBQj-w.png)

11\. Ensure that port 9000 is opened in security group of that particular instance.

![](https://miro.medium.com/v2/resize:fit:802/1*aQkJ_5xLF8fs_x9yQJAusw.png)

12\. Access SonarQube on &lt;public\_ip&gt;:9000  
Username & Password: admin

![](https://miro.medium.com/v2/resize:fit:802/1*ntn6wzIBgIXWGCP6tPaOFw.png)

# **Step:2 :- SonarQube Set-Up.**

1. After getting log-in create a custom password.

![](https://miro.medium.com/v2/resize:fit:802/1*LzS_Zd-OCV9MoisUPPu6og.png)

2\. Click on “manually” (&lt;&gt;).

![](https://miro.medium.com/v2/resize:fit:802/1*FpW07qDsNtUYmuhosE_XSg.png)

3\. Click on “locally”.

![](https://miro.medium.com/v2/resize:fit:802/1*L77J4D1uh4gV0BIGBSgYIw.png)

4\. Provide a name for it.

![](https://miro.medium.com/v2/resize:fit:802/1*p5VtA-6SOBWCufqhC87d4Q.png)

5\. Click on “Set Up” .

![](https://miro.medium.com/v2/resize:fit:802/1*xYH83OV6LwW6fuxH7EJQrw.png)

6\. Click on “Generate” and create one.

![](https://miro.medium.com/v2/resize:fit:802/1*NgaUO2Uz7BR0W5acEayeQQ.png)

7\. Then Under code select other and os as linux. Then Copy sonar token.

![](https://miro.medium.com/v2/resize:fit:802/1*92AU-98SH-A1JkIAF1d8yg.png)

8\. In the AWS console search for “Systems Manager” and then “Parameter Store”.

![](https://miro.medium.com/v2/resize:fit:802/1*S_dAKo2-ufnAqjsbQ7M47A.png)

9\. Click on “create parameter”.

![](https://miro.medium.com/v2/resize:fit:802/1*2keJd7_IOGBQyklelEcqLQ.png)

9\. Give a name for it.  
Note: This must be edited in buildspec.yaml file.

![](https://miro.medium.com/v2/resize:fit:802/1*tlLnmKodyEccaJJQ_ccinw.png)

10\. Provide the copied token in the value section.

![](https://miro.medium.com/v2/resize:fit:802/1*EAiBMC6UuzD5eMJs5X4pRg.png)

11\. Similarly create parameters for Docker Username, Password and URI.

```go
#In my case 
Parameter name: /cicd/sonar/sonar-token             Value: <sonar_token>
Parameter name: /cicd/docker-credentials/username   Value: <docker_username>
Parameter name: /cicd/docker-credentials/password   Value: <docker_password>
Parameter name: /cicd/docker-registry/url           Value: docker.io
```

Note: You need to give your Sonar URL and Project Key in buildspec.yaml

# **Step:-3 : Create AWS Code Build Project**

1. Navigate to AWS Codebuild console and click on “create project”.

![](https://miro.medium.com/v2/resize:fit:802/1*TCikGTyQvlmoVRcQx3bRVA.png)

2\. Provide a name for it.

![](https://miro.medium.com/v2/resize:fit:802/1*BnoI64cb7mq2r6tkz8DflQ.png)

3\. Under source select github as a source provider.

![](https://miro.medium.com/v2/resize:fit:802/1*hNYAdmXEyoKRP4mNc4rdxA.png)

4\. Select Connect using OAuth.

![](https://miro.medium.com/v2/resize:fit:802/1*7jE34ni2txVR57O5iXeHNA.png)

5\. After this it will ask for permissions and github login do all the stuff.

![](https://miro.medium.com/v2/resize:fit:802/1*XkzI05gdFo9XT8a8mOjMGg.png)

6\. Under GitHub repo, select the one your application code relies.

![](https://miro.medium.com/v2/resize:fit:802/1*7I9PqgAKn8f9QaMAX_nWPg.png)

7\. Under Environment leave all of them as default.

![](https://miro.medium.com/v2/resize:fit:802/1*Jlna_WCd_fh4dCeXtYkwFQ.png)

8\. Under Buildspec select “Use a buildspec file” and provide the name as “buildspec.yaml”.

![](https://miro.medium.com/v2/resize:fit:802/1*g3H9AXupRVThK1trc1PXNw.png)

9\. Under Artifacts Use an already created s3 bucket.

![](https://miro.medium.com/v2/resize:fit:802/1*HZyWuCgqQhUxmSUK07Vqig.png)

10\. Click on “Update project”.

![](https://miro.medium.com/v2/resize:fit:802/1*QS8wzEd_h_iFTBZvZK1LMw.png)

11\. In IAM click on the role that the codebuild created.

![](https://miro.medium.com/v2/resize:fit:802/1*7Y3gtynespW7W4JSLJ3GDQ.png)

12\. Give “AmazonSSMFullAccess” to access the parameters in Systems Manager and “AWSS3FullAccess” to upload the artifacts.

![](https://miro.medium.com/v2/resize:fit:802/1*3iQjsyTslPp2gpnwuNqRSQ.png)

13\. Click on “Start build”.  
Upon successful build it will look like:

![](https://miro.medium.com/v2/resize:fit:802/1*L5utCQecsFVB-4dJWH84eg.png)

SonarQube Analysis:

![](https://miro.medium.com/v2/resize:fit:802/1*7y-9yqT43IPgFaiZ0kXT9Q.png)

Dependency-Check reports:

![](https://miro.medium.com/v2/resize:fit:802/1*ObhhizJMM-i9jBpFR1zUHA.png)

Trivy File Scan:

![](https://miro.medium.com/v2/resize:fit:802/1*IHT0tPfD1xfr940DrvrqxQ.png)

Trivy Image Scan:

![](https://miro.medium.com/v2/resize:fit:802/1*ARlLeQeWccslE0I_DRn_Lg.png)

# **Step:4A :- ECS Cluster Creation**

1. Navigate to ECS and click on “Create cluster”.

![](https://miro.medium.com/v2/resize:fit:802/1*I3Jzh2DQpK2uHOXEh2JyBw.png)

2\. Provide a name for it.

![](https://miro.medium.com/v2/resize:fit:802/1*1PTm6bPb1ZdptpuGzM06jg.png)

2\. Under infrastructure select “Amazon EC2 instances”

![](https://miro.medium.com/v2/resize:fit:802/1*kt_Ll2_mkGhbfX2NMNrQQQ.png)

3\. Give OS as Amazon Linux 2 and instance type as “t2.medium”.

![](https://miro.medium.com/v2/resize:fit:802/1*tMm3ad3-V0_l1GL_14jodA.png)

4\. Give Desired Capacity min as 2 and max as 3.

![](https://miro.medium.com/v2/resize:fit:802/1*n2T-5UHOwF7bz8ikxNi2vw.png)

5\. Under Network settings Select the VPC and the subnets on which instances to be launched.

![](https://miro.medium.com/v2/resize:fit:802/1*tGCgFpxO4dHHOjfhK_InWg.png)

6\. Enable the container insights under monitoring and click “create” .

![](https://miro.medium.com/v2/resize:fit:802/1*MNXhf0FuUWmOcxV8ya-KgQ.png)

# **Step:4B :- ECS Task Definition Creation**

1. In the same ECS console click on “Task Definition” and then “create new task definition”

![](https://miro.medium.com/v2/resize:fit:802/1*_DAwaM6MGSw8nI4lWC6Mhw.png)

2\. Give a name for it and under “infra requirements” select “Amazon EC2 instances”.

![](https://miro.medium.com/v2/resize:fit:802/1*MYA3mtG46sUX5zqeBxZYlA.png)

3\. Give the configuration as below.

![](https://miro.medium.com/v2/resize:fit:802/1*BnsPIa1jtFShl2sjSLJo7Q.png)

4\. Under container provide Name, Image and container port .

![](https://miro.medium.com/v2/resize:fit:802/1*H8ncw2-QEIZoWclawPhqog.png)

5\. Under monitoring select as below and click “create”.

![](https://miro.medium.com/v2/resize:fit:802/1*_keGf2xjEHFAKjT15Rxfyw.png)

# **Step:4C :- Load Balancer Creation**

1. Navigate to EC2 and under Load Balancer click on “Create load balancer”.

![](https://miro.medium.com/v2/resize:fit:802/1*jtrI2SFTInCkh_CGOj11sA.png)

2\. Select “Application Load Balancer”.

![](https://miro.medium.com/v2/resize:fit:802/1*P8TpRwloMZQWSA7SG9JAdA.png)

2\. Provide a name for it.

![](https://miro.medium.com/v2/resize:fit:802/1*GgUYQKRRELtKn4atPL0ayw.png)

3\. Under Network mapping select the vpc sand subnets.

![](https://miro.medium.com/v2/resize:fit:802/1*Q4tFWuEUAyvXWXyPhz8eYA.png)

4\. Under Listeners and routing click on “Create target group”.

![](https://miro.medium.com/v2/resize:fit:802/1*gw-uf287FPgOoie18EXdfw.png)

5\. Give a target group name.

![](https://miro.medium.com/v2/resize:fit:802/1*Rlsws6HQ6atKoYilhziZ2A.png)

6\. Click on “Next”.

![](https://miro.medium.com/v2/resize:fit:802/1*fCLDK9ZLzn6nb1iapULgew.png)

7\. Select the ECS registered instances and give port for them.

![](https://miro.medium.com/v2/resize:fit:802/1*WsPf5LVhKXQRfpg1M9LZYA.png)

8\. Click on “Create target group”.

![](https://miro.medium.com/v2/resize:fit:802/1*-rreQ1ojPKb1LyGmyoR3YQ.png)

9\. In the Load balancer select the created one.

![](https://miro.medium.com/v2/resize:fit:802/1*TlMAxACt9kSvA393qbp9OQ.png)

10\. Click on “Create load balancer”.

![](https://miro.medium.com/v2/resize:fit:802/1*Bv4eAfRugCxiLcxiWfkNfQ.png)

11\. To access ECS Code Deploy needs a role so let’s create a one.  
Navigate to roles in IAM and click on “Create role”.

![](https://miro.medium.com/v2/resize:fit:802/1*jReVRPYrZJMvqbT9R8wgTg.png)

12\. Select Use case as “CodeDeploy-ECS”

![](https://miro.medium.com/v2/resize:fit:802/1*6IRX3oK8fmh3t4QTjnlqqw.png)

13\. Click on “Next”.

![](https://miro.medium.com/v2/resize:fit:802/1*Qw3Mf9Mb_KrZmLAn4OIoAg.png)

14\. Give a name for it.

![](https://miro.medium.com/v2/resize:fit:802/1*pCYLNvVgwKodaVuYM2c2hg.png)

15\. Click on Create.

![](https://miro.medium.com/v2/resize:fit:802/1*DIW5iJNEqCMmzA1qu7w_qA.png)

# **Step:4D :- ECS Service Creation**

1. Under Created ECS cluster and Service section click on “create”.

![](https://miro.medium.com/v2/resize:fit:802/1*McOKRq-zdebBRpSqGUciRQ.png)

2\. Opt Compute as “Launch type”.

![](https://miro.medium.com/v2/resize:fit:802/1*QQJ3ZFVr931988yro3SJLg.png)

3\. Under Deployment config select Family as the created task definition and give it a name.

![](https://miro.medium.com/v2/resize:fit:802/1*NJWlT_Lb_7r41GTDfoG93Q.png)

4\. Give desired tasks as 1 and Under Deployment options select Deployment type as “Blue/green deployment” then provide service role you created earlier.

![](https://miro.medium.com/v2/resize:fit:802/1*5AganRfr1kiTNRwt60aAyg.png)

5\. In the Load balancing section select type as ALB and opt the one you have created.

![](https://miro.medium.com/v2/resize:fit:802/1*8DGTlfVm2ZfUV8RyqLJ71A.png)

6\. Use existing Listener and Target group and TG-2 create a one.

![](https://miro.medium.com/v2/resize:fit:802/1*KRqhpTMvmwtJU6ev3Rhp1A.png)

![](https://miro.medium.com/v2/resize:fit:802/1*_cAYotXrv29JDN_yohJ3qQ.png)

7\. Click on “Create”

![](https://miro.medium.com/v2/resize:fit:802/1*QS6Dt0SI5ZFq_MGqk-Z-rA.png)

8\. Upon Successful service creation it looks like as:

![](https://miro.medium.com/v2/resize:fit:802/1*Wd8tFahwwYSITu0J0MuJ4A.png)

9\. Navigate to load balancer and copy the DNS name.  
Observe that the traffic to routing to target group TG-1.

![](https://miro.medium.com/v2/resize:fit:802/1*MBEJkKJ8o_oIjy5qfF0fXw.png)

10\. Paste it on your favorite browser.  
Observe that the tab name is “Swiggy Application”.

![](https://miro.medium.com/v2/resize:fit:802/1*l8hui1XLdhEvkukOQVsavQ.png)

11\. This will also create an application and deployment group under “code deploy” section.

![](https://miro.medium.com/v2/resize:fit:802/1*9ddlozxr_dVezz6mlj3yHw.png)

![](https://miro.medium.com/v2/resize:fit:802/1*sfMAF4hPa4ANcKTRXy7kIg.png)

12\. Create a file named “appspec.yaml” and past the below snippet replacing the task definition arn with yours.

```go
version: 0.0
Resources:
  - TargetService:
      Type: AWS::ECS::Service
      Properties:
        TaskDefinition: "arn:aws:ecs:ap-south-1:<account_id>:task-definition/swiggy:1"
        LoadBalancerInfo:
          ContainerName: "swiggy"
          ContainerPort: 3000
```

![](https://miro.medium.com/v2/resize:fit:802/1*fAAmD928t3-AJXFjDrADgg.png)

# **Step:5 :- AWS Code Pipeline Creation**

1. Navigate to Code Pipeline in AWS console and click on “create pipeline”.

![](https://miro.medium.com/v2/resize:fit:802/1*7tfko_PCqTiZodkViv082Q.png)

2\. Provide a name for it and click on “next”.

![](https://miro.medium.com/v2/resize:fit:802/1*-J9_-86kJ_GSjh2wW4G6HQ.png)

3\. In source stage give GitHub(Version 2) as Source.

![](https://miro.medium.com/v2/resize:fit:802/1*LDbYe5qyC0_FVeRnfhKK9w.png)

4\. For source code you need to provide access for github so click on “Connect to GitHub”.

![](https://miro.medium.com/v2/resize:fit:802/1*ggEZsskoeNNXe9aCVOMiKw.png)

5\. Provide a connection name.

![](https://miro.medium.com/v2/resize:fit:802/1*oNsb4LrBhbHNB8rJ49Sn1A.png)

6\. Click on “Install a new app”.

![](https://miro.medium.com/v2/resize:fit:802/1*4RWlRMDUAOzE33d38IMf4g.png)

7\. Login to GitHub using your credentials.

![](https://miro.medium.com/v2/resize:fit:802/1*BnDgQI-FdOqfCHXvAcd48g.png)

8\. Grant access for that particular repo and save it.

![](https://miro.medium.com/v2/resize:fit:802/1*DTaV7VnsXlz8Y1gdzd8D6A.png)

9\. Click on connect.

![](https://miro.medium.com/v2/resize:fit:802/1*RNiF_0OhhQOkzOzkybx92g.png)

10\. Select the repo and the branch. Under trigger type select “No filter”. Click “Next”.

![](https://miro.medium.com/v2/resize:fit:802/1*G_dJd0zpjkf22Ja-x9TFfw.png)

11\. Under Build stage add provider as “AWS Code Build”.

![](https://miro.medium.com/v2/resize:fit:802/1*Ex0hM9BMe-cDBvERFT7GNQ.png)

12\. Select Project as one created. Click on “next”.

![](https://miro.medium.com/v2/resize:fit:802/1*OxYrxOIqSmq4vuabNObhlw.png)

13\. Under the deploy stage add AWS CodeDeploy as deploy provider.

![](https://miro.medium.com/v2/resize:fit:802/1*FQ0SFtJ_qWFyugtFs0yzoA.png)

13\. Select the application name and deployment group created by the ECS service.

![](https://miro.medium.com/v2/resize:fit:802/1*ThzVRYHjbRLTMCl7IAD8SQ.png)

14\. Review and Click on “create”.

# **Step:6 :- ECS Deployment.**

1. Now make some changes to the application code.

2. I am doing a change in public/index.html by changing the title.

![](https://miro.medium.com/v2/resize:fit:802/1*wsPehtBu4QT4EqnacQSABQ.png)

3\. Change it as “Swiggy app” and commit to the GitHub.  
When the push happens code pipeline triggers automatically with webhook.

![](https://miro.medium.com/v2/resize:fit:802/1*ngpkjHB_CMx-MlodMU0GHg.png)

4\. Source and Build took usual time but code deploy took much.

5\. Navigate to that deployment.

![](https://miro.medium.com/v2/resize:fit:802/1*UsOW6tdguiPF_IPmkVeZ2w.png)

6\. If you want both blue and green versions to be running leave it else if you don’t want click on “Terminate original task set”. It tooks less time.

![](https://miro.medium.com/v2/resize:fit:802/1*_2viBEoGEoyQ8LhrQSFoVQ.png)

7\. Upon success code pipeline looks as :

![](https://miro.medium.com/v2/resize:fit:802/1*Iqj1Y6lE4h-vC6wEstrDIQ.png)

![](https://miro.medium.com/v2/resize:fit:802/1*M-suXmKdp1LoOpk2OeDVGA.png)

8\. Now navigate to load balancer section and click on the created one.

9\. Copy the DNS of that load balancer.

![](https://miro.medium.com/v2/resize:fit:802/1*9jwecsZr2gt_MkBVkuuE0w.png)

Observe that the traffic is routing to TG-2 (Green) instead of TG-1(Blue).

10\. Paste that in your favorite browser.

![](https://miro.medium.com/v2/resize:fit:802/1*ZBbtIUgMZ-wJVwtl4Ky4cQ.png)

![](https://miro.medium.com/v2/resize:fit:802/1*p6cH8ib_xAh5yX178-PWvg.png)

Observe that the title changed as expected.

# **Step:-7 : Clean Up**

1. Deleted created Code Pipeline.

2. Delete ECS Cluster.

3. Delete Created Code Build.

4. Delete Sonar-Server EC2 Instance.

## Hit the Star! ⭐

**If you are planning to use this repository for learning, please give it a star. Thanks!**

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
