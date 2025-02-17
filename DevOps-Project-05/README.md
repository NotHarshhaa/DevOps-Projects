# Deploy your code on a Docker Container using Jenkins on AWS

![AWS](https://imgur.com/Hk28ffE.png)

**In this blog, we are going to deploy a Java Web app on a Docker Container built on an EC2 Instance through the use of Jenkins.**

### Agenda

* Setup Jenkins
* Setup & Configure Maven and Git
* Integrating GitHub and Maven with Jenkins
* Setup Docker Host
* Integrate Docker with Jenkins
* Automate the Build and Deploy process using Jenkins
* Test the deployment

### Prerequisites

* AWS Account
* Git/ Github Account with the Source Code
* A local machine with CLI Access
* Familiarity with Docker and Git

## Step 1: Setup Jenkins Server on AWS EC2 Instance

* Setup a Linux EC2 Instance
* Install Java
* Install Jenkins
* Start Jenkins
* Access Web UI on port 8080

_*Log in to the Amazon management console, open EC2 Dashboard, click on the Launch Instance drop-down list, and click on Launch Instance as shown below:*_

![AWS](https://miro.medium.com/v2/resize:fit:750/format:webp/0*dV_5siwtpbY49t_K.png)

_*Once the Launch an instance window opens, provide the name of your EC2 Instance:*_

![AWS](https://miro.medium.com/v2/resize:fit:750/format:webp/0*WfvgdzxQZFdQRwlB.png)

_Choose an Instance Type. Here you can select the type of machine, number of vCPUs, and memory that you want to have. Select t2.micro which is free-tier eligible._

![AWS](https://miro.medium.com/v2/resize:fit:750/format:webp/0*Nj8W-En4DMzUa0TC.png)

_For this demo, we will select an already existing key pair. You can create new key pair if you don’t have:_

![AWS](https://miro.medium.com/v2/resize:fit:750/format:webp/0*bFgPuri0obCx0luj.png)

_Now under Network Settings, Choose the default VPC with Auto-assign public IP in enable mode. Create a new Security Group, provide a name for your security group, allow ssh traffic, and custom default TCP port of 8080 which is used by Jenkins._

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*AgmdwgUsQNrXqUBC.png)

_Rest of the settings we will keep them at default and go ahead and click on Launch Instance_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*sMnlRAYBPgtPDOel.png)

_On the next screen you can see a success message after the successful creation of the EC2 instance, click on Connect to instance button:_

![AWS](https://miro.medium.com/v2/resize:fit:640/format:webp/0*PtPBVkTeDFmqId8-.png)

_Now connect to instance wizard will open, go to SSH client tab and copy the provided chmod and SSH command:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*nbQunrAG8XfX35FK.png)

_Open any SSH Client in your local machine, take the public IP of your EC2 Instance, and add the pem key and you will be able to access your EC2 machine in my case I am using MobaXterm on Windows:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*JOmBQOp3cOumPdcx.png)

_After logging in to our EC2 machine we will install Jenkins following the instructions from the official Jenkins website:_
<https://pkg.jenkins.io/redhat-stable/>

### To use this repository, run the following command

```
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
```

```
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
```

**Output:**

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*wif0l1ItRl1SlNN_.png)

_Now let’s install epel packages for Amazon Linux AMI:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*MAyGbEWndgdtEEF8.png)

_After installing epel packages, let’s install java-openjdk11:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*SQTXt1wNxaPPAKnJ.png)

_Let’s check the version of Java now:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*W9ng6rHA-YHnfEse.png)

_Now let’s install Jenkins with the below command as shown in the output:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*XXISoUVPof3_TYFy.png)

_After successful installation Let’s enable and start Jenkins service in our EC2 Instance:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*BxCkL2r04frbDQ2A.png)

_Now let’s try to access the Jenkins server through our browser. For that take the public IP of your EC2 instance and paste it into your favorite browser and should see something like this:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*Mn0ugcNeNwuNSu3V.png)

_To unlock Jenkins we need to go to the path /var/lib/jenkins/secrets/initialAdminPassword and fetch the admin password to proceed further:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*kAODPVtrumTdFXPB.png)

