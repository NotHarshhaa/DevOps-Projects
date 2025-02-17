# AWS DevOps CICD Pipeline

In This Project, we are Developing and Deploying a video streaming application on EC2 using Docker and AWS Developers Tools.

* `CodeCommit`: For Source Code Management

* `CodeBuild`: For building and testing our code in a serverless fashion

* `CodeDeploy`: To deploy our code

* `CodePipeline`: To streamline the CI/CD pipeline

* `System Manager`: To store Parameters

* `DockerHub`: To store Docker Images in a Repository

* `Identity and Access Management` (IAM) for creating a Service Role

* `S3` for artifact storing

* `EC2` for Deployment

Clone this Repository

```elixir
git clone https://github.com/NotHarshhaa/DevOps-Projects.git
```

# **Project Architecture**

![](https://miro.medium.com/v2/resize:fit:1431/1*9s2m5NLVfW-A3IbDRg3b1w.png)

# **Setting Up CodeCommit**

* Create a Repository

![](https://miro.medium.com/v2/resize:fit:802/1*9hontpTywG4GrV3p6xprYQ.png)

# **Create IAM User:**

* Go to the IAM console and create a user.

* Click on Create User -&gt; User details -&gt; Next.

* Add Permission for full access to CodeCommit.

![](https://miro.medium.com/v2/resize:fit:802/1*HT43fxrhT-H_5eRINTJrOg.png)

* Click on Create for the user.

* Click on the user and go to the security credentials section

* Now we are going to create SSH credentials for this user.

* Go to the terminal and run this command

```yaml
ssh-keygen
```

* Keep all the default values.

* Copy the public key using `cat ~/.ssh/id_rsa.pub`. Paste it into the security credentials, and SSH public key for the CodeCommit section, and copy the `SSH key id`.

* Go back to the repository and copy the URL for the git connection.

* Now run

```yaml
cd ~/.ssh 
touch config
```

* Host git-codecommit.\*.amazonaws.com

* User &lt;paste the id of ssh key (can find after you paster your key in aws )-&gt; IdentityFile `~/.ssh/id_rsa`

* Now we can connect to this repo.

* Run this command now

```yaml
git clone <SSH URL>
```

* Now copy all the content from my git repository to your code commit repository.

* And do a git push.

![](https://miro.medium.com/v2/resize:fit:802/1*G9GM6z1zsy1Vu4l45RzdYA.png)

![](https://miro.medium.com/v2/resize:fit:802/1*a71BaQJ9cqXhNu4qwNdo5g.png)

# **Setting Up CodeBuild**

* Click on `Create build project`

* Follow this steps

![](https://miro.medium.com/v2/resize:fit:802/1*hF5pB28HSV3hK4BAnyyYpw.png)

![](https://miro.medium.com/v2/resize:fit:802/1*y3cQxzMHMprg4GSYFk_9Qg.png)

![](https://miro.medium.com/v2/resize:fit:802/1*y3cQxzMHMprg4GSYFk_9Qg.png)

* CodeBuild will need `buildspec.yml` to build a project.

* The `buildspec.yml` file is in the repository root folder.

* Also, This project will containerize so that select the `Enable this flag if you want to build Docker images or want your builds to get elevated privileges.`

![](https://miro.medium.com/v2/resize:fit:802/1*WUg10Pj1em5re2Dj0BLLQQ.png)

* In this project, we will build and push a Docker image to the DockerHub repository.

* So, We need DockerHub credentials like `Username` and `Password`.

* Also, we are using a free API to consume movie/TV data in this Project. [TMDB](https://www.themoviedb.org/).

# **Using** `AWS System Manager` for storing secrets

* Goto `AWS System Manager` dashboard.

* Click on `Parameter Store` -&gt; `Create parameter`

* In Parameter details

***Add*** `DockerHub Username`

*Name:* `/myapp/docker-credentials/username`

*Type:* `SecureString`

*Value: Add Your DockerHub Username*

***Add*** `DockerHub Password`

*Name:* `/myapp/docker-credentials/password`

*Type:* `SecureString`

*Value: Add Your DockerHub Password or secret token*

***Add*** `TMDB API Key`

*Name:* `/myapp/api/key`

*Type:* `SecureString`

*Value: Add Your TMDB API key*

* Also, Add Permission in CodeBuild Created Role to assess `Parameters from CodeBuild to System Manager`

* For this, Create an inline policy.

```yaml
{
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters"
            ],
            "Resource": [
                "arn:aws:ssm:*:{AWS Account ID 12 Digit}:parameter/*"
            ]
        }
```

![](https://miro.medium.com/v2/resize:fit:802/1*VfTQdzq_oG6sZY2_HeRj5A.png)

![](https://miro.medium.com/v2/resize:fit:802/1*y51NsZiy-iXrHYYdPR7Q9Q.png)

![](https://miro.medium.com/v2/resize:fit:802/1*aZbW27bLMPaADw65kU6V8Q.png)

![](https://miro.medium.com/v2/resize:fit:802/1*KkPwQwzMIeWjVhND2YX8TA.png)

![](https://miro.medium.com/v2/resize:fit:802/1*lib2KrSVn3kpOXrhoF_UcQ.png)

# **DockerHub Repository**

![](https://miro.medium.com/v2/resize:fit:802/1*YMxMt339Ovym9DYCTbV88w.png)

* Just for Test

* `Pull` this Docker Image is locally using `docker run -n netflix -p 8080:80 dhruvdarji123/netflix-react-app`

![](https://miro.medium.com/v2/resize:fit:802/1*84WPkjw5a1ddu8QS7Brx7g.png)

# **Build Artifact store in S3 Bucket**

In the CodeBuild console Click on Edit button -&gt; Artifacts -&gt; Type: “S3” -&gt; put Uplode Location.

# **Create CodeDeploy Application**

* Create Application and Compute platform is EC2/On-premises

Create Service role (Give permissions -

1.`AmazonEC2FullAccess`

2.`AmazonEC2RoleforAWSCodeDeploy`

3\. `AmazonS3FullAccess`

4.`AWSCodeDeployeFullAccess`

5.`AWSCodeDeployRole`

6.`AmazonEC2RoleforAWSCodeDeployLimitaccesstoS3`

![](https://miro.medium.com/v2/resize:fit:802/1*Qy8myUrKBs2Mdz3zcYarnw.png)

# **Create EC2 instance**

Click Launch Instances

* `Amazon Linux` -&gt; `t2.micro`

* Also, Create a Service Role for `EC2 to access s3 & CodeDeploy`

* Goto IAM Dashboard -&gt; Create Role -&gt; Service Role -&gt; EC2

* Add this permission

1. `AmazonEC2FullAccess`

2. `AmazonEC2RoleforAWSCodeDeploy`

3. `AmazonS3FullAccess`

4. `AWSCodeDeployFullAccess`

![](https://miro.medium.com/v2/resize:fit:516/1*UeYfAPx9TUTD-al36pMn5w.png)

* Give Role name -&gt; Click on Create Role

![](https://miro.medium.com/v2/resize:fit:802/1*UgsSUsPQB-IlWMeE7KTi0g.png)

* Give This Service Role here.

![](https://miro.medium.com/v2/resize:fit:802/1*IeX4BlMt9mAcCEP0SjNQ4Q.png)

![](https://miro.medium.com/v2/resize:fit:802/1*whbDYJoPyKt5jvg_TKDq2w.png)

* Add this Script to the User Data section.

* Or Just run it manually.

* For `Amazon Linux`

```yaml
#!/bin/bash
sudo yum -y update
sudo yum install -y docker
sudo service docker start
sudo usermod -aG docker ec2-user
sudo yum -y install ruby
sudo yum -y install wget
cd /home/ec2-user
wget https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install
sudo chmod +x ./install
sudo ./install auto
```

* For `Ubuntu`

```yaml
#!/bin/bash
sudo apt update
sudo install docker.io
sudo apt install ruby-full
wget cd /home/ubuntu wget https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent status
```

![](https://miro.medium.com/v2/resize:fit:802/1*M_gK-QozKKhGF2a69sqr-Q.png)

# **Create CodeDeploy Group**

* Create a CodeDeploy Group using the following Steps.

![](https://miro.medium.com/v2/resize:fit:802/1*qCR1ss5LljksU-eQU0SE3Q.png)

![](https://miro.medium.com/v2/resize:fit:802/1*NV8AWUIRLZn4Hh8RkthZ-A.png)

* Click On `Create Deployment`

* `Start Deployment`

![](https://miro.medium.com/v2/resize:fit:802/1*S9LeQEpcYgRHpSOTDkk_Qw.png)

# **Create CodePipeline**

* Step 1: Choose pipeline setting -&gt; PipelineName &gt; Service role

* Step 2: Add source stage -&gt; CodeCommit &gt; RepoName &gt; BranchName &gt; Select CodePipeline periodically for changes(For automation)

* Step 3: Add build stage -&gt; BuildProvider &gt; Region &gt; ProjectName &gt; Single build

* Step 4: Add deploy stage -&gt; DeployProvider &gt; Region &gt; AppName &gt; Deployment group

* Step 5: Review

![](https://miro.medium.com/v2/resize:fit:802/1*QeQ1src8x9U7AkoFMybm6g.png)

![](https://miro.medium.com/v2/resize:fit:802/1*wzOqHTKYqQhnVW8_pxHu8g.png)

# **CodeBuild History**

![](https://miro.medium.com/v2/resize:fit:802/1*v2g91Zb-6MrxGLpHUaEmWw.png)

**CodeDeploy**

![](https://miro.medium.com/v2/resize:fit:802/1*mjRCZCpzUQiTOGN4ZwpoIg.png)

# **CodeDeploy History**

![](https://miro.medium.com/v2/resize:fit:802/1*Rv0iMnCaXH4xl5tDKGmDSQ.png)

# **Output**

![](https://miro.medium.com/v2/resize:fit:1146/1*AXXMABbwjT5zFi5zibzP5A.png)

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
