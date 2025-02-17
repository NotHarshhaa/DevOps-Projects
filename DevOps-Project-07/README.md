# DevOps-Journey-Using-Azure-DevOps

![Azure-DevOps](https://imgur.com/J2F5qPP.png)

This tutorial/lab setup is going to take you through a DevOps journey using Azure DevOps. From setting up your pipeline to deploying an application to your Azure Kubernetes cluster! 

# What you will learn

In this tutorial/lab, you will learn:

- Initial setup of Azure DevOps to begin deploying to Azure using Pipelines as code
- Deploy Azure resources using Terraform modules
- Deploy a test application to Azure Kubernetes Service 
- An understanding of CI/CD with automated application deployments
- Test your deployed Azure resources using automated testing
- Reviewing monitoring and alerting using Application & Container Insights

This setup is based on a somewhat "real-life" scenario and setup mirrors an example of a real-world setup!

## Tutorial/labs format

Prior to starting the tutorial/labs - please review the below [Prerequisites](prerequisites.md)

Labs are found [here](labs/), complete each one in number sequence 1...2...3...etc

1. [Initial Setup](labs/1-Initial-Setup) starts you off with setting up:
   - [Azure DevOps Setup](labs/1-Initial-Setup/1-Azure-DevOps-Setup.md)
     - Azure DevOps Organisation Setup
     - Azure DevOps Project Creation
     - Azure Service Principal Creation

   - [Azure Terraform setup](labs/1-Initial-Setup/2-Azure-Terraform-Remote-Storage.md)
     - Create Blob Storage location for Terraform State file

   - [Create Azure AD Group for AKS Admins](labs/1-Initial-Setup/3-Create-Azure-AD-AKS-Admins.md)
     - Create Azure AD AKS Admin Group

2. [Setup Azure DevOps Pipeline](labs/2-AzureDevOps-Terraform-Pipeline) The purpose of this lab is to create all of the Azure cloud services you'll need from an environment/infrastructure perspective to run the test application.
   - [Pipeline setup](labs/2-AzureDevOps-Terraform-Pipeline/1-Setup-AzureDevOps-Pipeline.md)
     - Setup Azure DevOps Pipeline

3. [Deploy Application to Azure Container Registry](labs/3-Deploy-App-to-ACR) Deploy sample Application to Container Registry.
   - [Deploy Application to Azure Container Registry](labs/3-Deploy-App-to-ACR/1-Deploy-App-to-ACR.md)
     - Build the Docker Image Locally
     - Run The Docker Image Locally
     - Deploy sample Application to Container Registry

4. [Deploy Application to Azure Kubernetes Cluster](labs/4-Deploy-App-AKS) 
   - [Add AKS ACR Role assignment](labs/4-Deploy-App-AKS/1-Add-AKS-ACR-Role-Assignment.md)
     - Terraform to add role assignment for AKS managed identity to access the deployed ACR

   - [Add Application Insights to Terraform](labs/4-Deploy-App-AKS/2-Add-Application-Insights.md)
     - Application Insights will be used to monitor the application once deployed!

   - [Add Azure Key Vault to Terraform](labs/4-Deploy-App-AKS/3-Add-KeyVault-to-Terraform.md)
     - Azure Key Vault will be used to store secrets used within your Azure DevOps Variable Group.

   - [Update Pipeline to Deploy Application to AKS](labs/4-Deploy-App-AKS/4-Update-Pipeline-Deploy-App-AKS.md)
     - Update Pipeline to Deploy asp Application to AKS


5. [Introduce CI/CD](labs/5-CICD) 
   - [Introducing CI/CD to your pipeline](labs/5-CICD/1-Introduce-CI-CD-to-your-Pipeline.md)
     - Begin CI/CD with Pipeline Trigger for automatic pipeline runs

   - [Automated deployment of your AKS Application](labs/5-CICD/2-Automated-Deployment-AKS-Application.md)
     - In previous labs; the application was initially manually setup for its build tag. In CI/CD, this would be automated and the Application on the AKS cluster would update each time the pipeline has been ran.


6. [Testing your deployed Azure Infrastructure](labs/6-Testing-Infrastructure) 
   - [Testing Infrastructure using Inspec](labs/6-Testing-Infrastructure/1-Testing-Infrastructure-using-Inspec.md)
     - Using Inspec-Azure to test your Azure Resources

   - [Inspec Testing using Azure DevOps Pipeline](labs/6-Testing-Infrastructure/2-Run-Inspec-Tests-Using-Azure-DevOps.md)
     - Run Inspec-Tests using Azure DevOps
     - View Inspec reports in Azure DevOps


7. [Monitoring and Alerting](labs/7-Monitoring-and-Alerting) 
   - [Azure Application Insights](labs/7-Monitoring-and-Alerting/1-Application-Insights.md)
     - Using Application Insights to view telemetry data!

   - [Azure Application Insights Availability Tests](labs/7-Monitoring-and-Alerting/2-Application-Insights-Configure-Availability-Test.md)
     - Configure availability test using Application Insights

   - [Log Analytics Container Insights](labs/7-Monitoring-and-Alerting/3-Log-Analytics-Container-Insights.md)
     - Reviewing Log Analytics Container Insights


# CI/CD

You will learn how to setup and configure a pipeline that involves CI/CD

![](images/cicdimage.png)

1. Developer changes application source code.
2. Application is committed to the source code repository in Azure Repos.
3. Continuous integration triggers application build 
4. Continuous deployment within Azure Pipelines triggers an automated deployment with environment-specific configuration values.
5. Updated Application is deployed to environment specific Kubernetes cluster
6. Application Insights collects and analyzes health, performance, and usage data.
7. Azure Monitor collects and analyzes health, performance, and usage data.

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