_Now on the Customize Jenkins page, we can go ahead and install the suggested plugins:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*00TB8flJKbmstdHw.png)

_Now we can create our first Admin user, provide all the required data and proceed to save and continue._

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*aQryfRoc2HqcnN57.png)

_Now we are ready to use our Jenkins Server._

![aws](https://miro.medium.com/v2/resize:fit:640/format:webp/0*s6xjjt-oHXeeaGg6.png)

## Step 2: Integrate GitHub with Jenkins

* Install Git on Jenkins Instance
* Install Github Plugin on Jenkins GUI
* Configure Git on Jenkins GUI

_Let’s first install Git on our EC2 instance with the below command:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*URfKMfI-ttqXTfjn.png)

_We can check the version as shown in the below screenshot:_

![aws](https://miro.medium.com/v2/resize:fit:640/format:webp/0*XS3JROKGV-_CFjqn.png)

_To install the GitHub plugin lets go to our Jenkins Dashboard and click on manage Jenkins as shown:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*AR9Ca27W0FPLhnC-.png)

_On the next page, click on manage plugins:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*imZ0XgDwX1Z5xB4d.png)

_Now in order to install any plugin we need to select Available Plugins, search for Github Integration, select the plugin, and finally click on `Install without restart` as shown below:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*_3Y_nVohpK-DSmDF.png)

_Now let’s configure Git on Jenkins. Go to Manage Jenkins, and click on Global Tool Configuration._

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*lkAUd7Vnxo1Bi9Ls.png)

_Under `Git installations`, provide the name Git, and under `Path`, we can either provide the complete path where our Git is installed on the Jenkins machine or just put any name, in my case I put Git to allow Jenkins to automatically search for Git. Then click on Save to complete the installation._

![aws](https://miro.medium.com/v2/resize:fit:640/format:webp/0*Kzo31Z3T86Ccp2zJ.png)

## Step 3: Integrate Maven with Jenkins

* Setup Maven on Jenkins Server
* Setup Environment Variables
JAVA_HOME,M2,M2_HOME
* Install Maven Plugin
* Configure Maven and Java

_To install Maven on our Jenkins Server we will switch to the /opt directory and download the Maven package:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*Q5XGjomraJ_61cb9.png)

_Now we will extract the tar.gz file:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*aKlWfgCiVcyvQ3vV.png)

_Now we will set up Environment Variables for our root user in bash_profile in order to access Maven from any location in our Server Go to the home directory of your Jenkins server and edit the bash_profile file as shown in the below steps:_

![aws](https://miro.medium.com/v2/resize:fit:640/format:webp/0*BcQ0KmEnzSJeyk8m.png)

_In the .bash_profile file, we need to add Maven and Java paths and load these values._

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*k9mlHgGhKh-qVQIq.png)

_To verify follow the below steps:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*ONcuVPrQsSzic6bp.png)

_With this setup, we can execute maven commands from anywhere on the server:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*KLnWUBRPgalA64j2.png)

_Now we need to update the paths where Java and Maven have been installed in the Jenkins UI. We will first install the Maven Integration Plugin as shown below:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*_pBo1pvHUAgXa2yy.png)

_After clicking on Install without restart, go again to manage Jenkins and select Global Tool configuration to set the paths for Java and Maven._

**For JAVA:**

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/0*0Alg57nEAkjDR9Qa.png)

**For MAVEN:**

![aws](https://miro.medium.com/v2/resize:fit:640/format:webp/0*fauYtn6mNuaNmg0h.png)

_Click on save and hence we have successfully Integrated Java and Maven with Jenkins._

## Step 4: Setup a Docker Host

* Setup a Linux EC2 Instance
* Install Docker
* Start Docker Services
* Run Basic Docker Commands

_Let's first launch an EC2 Instance. We will skip the steps here as we have already shown earlier how to create an EC2 Instance._

_Below is the screenshot of our newly created EC2 Instance on which we will install Docker:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*wg_bNZA4TN_ErU-sVFmb7w.png)

_We will first install Docker on this EC2 Instance:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*3aU2XbjuRyQApWFmOHd-TA.png)

