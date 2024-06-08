# Deploying an app to AKS using Azure DevOps & Azure Cloud Shell

# Prerequisites

1. Access to an Azure Account

2. Access to Azure DevOps and PAT Token

3. Access to a GitHub Account

4. Create an Azure DevOps Organization. Head [here](https://aex.dev.azure.com/) & click the “Create a new organization” button.

5. All of the following commands should be run in Azure Cloud Shell. Access the shell [here](https://shell.azure.com/) from any browser and logging into your Azure account.

You can use the PowerShell screen, but in this walkthrough I use Bash. Type “bash” in the terminal to switch to bash commands.

## Overall Architecture

[![Overall Architecture](https://res.cloudinary.com/practicaldev/image/fetch/s--aST7vxoo--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/9yjcvrdm1uibekjf354m.PNG)](https://res.cloudinary.com/practicaldev/image/fetch/s--aST7vxoo--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/9yjcvrdm1uibekjf354m.PNG)

*I used Cloud Skew to create the above diagram. Highly recommend you check it out (It's FREE).*

* **Azure DevOps & GitHub** are great, easy to use SaaS products - GitHub and Azure Pipelines will help you to achieve your source control and CI/CD needs. The source code is in a Git repository in GitHub (your application, infrastructure, and pipeline code), and your CI/CD pipeline is an Azure YAML Pipeline.

* **Azure Container Registry (ACR)** is an Azure-native container registry, much like Docker Hub but it’s Azure’s container registry solution, so it integrates with other Azure resources and uses Azure Active Directory for added security. The Azure Pipeline in this demo is building and pushing the Docker image to the ACR (a new version of the image is created on every successful run of the pipeline execution).

* **Azure Kubernetes Service (AKS)** is a serverless, managed container orchestration service. AKS runs directly on Azure as a PaaS service and provides you with a Kubernetes environment to deploy and manage your containerized Docker application. This managed Kubernetes environment is what runs your Kubernetes resources in this demo.

* **Azure Active Directory** is the built-in Azure identity management solution. In this demo, it is important for you because you need a Service Principal (an identity based on an Azure AD App Registration). This Service Principal is used to create a secure, identity-based authenticated connection (a Service Connection to the Azure Resource Manager) so you can deploy the resources with the correct permissions to the correct Azure Subscription.

## Initial Setup

* Add the Azure DevOps extension to your cloud shell session:

```bash
az extension add --name azure-devops
```

* Add context for your shell to reference your DevOps organization:

```bash
az devops configure --defaults organization=https://dev.azure.com/insertorgnamehere/
```

* Set the **AZURE\_DEVOPS\_EXT\_PAT** environment variable at the process level. Now run any command without having to sign in explicitly:

```bash
export AZURE_DEVOPS_EXT_PAT=insertyourpattokenhere
```

* Create a new Azure DevOps project:

```bash
az devops project create --name k8s-project
```

* Set the default project to work with:

```bash
az devops configure --defaults project=k8s-project
```

## Deploying the Infrastructure

* Create a resource group to logically organize the Azure resources you will be creating:

```bash
az group create --location westeurope --resource-group my-aks-rg
```

* Create a service principal. Your AKS cluster will use this service principal to access the Azure Container Registry and pull container images.

**IMPORTANT: Copy the output of the following command, you will need it later:**

```bash
az ad sp create-for-rbac --skip-assignment
```

* Create an AKS cluster to deploy your app into (this is where you use the output from the previous command)

**IMPORTANT: Sometimes you will get an error like "400 Client Error: Bad Request for url" - It is a known issue & re-running the command again usually works:**

### [az role assignment create fails in Cloud Shell: 400 Client Error: Bad Request for url: http://localhost:50342/oauth2/token #9345](https://github.com/Azure/azure-cli/issues/9345)

```bash
az aks create -g my-aks-rg -n myakscluster -c 1 --generate-ssh-keys --service-principal "insertappidhere" --client-secret "insertpasswordhere"
```

* Create an Azure Container Registry (ACR). This will be the repository for our containers used in AKS:

```bash
az acr create -g my-aks-rg -n insertuniqueacrnamehere --sku Basic --admin-enabled true
```

* To allow AKS to pull images from ACR, we must set our Azure RBAC permissions for the service principal:

```bash
ACR_ID=$(az acr show --name ghostauacr --resource-group my-aks-rg --query "id" --output tsv)

CLIENT_ID=$(az aks show -g my-aks-rg -n myakscluster --query "servicePrincipalProfile.clientId" --output tsv)

az role assignment create --assignee $CLIENT_ID --role acrpull --scope $ACR_ID
```

## Deploying the Application

* Fork this GitHub repo (open this link in a new tab and click "fork"):

### [ghostinthewires](https://github.com/ghostinthewires) / [**k8s-application**](https://github.com/ghostinthewires/k8s-application)

* Now clone it to the terminal session within cloud shell:  

```bash
git clone https://github.com/<your-github-username-goes-here>/k8s-application.git

cd k8s-application
```

* Create a pipeline in Azure DevOps:

```bash
az pipelines create --name "k8s-application-pipeline"
```

* Follow the prompts in your terminal to set up the pipeline:

1. Enter your GitHub username; press enter

2. Enter your GitHub password; press enter

3. Confirm by entering your GitHub password again; press enter

4. (If Enabled) Enter your two factor authentication code

5. Enter a service connection name (e.g. k8sapplicationpipeline); press enter

6. Choose \[3\] to deploy to Azure Kubernetes Service; press enter

7. Select the k8s cluster you just created; press enter

8. Choose \[2\] for the “default” Kubernetes namespace; press enter

9. Select the ACR you just created; press enter

10. Enter a value for image name (press enter to accept the default); press enter

11. Enter a value for the service port (press enter to accept the default); press enter

12. Enter a value for enable review app flow for pull requests (press enter without typing a value)

13. Choose \[1\] to continue with generated YAML; press enter

14. Choose \[1\] to commit directly to the master branch; press enter

## **CONGRATULATIONS!**

**You have created an Azure DevOps Project! Wait a few minutes for the container to build, push to ACR, then deploy to AKS.**

* Access your AKS cluster by getting the kubeconfig credentials:

```bash
az aks get-credentials --resource-group my-aks-rg --name myakscluster
```

* View the Kubernetes resources your project has created:

```bash
kubectl get all
```

[![kubectl get all](https://res.cloudinary.com/practicaldev/image/fetch/s--kSIvGnYa--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/5ckrh8renuq0nerc3j88.PNG)](https://res.cloudinary.com/practicaldev/image/fetch/s--kSIvGnYa--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/5ckrh8renuq0nerc3j88.PNG)

* Copy the service IP address (under “External IP”) and paste into a new browser tab with ":8888" (e.g. 51.137.4.161:8888) on to the end.

## **This should be your final result!**

[![Super k8s Demo](https://res.cloudinary.com/practicaldev/image/fetch/s--IlcXQ_4m--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/rak18btkdex17vlu4my7.PNG)](https://res.cloudinary.com/practicaldev/image/fetch/s--IlcXQ_4m--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/rak18btkdex17vlu4my7.PNG)

## Summary

In a relatively short period of time, you have created a new project in Azure DevOps. Within that project, you have set up a CI/CD pipeline. That pipeline built your application inside of a container, pushed that container to a container repository, and deployed the container to AKS. Finally allowing you to view your web application running in AKS from the web via a Kubernetes service. You are amazing, well done!

**IMPORTANT: Head back over to your forked repo and check out the file "azure-pipelines.yml". You should see the line "trigger: – master" which means every time we make a change to the master branch, a new build will kick off automatically. Magic!**

Now that you have a fully working application deployed to AKS, I bet you can't wait to dive in and see how it all works under the hood.

# Thank you

Thank you for taking the time to work on this tutorial/labs. Let me know what you thought!

#### Author by [Harshhaa Reddy](https://github.com/NotHarshhaa)

### Ensure to follow me on GitHub. Please star/share this repository
