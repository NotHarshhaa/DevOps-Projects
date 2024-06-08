# Implementation of the Entire Advanced CI/CD Pipeline with Major DevOps Tools

![devops](https://imgur.com/WcCpKVU.png)

### These are the steps I followed in the implementation of the entire CI/CD Pipeline

1. [Provisioned the required infrastructure like VPC, Security Group, Ansible Controller Instance, Jenkins Master and Agent Instances using Terraform.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step1.md#L1)

2. [Configured SSH keys for password less authentication between Ansible Controller and Agent nodes.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step2.md#L1)

3. [Configured the Jenkins Master and Agent nodes using Ansible. Configured Jenkins Agent as the Maven Build server.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step3.md#L1)

4. [Added Jenkins Agent node's credentials in Jenkins Master to establish a connection between Jenkins Master and Agent nodes.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step4.md#L1)

5. [Added GitHub credentials to the Jenkins Master and created Multibranch Pipeline job.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step5.md#L1)

6. [Configured the Multibranch Pipeline job with GitHub Webhook Trigger with the help of Multibranch Scan Webhook Trigger Plugin.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step6.md#L1)

7. **SonarQube:**
    1. [Generated an access token in SonarCloud and added SonarQube server credentials in Jenkins Master.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step7.md#L3)
    2. [Installed Sonarqube scanner plugin.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step7.md#L64)
    3. [Added Sonarqube server to the Jenkins Master in System section.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step7.md#L100)
    4. [Added Sonarqube scanner to the Jenkins Master in Tools section.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step7.md#L140)
    5. [Configured an organization and project in SonarCloud and wrote a sonar-project. properties file.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step7.md#L174)
    6. [Added sonarqube, unit tests and build stages in the Jenkinsfile.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step7.md#L236)

8. [Added JFrog credentials in the Jenkins Master and integrated JFrog artifactory with Jenkins by installing Artifactory plugin in Jenkins Master.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step8.md#L1)

9. [Created a Docker Image out of the jar file and committed that Docker Image into the Docker repository of the JFrog artifactory with the help of Docker Pipeline plugin. Added the Docker Build and Publish stage in Jenkinsfile.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step9.md#L1)

10. **EKS:**
    1. [Provisioned the EKS cluster with Terraform.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step10.md#L3)
    2. [Installed kubectl in Jenkins Slave.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step10.md#L69)
    3. [Installed AWS CLI v2 in Jenkins Slave to connect with AWS account.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step10.md#L125)
    4. [Downloaded Kubernetes credentials and cluster configuration from the cluster using the command](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step10.md#L181)
    5. `aws eks update-kubeconfig --region <region_name> --name <cluster_name>` 

11. [Pulled the Docker Image from the JFrog artifactory using Kubernetes secret and deployed it in our EKS cluster using deployment resource and exposed it to access from outside using service resource under a particular namespace. Added the deployment stage in Jenkinsfile.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step11.md#L1)

12. [Added the Prometheus helm chart repository and implemented the cluster monitoring using Prometheus and Grafana.](https://github.com/NotHarshhaa/DevOps-Projects/blob/master/DevOps-Project-06/Steps/step12.md#L1) 
    * Note: Changed the default service type of Prometheus and Grafana services from ClusterIP to LoadBalancer to access them from the browser.

---

# Hit the Star! ⭐

***If you are planning to use this repo for learning, please hit the star. Thanks!***

#### Author by [Harshhaa Reddy](https://github.com/NotHarshhaa)