_After the successful installation of Docker, let’s verify the version of Docker:_

![aws](https://miro.medium.com/v2/resize:fit:640/format:webp/1*1XGvnuTTcQE_qW9P9TUUcg.png)

_Also, let’s enable and start the Docker Service:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*T-66VH7jbZzOYXD_BqGVEQ.png)

### Create Tomcat Docker Container

_In my previous blog, I deployed a Java code on a Tomcat VM, here in this blog we will deploy on a Tomcat Docker container._

_We will first pull the official Tomcat docker image from the Docker Hub and then run the container out of the same image._

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*uAlC-mLUHel9qWwR9mKsng.png)

Let’s now create a Container from the same Image with the command:

```
docker run -d --name tomcat-container -p 8081:8080 tomcat
```

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*L0ObxA2aFZTL21fNZO7_jw.png)

_The above command runs a docker container in detached mode with the name tomcat-container and we are exposing port 8081 of our host machine with port 8080 of our container and it's using the latest image of tomcat._

Let's verify the running container on our EC2 machine:

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*kHCuhISrDKW8vsSTHo94pw.png)

_Before accessing our container from the browser we need to allow port 8081 in the Security Group of our EC2 docker-host machine._

Go to the Security group of your EC2 machine and click on Edit inbound rules:

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*V_3CISL4-kiyOUbFc7vVhg.png)

_Click on Add rule, select Custom TCP as type, and in port range put 8081–9000 in case we need it in the future, and under source select from anywhere and then click on Save rules to proceed:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*IhfhstxjlotQyhum7TBhYw.png)

Now let’s take the public IP of our Docker-host EC2 machine and with port 8081 access it from our browser:

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*hE087O2THC2TsIr-0fW3dA.png)

_From the above screenshot, you can see that although there is a 404 error, it also displays Apache Tomcat at the bottom which means the installation is successful however this is a known issue with the Tomcat docker image that we will fix in the next steps._

_The above issue occurs because whenever we try to access the Tomcat server from the browser it will look for the files in /webapps directory which is empty and the actual files are being stored in /webapps.dist._

_So in order to fix this issue we will copy all the content from webapps.dist to webapps directory and that will resolve the issue._

Let's access our tomcat container and perform the steps as shown below:

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*mNlcb3tNMjqst06Sea7qmA.png)

Once we are in the tomcat container go to the /webapps.dist directory and copy all the content to webapps directory:

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*BAplEBKW3eaIAuh5m7_8jQ.png)

After that we should be able to access our tomcat docker container:

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*LB5W4hRNLRgJOOS-SY44nQ.png)

_Somehow if we stop this container and start another container with the same Image on a different port we will face the same issue of 404 error.
This happens because every time we launch a new container we are using a new Image as the previous container gets deleted._

_This issue can be solved by creating our own Docker Image with the appropriate changes required to run our container. This can be achieved by creating a Dockerfile on which we can mention the steps required to build the docker image and from that Image, we can run the container._

**Create a Customized Dockerfile for Tomcat:**

_To create the Dockerfile we will use the official Image of Tomcat and with it will mention the step to copy the contents from the directory /webapps.dist to /webapps:_

```
FROM  tomcat:latest
RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps
```

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*h-zOWyOXVJfuwMRejbJpVw.png)

Now let's build the Docker Image using this Dockerfile using the below command:

```
docker build -t tomcatserver .
```

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*iaY4M3egLPridfmScspRLQ.png)

Let’s verify with the docker images command:

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*F5lSsSQwbn1M1GEmZjby6w.png)

Now is the time to run the docker container out of our customized docker image which we built using our dockerfile. The command is as:

```
docker run -d --name tomcat-server -p 8085:8080 tomcatserver
```

_Here you should remember that we have already allowed port range 8081–9000 in the security group of our docker EC2 Instance._

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*kxDu5n8c1f9WDLkZ0fFBFQ.png)

Let’s verify using the docker ps command:

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*33YP6VLqpc22y-Xt0cZ_qA.png)

Also, let's try to access the Tomcat server on port 8085 from the browser:

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*uDYuKNI9eh4V6YkC7nu1FA.png)

_Hence we should be now able to launch as many times the same container without facing any issues by utilizing our customizable Dockerfile._

### Step 5: Integrate Docker with Jenkins

* Create a dockeradmin user
* Install the “Publish Over SSH” plugin
* Add Dockerhost to Jenkins “configure systems”

_Let's first create a dockeradmin user and create a password for it as well._

![aws](https://miro.medium.com/v2/resize:fit:640/format:webp/1*0JPUu2QbmQ-anS12rKd0ow.png)

Now let’s add this user to the Docker group with the below command:

```
usermod -aG docker dockeradmin
```

_Now in order to access the server using the newly created User we need to allow password-based authentication. For that, we need to do some changes in the /etc/ssh/sshd_config file._

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*8RsJDy1MdPlt_sJh9E0l9g.png)

_As you can see above we need to uncomment PasswordAuthentication yes and comment out PasswordAuthentication no._

Once we have updated the config file we need to restart the services with the command:

```
service sshd reload
Redirecting to /bin/systemctl reload sshd.service
```

_Now we would be able to log in using the dockeradmin user credentials:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*nKP5KzMchn5ityQjKLAfTg.png)

Now next step is to integrate Docker with Jenkins, for that we need to install the “Publish Over SSH” plugin:

Go to Manage Jenkins > Manage Plugins > Available plugins and search for publish over ssh plugin:

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*ly3rtkBmll9nUQHdCJLv5A.png)

Click on Install without restart to install the plugin.

Now we need to configure our dockerhost in Jenkins. For that go to Manage Jenkins > Configure System:

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*3INsphP5TB5_lGQ6mL-KQw.png)

On the next page after scrolling down you would be able to see Publish over SSH section where you need to add a new SSH server with the info as shown below:

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*3hnLNy9fWJ036nHBTMjLbA.png)

_It should be noted that it's best practice to use ssh keys however for this demo we are using password-based authentication. In the above screenshot, we have provided details of our Docker host which we created on EC2 Instance. Also, note the use of private IP under Hostname as both our Jenkins Server and Dockerhost are on the same subnet. We can also use Public IP here._

_Click on Apply and Save to proceed. With this, our Docker integration with Jenkins is successfully accomplished._

### Step 6: Create Jenkins Job to Build and Copy Artifacts on to Docker Host

_In this section, we would create a new job in Jenkins however we would copy from the existing job_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*a0hF9q-5Q_wr2acmonLAJw.png)

_Click on Ok to configure the job._

_On the configure settings you will notice that our new job has inherited all the settings from our previous build job. However, you can change the description and other settings:_

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*el5D5vX2iep6C-_2f2-35Q.png)

Now one important change we need to do is to delete the previous job post-build step and select Send files or execute commands over SSH option.

_Under the SSH server, it will display the already created ssh server which we created in our earlier steps. Then we need to provide the path from where the WAR file will be copied and then deployed on the remote server for which we also need to provide a path under the Remote directory. Then finally Apply and Save to proceed._

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*eDdVGauyN46xDFCSyVfTlw.png)

_Once we save the project the build will be triggered automatically due to Poll by SCM feature which we have enabled._

Now if we check the console output of our job we should see the Job has been successfully finished.

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*aiwznfA_cFyGgaEhP8h8og.png)

We can also verify by checking the presence webapp.war file on our docker EC2 machine:

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*V8lmUgKJLNH6TEy2JvXNGQ.png)

## Step 7: Update Dockerfile to copy Artifacts to launch New Container

_In this step, we will create a Dockerfile to include the webapp.war file to launch a new container using our Java web Application. For that, we need to copy our artifacts to the location where we have our Dockerfile._

We will create a separate directory named docker under the root user of our dockerhost inside /opt.

![aws](https://miro.medium.com/v2/resize:fit:640/format:webp/1*_43X7ebAkfeMlJGxtjkN-g.png)

_As you can in the above screenshot that this new docker directory is owned by root and in Jenkins configuration settings we have mentioned that the artifacts are owned by the dockeradmin user. So let’s give the ownership of this directory to dockeradmin user._

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*b9Ntm2W-XWKrhEmGgNhY1A.png)

_Now let's copy the Dockerfile which we created in earlier steps to this newly created docker directory and change its ownership to dockeradmin as well:_

```
mv Dockerfile /opt/docker/
cd /opt/docker/
chown -R dockeradmin:dockeradmin /opt/docker/

ll
total 4
-rw-r--r-- 1 dockeradmin dockeradmin 89 May 10 12:08 Dockerfile
```

Now we need to configure our Jenkins job to change the remote directory from /home/dockeradmin to //opt//docker:

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*JMhj-yB__MKREo7TJW4W9Q.png)

Click on Apply and Save to build the Job manually.

If the build is successful we can see the webapp.war file in the /opt/docker directory of our dockerhost:

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*A3seK2SvYpkCtNi5UWkXpw.png)

_Now in our Dockerfile, we need to mention the location of this WAR file and copy this file onto the /usr/local/tomcat/webapps location in the container._

**Dockerfile:**

```
FROM  tomcat:latest
RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps
COPY ./*.war /usr/local/tomcat/webapps
```

_Let’s now build a new image using this updated Dockerfile with the command:_

```
docker build -t tomcat:v1 .
```

**Output:**

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*I4HrLyQwzZ4pu8US9z4Mgw.png)

In the next step let’s now create a container out of this image with the command:

```
docker run -d --name tomcatv1 -p 8086:8080 tomcat:v1
```

**Output:**

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*HQ3McOs6pUTRn6lHmOuHYQ.png)

Now let’s access this application from our browser using URL <http://54.173.227.226:8086/webapp/>

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*UU4dtCjSfFagp3yI0xNaKg.png)

_So far we have successfully copied the artifacts to our dockerhost and then manually used docker commands like docker build and docker run to deploy our application on the docker container._

## Step 8: Automate Build and Deployment on Docker Container

_In this step, we will try to automate end to end Jenkins pipeline right from when we commit our code to GitHub, it should build it, create an artifact and then copy the artifacts to the docker host, create a docker image, and finally create a docker container to deploy the project._

_For this automation to happen we need to go to our Jenkins job, select configure, and under Send files or execute commands over SSH there is Exec command field where we need to put some commands as shown below:_

```
cd /opt/docker;
docker build -t regapp:v1 .;
docker run -d --name registerapp -p 8087:8080 regapp:v1
```

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*D2aGmqZ8Uh1p4Fmz_nHsVg.png)

_Now let’s do some minor changes in our code and commit the changes which will trigger the Jenkins build process and we can see the results of automation._

_As soon as I made some changes in the Readme file in the GitHub repository the build got triggered in our Jenkins Job._

If the build is successful we should see our new docker image and docker container as shown in the below screenshot:

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*HdxEPw7K3pxTrAmtZ8AP6w.png)

Also, we if access our new dockerized app from our browser on port 8087, the result should be something like this:

![aws](https://miro.medium.com/v2/resize:fit:750/format:webp/1*s6KDOzNqAUgYPenBojBnqQ.png)

### Conclusion

**In this blog, we learned how to automate the build and deploy process using GitHub, Jenkins, Docker, and AWS EC2.**

**Happy Learning!**

## 🛠️ Author & Community  

This project is crafted by **[Harshhaa](https://github.com/NotHarshhaa)** 💡.  
I’d love to hear your feedback! Feel free to share your thoughts.  

📧 **Connect with me:**

- **GitHub**: [@NotHarshhaa](https://github.com/NotHarshhaa)  
- **Blog**: [ProDevOpsGuy](https://blog.prodevopsguy.xyz)  
- **Telegram Community**: [Join Here](https://t.me/prodevopsguy)  
- **LinkedIn**: [Harshhaa Vardhan Reddy](https://www.linkedin.com/in/harshhaa-vardhan-reddy/)  

---

## ⭐ Support the Project  

If you found this helpful, consider **starring** ⭐ the repository and sharing it with your network! 🚀  

### 📢 Stay Connected  

![Follow Me](https://imgur.com/2j7GSPs.png)  
