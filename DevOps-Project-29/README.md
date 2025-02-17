# CI/CD Project: Deploy a 3-tier Microservice Voting App using ArgoCD and Azure DevOps Pipeline

![](https://miro.medium.com/v2/resize:fit:700/1*1NYGxLauxVBIOMZLqnNwUA.png)

## **TABLE OF CONTENTS**

## **Stage One: Continuous Integration**  

- Step 1: Clone and Deploy the App Locally Using Docker-Compose  
- Step 2: Create an Azure DevOps Project and Import the Repo  
- Step 4: Set Up Self-Hosted Agent for the Pipeline  
- Step 5: Write a CI Pipeline Script for Each Microservice

## **Stage Two: Continuous Delivery**  

- Step 1: Create an Azure Managed Kubernetes Cluster (AKS)  
- Step 2: Install AKS CLI and Set Up AKS for Use  
- Step 3: Install ArgoCD  
- Step 4: Configure ArgoCD  
- Step 5: Write a Bash Script that updates the pipeline image on K8s manifest  
- Step 6: Create an ACR ImagePullSecret  
- Step 7: Verify the CICD process

![](https://miro.medium.com/v2/resize:fit:700/1*rS0cr9kPPi8vGxLkDarXFA.png)

The Docker Example Voting App is a microservices-based application, typically written in Python and Node.js, with the following components:

**1&gt; Voting Frontend (Python/Flask):** Users cast votes via a simple web interface.  
2&gt; **Vote Processor Backend (Node.js/Express):** Receives and processes the votes.  
**3&gt; Redis Database (Redis):** Temporarily stores votes for fast access.  
**4&gt; Worker (Python/Flask):** Processes votes from Redis and updates the final count.  
**5&gt; Results Frontend (Python/Flask):** Displays real-time voting results.  
PostgreSQL Database (PostgreSQL): Stores the final vote count.  
  
**How It Works:**

The user votes on the frontend, the vote is processed and stored in Redis, then the worker updates the final count in PostgreSQL, and the results are shown on a results page. All components run in separate Docker containers for scalability and isolation.

Lets Begin…

## **1\. Clone and deploy the App locally using docker-compose**

To do this we have to create a VM to test our App locally,

**a. Create an Azure Linux Ubuntu VM and Login:**

Click [HERE](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-portal?tabs=ubuntu) if you are not familiar with the steps needed in creating a Linux VM, When the VM is created, navigate to the folder and `ssh` into the machine using the command `ssh -i <your-key-name> azureuser@<your-ip-name>`

Note: Make sure `port 22` is open when creating the VM. (It usually opens by default for linux systems.)

**b. Update the VM:**

Run the command

```go
sudo apt-get update
```

**c. Install Docker and Docker-Compose**

To be able to test the App locally on the VM, we will need to install docker onto our machine. This is needed for us to be able to run the `docker-compose up -d` command.

*docker-compose is used to define and run multi container applications. such as microservices.*

```go
#### 1. Install required packages
sudo apt-get install \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

#### 2. Add Docker Official GPG Key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

#### 3. Set Up the Stable Repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#### 4. Install Docker Engine
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

#### 5. Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#### 6. Manage Docker as a Non-Root User and refresh it
sudo usermod -aG docker $USER
newgrp docker

#### 7. Check versions
sudo docker --version
docker-compose --version

#### 8. Check you can docker command without sudo
docker ps
```

*Note:* `docker ps` *output should be empty since no containers are running yet*

**d. Clone the Repo**

Clone or fork the App [HERE](https://github.com/dockersamples/example-voting-app.git) ; when this is done `cd` into the repo and run the `docker-compose up -d` command

![](https://miro.medium.com/v2/resize:fit:700/1*iro87o-4rWx_qo6uFljuCA.png)

Run the command to spin up all the containers at once.

```go
docker-compose up -d
```

![](https://miro.medium.com/v2/resize:fit:700/1*gnCpjjg5OoAmXqlSsgncnQ.png)

This output shows our containers are all up and running.

```go
docker ps
```

![](https://miro.medium.com/v2/resize:fit:700/1*i61VOe9PO-9PiDXTuueX5g.png)

From the output we can see the App container is mapped on `port 5000` ; We can view the App in two (2) ways; to view the App do the following.

a. Run `curl http://localhost:5000` to view the App on the terminal

b. Copy the VM public address and type into the browser `http://vm-public-ip>:5000` to view the App.

![](https://miro.medium.com/v2/resize:fit:700/1*Nm4CMvIh2NsnBFQhMKN84A.png)

## **Step 2: Create an Azure DevOps Project and Import the repo**

a. &gt; **Login:** Go to the url [https://dev.azure.com](https://dev.azure.com/GabrielOkom/) and sign in to access the Azure Devops page. ***NOTE: If this is your first time, you may need to sign up and create an organization first.***

If this is your first time, **click** [**HERE**](https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/pipelines-sign-up?view=azure-devops) to sign up for Azure Devops pipeline

b. &gt; **Create a Project:** I will be naming my project `votingApp` , when this is done. &gt; Set the visibility to `private`, &gt; Next, click on `Create Project`

![](https://miro.medium.com/v2/resize:fit:700/1*646BSwLWUwDLBYqe_pFsQQ.png)

c. &gt; **Import the Git Repo to Azure Repo:** On the left menu pane, click on `Repos` &gt; Then `Files` &gt; In Repository type leave it as `Git` since that is where our code is stored. &gt; Input the Git repo url &gt; Click on `Import`

![](https://miro.medium.com/v2/resize:fit:700/1*opecaZ9dfUA-Ii1TLMc0GQ.png)

When this is done and successfully imported, we should see our entire Repo now.

![](https://miro.medium.com/v2/resize:fit:700/1*HcH4RiTa9liGFH1pMamRbQ.png)

## **Step 3. Create an Azure Container Registry**

When we build our docker image, we need somewhere to push and store this image. We can also use DockerHub, but for the sake of this project we will be making use of the Azure Container Registry (ACR).

a. &gt; Login to the [azure portal](https://portal.azure.com/) \&gt; search for `container registry` click on it &gt; on the left side, click on `Create` or Click on `Create container registry` at the bottom of the page.

![](https://miro.medium.com/v2/resize:fit:700/1*DAFOfMqkywbZN-64B_MGVQ.png)

b. &gt; Choose a `Resource group` or create a new one if you dont have &gt; Choose a name for your `ACR` &gt; Select either the `Basic` or the `Standard` Pricing plan (optional) &gt; Click on `Review & create`

![](https://miro.medium.com/v2/resize:fit:700/1*t4wtpDkkcPbLt0cRv2_chA.png)

After it is created, click on `Go to resource` to see the `ACR` page. &gt; Take note of the `ACR` server name. We will be using it in step 5 when building and pushing the docker image . We need to choose the `ACR` name.

![](https://miro.medium.com/v2/resize:fit:700/1*9uRpszcbYL9n7xeGf-3i0A.png)

## **Step 4. Set up Self-Hosted Agent for the Pipeline**

To save resources, we will be using the same VM used when deploying our App locally. ***(Note: you can create a new vm for this step, but make sure to install docker on it)***

*note: I will be going dark mode on my azure devops pipeline page from here.*

![](https://miro.medium.com/v2/resize:fit:700/1*VmGuXgbhbEVzN5T_739_2A.png)

a. &gt; to get started; go to your [azure devops pipeline](https://dev.azure.com/) page &gt; at the bottom left of the project page, click on `project settings` &gt; on the left menu pane, click on `Agent pools` &gt; On the right, Click on `Add pools` &gt; for Pool to link, select `New` &gt; Pool type should be `Self-hosted` &gt; type in a name for your agent &gt; for Pipeline permissions, check the `Grant access permissions to all pipelines` &gt; then `Create`

![](https://miro.medium.com/v2/resize:fit:700/1*dga6sc7YicmK9aphg8UqHg.png)

b. &gt; When the `agent pool` is created, click on it &gt; on the right, click on the `New agent` button. &gt; a new page pops up, in the page select the `Linux` system &gt; copy and run the following codes shown in your VM.

***Note: if you need a guide, agent script step by step command is given below***

![](https://miro.medium.com/v2/resize:fit:700/1*kxNyoB5y5VNWd3IqRf_y0A.png)

if you need more help, I have created a complete step by step comprehensive and well detailed guide on [how to set up a self-hosted agent in azure](https://medium.com/@ougabriel/how-to-deploy-a-self-hosted-agent-in-azure-pipeline-e89250be09c8) &gt; [*https://medium.com/@ougabriel/how-to-deploy-a-self-hosted-agent-in-azure-pipeline-e89250be09c8*](https://medium.com/@ougabriel/how-to-deploy-a-self-hosted-agent-in-azure-pipeline-e89250be09c8)

or take a queue from this steps to build your own self-hosted agent.

```go
#1. create a dir and move into the dir
mkdir myagent && cd myagent

#2. download the agent, (please copy and paste the url from the "Download the agent" copy button)
sudo apt install wget -y  
wget https://vstsagentpackage.azureedge.net/agent/3.243.0/vsts-agent-linux-x64-3.243.0.tar.gz

#3. extract the download the agent files
tar zxvf vsts-agent-linux-x64-3.243.0.tar.gz

#4 configure the agent
./config.sh

#5. start the agent and keep it running
./run.sh
```

c. &gt; when you run the `./config.sh` script &gt; for the URL prompt, copy and paste your azure devops url link; example `https://dev.azure.com/<org name>`\&gt; hit enter to choose PAT &gt; create and paste your PAT (Personal Access Token) &gt; type in the name of the agent pool created earlier &gt; for the next prompts hit enter for defaults &gt; run `./run.sh` to start the agent and keep it listening for jobs.

![](https://miro.medium.com/v2/resize:fit:700/1*kOzhiWO4a74XfcbW0JEXqg.png)

## **Step 5. Write a CI pipeline Script for each of the Microservices using separate build and push stages**

a. &gt; Setting up the pipeline: To do this, on the left menu panel click on `Repo` &gt; then click on `pipeline` &gt; in the pop window select the docker that helps us to push the image to Azure Container Registry &gt; Choose the Azure subscription you will be using

![](https://miro.medium.com/v2/resize:fit:700/1*tbGPklxy6-nIUbRX2aeT8Q.png)

After clicking the ‘Continue’ button, a new pop windows appear as shown below. &gt; from the drop down menu select the name of your `azure container registry` created earlier &gt; select or input the `image` name &gt; since we are buiding a docker image, this page will be automatically populated but make sure it is using the `result` repo file because we are building the `result`image first, when this is done we can then continue with the other services.

![](https://miro.medium.com/v2/resize:fit:700/1*yW8_3qWZKBU3A4sL4OOcAA.png)

b.&gt; Create the pipeline scripts: We will start with the `vote`microservice. the script will be divided into two stages (1. Build and 2. Push). Make sure your pipeline script looks exactly like this

```go
# Docker
# Build and push an image to Azure Container Registry
# https://docs.microsoft.com/azure/devops/pipelines/languages/docker

trigger:
 paths:
   include:
     - vote the repo we are using

resources:
- repo: self

variables:
  # Container registry service connection established during pipeline creation
  dockerRegistryServiceConnection: '37868c72-32ef-488d-a490-1415f4b73792'
  imageRepository: 'votingapp'
  containerRegistry: 'gabvotingappacr.azurecr.io'
  dockerfilePath: '$(Build.SourcesDirectory)/vote/Dockerfile'
  tag: '$(Build.BuildId)'

  # Agent VM image name
pool:
  name: 'votingApp-Agent'    #the name of my newly created selfhosted agent

stages:                               
- stage: Build                        
  displayName: Build the Voting App
  jobs:
  - job: Build
    displayName: Build

    steps:
    - task: Docker@2
      inputs:
        containerRegistry: 'gabVotingAppACR'
        repository: 'votingapp/vote'          
        command: 'build'
        Dockerfile: 'vote/Dockerfile'

- stage: Push                           
  displayName: Push the Voting App        
  jobs:
  - job: Push
    displayName: Pushing the voting App
    steps:
    - task: Docker@2
      inputs:
        containerRegistry: 'gabVotingAppACR'
        repository: 'votingapp/vote'
        command: 'push' 
```

***Note: Make sure to change the*** `agent VM name` ***to match the name of your self-hosted agent.***

c. When this is done `run` the pipeline.

![](https://miro.medium.com/v2/resize:fit:700/1*vmhnr05n9BoRBsrRlQ1R0w.png)

Next: We will run the pipeline script for the other microservices which are the `result` and `worker` services.

Now, to build and push the other two microservices ( `result` and `worker` ).

Repeat **STEP 5** but this time you are changing anywhere you see the service name `vote` to `worker` and `result` in the pipeline scripts. Change to `result` build and push; then change to `worker` build and push the image.

*(if you are not sure what to do here i have added the complete pipeline scripts at the end of this project)*

At the end of the pipeline run scripts, you should have three (3) images pushed into your `azure container registry` as shown below.

d. Confirm the push:

The pipeline…

![](https://miro.medium.com/v2/resize:fit:700/1*BD1yLtpB2JgXeEVe6nqB7w.png)

The Azure Container Registry… go to azure portal &gt; click on container registry &gt; click on the name of the `ACR` you created for this project &gt; click on `repositories` to view all the images pushed into it.

![](https://miro.medium.com/v2/resize:fit:700/1*Vm4331Uhw5h_6DMknB5SGQ.png)

# **Stage Two: Continuous Delivery**

## **Step 1: Create an Azure Managed Kubernetes Cluster (AKS)**

In the [Azure Portal](https://portal.azure.com/#create/microsoft.aks) search fro AKS or Azure Kubernetes Service and click `Create` &gt; In Project details, Select your `subscription` and the `resource group` where you’d like to deploy the kubernetes cluster into &gt; For cluster details, leave it as `Dev/Test` &gt; Choose a name for your kubernetes cluster &gt; select a region of your choice (if you face a resource deployment issues in `us-east`change it &gt; for Availability Zones, choose `Zones 1` &gt; and leave every other settings as default.

Click Next &gt; In Node Pools, check the `agentpool` and click on it &gt; In the `agentpool` pop window, change the ‘scale method’ from manual to automatic &gt; change the `min` and `max` node count to 1 and 2 &gt; Click on `Enable public IP per node`\&gt; click update

![](https://miro.medium.com/v2/resize:fit:700/1*xiFWFBRHOR5QrkK8k3sUaA.png)

\&gt; Leave every thing else as default and click on `Review & create`

This will take sometime to fully deploy

![](https://miro.medium.com/v2/resize:fit:700/1*d46hF6d2VOKbK6w4wcVdCA.png)

## **Step 2: Install Azure CLI and Set Up AKS for use**

We will be using the following commands to quickly install the AKS CLI and set up our newly deployed AKS cluster for use through a newly created VM. This VM will serve as a `workstation`for us to connect to our AKS and ArgoCD

***Note: &gt; Create a new Azure VM and run the following script inside of it &gt; Make sure to change*** `Resource_Group` ***and*** `AKS_name` ***to the name of your Resource Group and AKS cluster respectively.***

```go
# Update the package list and install necessary dependencies
sudo apt-get update
```

```go
# Step 1: Install Azure CLI
echo "Installing Azure CLI..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

```go
# Step 2: Log in to Azure
az login --use-device-code
```

Since we are using the command `az login --use-device-code` a prompt will appear with a `url` and login authentication `code` . Copy the `url` into a browser and paste the `code` into the login page to finish installing the `az cli`

![](https://miro.medium.com/v2/resize:fit:700/1*TW6fesUTSp5J3-Zd9x_xtA.png)

**Verify: &gt;** To be sure this correctly done. type `az --version` to verify the installion

```go
# Step 3: Install kubectl
sudo az aks install-cli
```

```go
# Step 4: Get AKS credentials
# Replace <ResourceGroupName> and <AKSClusterName> with your actual resource group and AKS cluster names
RESOURCE_GROUP="<ResourceGroupName>"    #change  here only
AKS_NAME="<AKSClusterName>"             #change here only

az aks get-credentials --resource-group gabRG --name votingApp-k8s --overwrite-existing

```

```go
# Step 5: Verify the connection
kubectl get nodes
```

![](https://miro.medium.com/v2/resize:fit:700/1*erK-dxPJ7wit6WJTudS4Ow.png)

In the image above, we have a single node cluster with a `ready` STATUS.

## **Step 3: Install ArgoCD**

We will install `argocd` using a bash script to make it quicker, script details has been explained below to help you get better understanding

```go
#!/bin/bash

# Step 1: Install Argo CD
echo "Installing Argo CD..."

# Create a namespace for Argo CD
kubectl create namespace argocd

# Install Argo CD in the argocd namespace
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Step 2: Wait for all Argo CD components to be up and running
echo "Waiting for Argo CD components to be ready..."
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=600s

# Step 3: Get the initial admin password
echo "Retrieving the Argo CD initial admin password..."
ARGOCD_INITIAL_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "Argo CD initial admin password: $ARGOCD_INITIAL_PASSWORD"

# Step 4: Access the Argo CD server
echo "Exposing Argo CD server via NodePort..."
kubectl -n argocd patch svc argocd-server -p '{"spec": {"type": "NodePort"}}'

# Retrieve the Argo CD server URL
ARGOCD_SERVER=$(kubectl -n argocd get svc argocd-server -o jsonpath='{.spec.clusterIP}')
ARGOCD_PORT=$(kubectl -n argocd get svc argocd-server -o jsonpath='{.spec.ports[0].nodePort}')
echo "You can access the Argo CD server at http://$ARGOCD_SERVER:$ARGOCD_PORT"

# Step 5: Login to Argo CD CLI (Optional)
echo "Installing Argo CD CLI..."
sudo curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo chmod +x /usr/local/bin/argocd

echo "Logging into Argo CD CLI..."
argocd login $ARGOCD_SERVER:$ARGOCD_PORT --username admin --password $ARGOCD_INITIAL_PASSWORD --insecure

echo "Argo CD installation and setup complete!"
```

**Script Overview:**

- **Step 1:** Installs Argo CD in a namespace called `argocd`.

- **Step 2:** Waits for all Argo CD components to be ready.

- **Step 3:** Retrieves the initial admin password for Argo CD.

- **Step 4:** Exposes the Argo CD server using a NodePort service type, making it accessible via a URL.

- **Step 5:** Optionally installs the Argo CD CLI and logs in using the initial admin password.

**How to Use:**

1. Save this script to a file, for example, `install-argo-cd.sh`.

2. Make the script executable: `chmod +x install-argo-cd.sh`.

3. Run the script: `./install-argo-cd.sh`.

This will set up Argo CD on your Kubernetes cluster and provide you with the necessary details to access and manage it.

**a. Set up Port Rule for ArgoCD**

Since `argocd` is already exposed to the internet via its `NodePort` . We can access it on the browser by using the IP address of our VM and the `port` address of the `http port 80 service` which is `31436` as shown below for my own cluster.

![](https://miro.medium.com/v2/resize:fit:700/1*YopmOgDBUT5gSJhiHv-9nQ.png)

Before we do this, we will need to expose the port `31436` of our kubernetes cluster &gt; Go to Azure Portal and search for VMSS ( `virtual machine scale set)`\&gt; click on network settings &gt; Click Creat Port Rule &gt; In the drop down, click on `Inbound Rule` &gt; Add the Port number

![](https://miro.medium.com/v2/resize:fit:700/1*tfJOeBad_AuUpOePgwwB8Q.png)

type in the `ip address` and `port number` into a browser. Example: `http://52.250.58.123:31436`

You should get the argoCD signin landing page

![](https://miro.medium.com/v2/resize:fit:700/1*QSfnrsXtmw4jRRVm7bv6qA.png)

**b.&gt; Login to ArgoCD:** We need to run the following command to get the login credentials of argoCD.

\&gt; Check to see the argoCD secret pod `kubectl get secret -n argocd`

![](https://miro.medium.com/v2/resize:fit:700/1*zRUlnjYdCfpNCUSqQZ3_Uw.png)

\&gt; Edit the secret `kubectl edit argocd-initial-admin-secret -n argocd`

![](https://miro.medium.com/v2/resize:fit:700/1*lOyEWbzsFQkJdGKalRcF0A.png)

\&gt; Copy the password and run the following command on the terminal; because the password is `base64` endoded we will need to decode it

```go
echo <the argoCD password> | base64 --decode
```

Login to the argoCD using the following

```go
username: admin
password: <your decoded argocd password>
```

![](https://miro.medium.com/v2/resize:fit:700/1*g8AIXD6IKfpIdk0JV7V6tA.png)

## **Step 4: Configure ArgoCD**

We need to configure argoCD to point to our azure repo where our `kubenetes manifest files`are stored. ArgoCD will help us install these `manifest` files in our kubernetes cluster and also help to monitor for changes in the Azure Repo. Any changes made or observed in the repo will then be pushed to our kubernetes cluster.

To do this, we need to connect argoCD to Azure repo and to our AKS.

**a. &gt; Connect to Azure repo:** copy the HTTPS URL of your Azure repo and paste it in the URL field.

![](https://miro.medium.com/v2/resize:fit:700/1*1gVO9eVvshpAX2r3FviIRQ.png)

\&gt; Next, create a `Personal Access Token` &gt; In your azure repo, click on `user settings` &gt; from the drop down menu, click on `personal access token` &gt; click `New Token` &gt; Give it a name and a permission, it can be `read` access or `full access` ***Note: full access is for testing purpose only &gt;*** Copy the newly created PAT

![](https://miro.medium.com/v2/resize:fit:700/1*-wDeR9XNJxEsigQ8cs4QGg.png)

\&gt; Connect the ArgoCD to azure repo: In your argoCD page, click on `settings` &gt; click on the `+Connect repo` button &gt; in `choose your connection method` select `VIA HTTPS` &gt; for project, select `default`\&gt; paste the URL of the Azure Repo &gt; Edit the azure repo and paste your PAT. &gt; test if connection is successful by clicking on `CONNECT`

***Edit the Azure Repo to also contain the Personal Access Token, for example***

![](https://miro.medium.com/v2/resize:fit:700/1*nIzDJ8vQS5-7-BtYtGeecg.png)

![](https://miro.medium.com/v2/resize:fit:700/1*uAiK0Rwei3t_NrawNTKvQQ.png)

check connection

![](https://miro.medium.com/v2/resize:fit:700/1*yzqaUL7u1YeoJEE83R3Z9w.png)

**b. &gt; Connect to Azure Kubernetes Service (AKS) &gt;** In the argoCD page, click on `New Application` &gt; for `Application Name`, give it a name &gt;in project, select default &gt; for `SYNC POLICY` choose automatic &gt; for Repository URL source, click on the Azure Repo URL added earlier, *it will appear automatically &gt;* for `Path` , type in `k8s-specifications` &gt; in namespace, type `default` &gt; create it and wait for all the manifest files to be deployed to k8s and the pods running

`k8s-specifications` is our Azure repo folder where all our kubernetes manifest files are located, We want argoCD to deploy and monitor this folder for us

![](https://miro.medium.com/v2/resize:fit:700/1*TVZpbnaaPh2wIMHitnAfDQ.png)

From argoCD we can confirm if all the pods are running

![](https://miro.medium.com/v2/resize:fit:700/1*l8T1poqmkyH8LfHxYPl3gg.png)

We can also check through our terminal to confirm the running pods.

![](https://miro.medium.com/v2/resize:fit:700/1*fPHsbz71-aD8nDA-TDDgXw.png)

## **Step 5: Write a Script that updates the pipeline image on Kubernetes manifest**

This a crucial step to our CICD project, in the CD (Continuous Delivery) stage we have the argoCD monitoring the `k8s-manifest` files in the Azure Repo and deploying the changes to AKS cluster; but ***how does argoCD know when there is a change in the CI stage?*** . (Remember, in the CI stage we built the image and pushed the image to ACR (Azure Container Registry)).

Now, in order to automate the CI stage with the CD stage, we will be making use of BASH Script. This `bash` script will monitor the ACR for any changes, when there is a new CI build and push it will detect the change and help us update this change to the Azure Repo *(Remember, argoCD is already monitoring the Azure repo)*

a.&gt; Add the script to the `vote-service` folder within the repo

![](https://miro.medium.com/v2/resize:fit:700/1*ITgC3-NhlqhhvFrEGyKXHQ.png)

the script

```go
#!/bin/bash

set -x

# Set the repository URL
REPO_URL="https://<ACCESS-TOKEN>@dev.azure.com/GabrielOkom/votingApp/_git/votingApp"

# Clone the git repository into the /tmp directory
git clone "$REPO_URL" /tmp/temp_repo

# Navigate into the cloned repository directory
cd /tmp/temp_repo

# Make changes to the Kubernetes manifest file(s)
# For example, lets say you want to change the image tag in a deployment.yaml file
sed -i "s|image:.*|image: <ACR NAME>/$2:$3|g" k8s-specifications/$1-deployment.yaml

# Add the modified files
git add .

# Commit the changes
git commit -m "Update Kubernetes manifest"

# Push the changes back to the repository
git push

# Cleanup: remove the temporary directory
rm -rf /tmp/temp_repo
```

This Bash script automates cloning a Git repository, updating a Kubernetes deployment’s Docker image tag, committing the changes, and pushing them back to the repository; it takes three parameters: `$1` (deployment file prefix which is `vote`), `$2` (image name), and `$3` (new image tag).

what will happen here is the script will detect the new image inside the container registry using its image tag*.****(every new build generates a new image tag for that build)***

![](https://miro.medium.com/v2/resize:fit:700/1*T35nwvmht5ZkCkGOQnrnrg.png)

when this is done it updates the k8s-manifest deployment file with the new image and new tag &gt; argocd detects the changes and deploys it to AKS &gt; this way we can have a new version of the app whenever a change is made

it changes the `image` section of the `vote-deployment.yaml` file

```go
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: vote
  name: vote
spec:
  replicas: 1
  selector:
    matchLabels:
      app: vote
  template:
    metadata:
      labels:
        app: vote
    spec:
      containers:
      - image: gabvotingappacr.azurecr.io/votingapp/vote:18 ##tag changes anytime a new image is built
        name: vote
        ports:
        - containerPort: 80
          name: vote
```

b.&gt; Add a new stage to the `vote-service` pipeline

```go
# Docker
# Build and push an image to Azure Container Registry
# https://docs.microsoft.com/azure/devops/pipelines/languages/docker

trigger:
  paths:
    include:
      - vote

resources:
- repo: self

variables:
  # Container registry service connection established during pipeline creation
  dockerRegistryServiceConnection: 'a777b3f1-28d4-40f3-bbdf-0904d5c89545'
  imageRepository: 'votingapp'
  containerRegistry: 'gabvotingappacr.azurecr.io'
  dockerfilePath: '$(Build.SourcesDirectory)/result/Dockerfile'
  tag: '$(Build.BuildId)'

pool:
 name: 'votingApp-Agent'

stages:
- stage: Build
  displayName: Build the voting App
  jobs:
  - job: Build
    displayName: Build

    steps:
    - task: Docker@2
      inputs:
        containerRegistry: 'gabVotingAppACR'
        repository: 'votingapp/vote'
        command: 'build'
        Dockerfile: '**/Dockerfile'


- stage: Push
  displayName: Push the voting App
  jobs:
  - job: Push
    displayName: Push

    steps:
    - task: Docker@2
      inputs:
        containerRegistry: 'gabVotingAppACR'
        repository: 'votingapp/vote'
        command: 'push'
##################################
######### Add the script below to the vote-service pipeline 

- stage: Update_bash_script
  displayName: update_Bash_script
  jobs:
  - job: Updating_repo_with_bash
    displayName: updating_repo_using_bash_script
    steps:
    - task: ShellScript@2
      inputs:
        scriptPath: 'vote/updateK8sManifests.sh'
        args: 'vote $(imageRepository) $(tag)'

```

`$1` *(*`vote`*),* `$2` *(image name), and* `$3` *(new image tag).*

Now that we have finally integrated the `shell script` to the CI and now have a completely setup CICD pipeline, we can now go ahead and test our deployment

*NOTE: if the update script runs and not yet updated we can edit the configmap of the argocd to make fetch and deploy updates quicker, run* `kubectl edit cm argocd-cm -n argocd` *and add* `data: timeout-reconciliation` *to be 10s*

— — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — —

**Example (optional step)**

\&gt; Edit argocd configmap yaml file `kubectl edit cm argocd-cm -n argocd`

\&gt; Add the `data: timeout-reconciliation` section and make it look like this

```go
apiVersion: v1
kind: ConfigMap
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"ConfigMap","metadata":{"annotations":{},"labels":{"app.kubernetes.io/name":"argocd-cm","app.kubernetes.io/part-of":"argocd"},"name":"argocd-cm","namespace":"argocd"}}
  creationTimestamp: "2024-08-26T21:20:54Z"
  labels:
    app.kubernetes.io/name: argocd-cm
    app.kubernetes.io/part-of: argocd
  name: argocd-cm
  namespace: argocd
  resourceVersion: "7318"
  uid: 6115ff37-28f1-4c0b-a477-b43f827cbb94
data:
  timeout.reconciliation: 10s
```

![](https://miro.medium.com/v2/resize:fit:700/1*2XPsFZBE_WPjebAbxbYPXA.png)

![](https://miro.medium.com/v2/resize:fit:700/1*N6pJ0CtWHZ5WNwCYpLOoGg.png)

Note: For `data.reconciliation` in production using `10s` is not ideal; the recommended is atleast `180s` which is `3mins` this is to enable ArgoCD have enough time to update and sync without giving too much pressure to the services.

— — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — —

c. &gt; View the App

![](https://miro.medium.com/v2/resize:fit:700/1*q57vBrXu9uhU_dT-ABO8pg.png)

Kubernetes will run into an error pulling the Image from the private repository. When you run the command `kubectl get pods` &gt; to see if all the pods are running or run the command to describe the errors `kubectl describe pod <pod name>`We can see the `ImagePullBackOff` error message more detailed

![](https://miro.medium.com/v2/resize:fit:700/1*o0U1uzwsur40ZwJ9euTI0Q.png)

When we check the ArgoCD `voteapp` details we can see the error too.

![](https://miro.medium.com/v2/resize:fit:700/1*vQI_giXOJrw3lNUB9Hv4pQ.png)

## **Step 6: Create an ACR imagePullSecret on AKS**

We can not be able to view the changes made to the `app` because the Kubernetes vote app `pod` will fail with error `ImagePullBackOff` , it means that Kubernetes tried to pull the image from the container registry but failed, and is now backing off (waiting before retrying) due to repeated failures.

![](https://miro.medium.com/v2/resize:fit:700/1*q57vBrXu9uhU_dT-ABO8pg.png)

To correct this we need to configure `ImagePullSecret` to point where kubernetes should pull the image from.

\&gt; In your azure portal, click on the `container registry` &gt; in the menu, click on settings &gt; click on `Access Keys` &gt; check `Admin User` &gt; copy the password

![](https://miro.medium.com/v2/resize:fit:700/1*zybZ1uBJjSTXztR8NJmFeg.png)

\&gt; Get a name for your secret, insert the details requested by the command and run it

```go
kubectl create secret docker-registry <secret-name> \
    --namespace <namespace> \
    --docker-server=<container-registry-name>.azurecr.io \
    --docker-username=<service-principal-ID> \
    --docker-password=<service-principal-password>
```

![](https://miro.medium.com/v2/resize:fit:700/1*USH-ANPYePXMRsNlc3eBFg.png)

\&gt; Edit the vote deployment file and add the newly created ACR Secret

in the azure devops portal &gt; go the repo and click on the `k8s-specifications` dir &gt; edit the `vote-deployment.yaml` and add `imagePullSecrets` section inside of it with the name of the secret created earlier. &gt; Commit the changes

![](https://miro.medium.com/v2/resize:fit:700/1*AIe7q_hqbzBlUGIUwJo64g.png)

run the command `kubectl get svc` to get the port number&gt; `kubectl get pods` to see if all the pods are running &gt; to access the page use the same node IP used for the argocd but this time you will be accessing the `voteapp` using the `vote pod` port `31000` *(make sure to add/pen this port number in your* `vmss` *inbound rule. just as we did for the argocd port number)*

![](https://miro.medium.com/v2/resize:fit:700/1*pt3lSOIatB1dutoN-Aapjw.png)

view the app using `http://<nodeip-address>:31000`

*( note: your port number maybe different than mine, do well to replace it)*

![](https://miro.medium.com/v2/resize:fit:700/1*nxS5rYUPVkPcR4_v35cDKw.png)

## **Step 7: Verify the CICD process**

In the `vote` dir in the Azure Repo, edit the `os.getenv` section of the `app.py` file. You can change the votes to something like (summer , winter) (Rain , Snow) (White , Black) etc. choose anything of your choice and commit the changes.

```go
from flask import Flask, render_template, request, make_response, g
from redis import Redis
import os
import socket
import random
import json
import logging
option_a = os.getenv('OPTION_A', "Rain")
option_b = os.getenv('OPTION_B', "Snow")
hostname = socket.gethostname()
app = Flask(__name__)
gunicorn_error_logger = logging.getLogger('gunicorn.error')
app.logger.handlers.extend(gunicorn_error_logger.handlers)
app.logger.setLevel(logging.INFO)
def get_redis():
    if not hasattr(g, 'redis'):
        g.redis = Redis(host="redis", db=0, socket_timeout=5)
    return g.redis
@app.route("/", methods=['POST','GET'])
def hello():
    voter_id = request.cookies.get('voter_id')
    if not voter_id:
        voter_id = hex(random.getrandbits(64))[2:-1]
    vote = None
    if request.method == 'POST':
        redis = get_redis()
        vote = request.form['vote']
        app.logger.info('Received vote for %s', vote)
        data = json.dumps({'voter_id': voter_id, 'vote': vote})
        redis.rpush('votes', data)
    resp = make_response(render_template(
        'index.html',
        option_a=option_a,
        option_b=option_b,
        hostname=hostname,
        vote=vote,
    ))
    resp.set_cookie('voter_id', voter_id)
    return resp

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True, threaded=True)
```

When this is done, the pipeline should trigger automatically

![](https://miro.medium.com/v2/resize:fit:700/1*nE_3wtEdPjaQRW1uh_xV9g.png)

\&gt; wait for the pipeline to finish running and lets verify the app is up and running, and also verify that the changes made to the `app`source code has been replicated in the `app` UI.

![](https://miro.medium.com/v2/resize:fit:700/1*3aQX54uy8R9MhBgvD-aoiQ.png)

## **This is the end of this project**

However; if you have followed carefully you must have noticed we have not set up the `updateK8sManifest.sh` stage pipeline for the `worker` and `result`. Do the same for this microservices just as we did for the `vote pipeline script` to have a full functioning app.

Add the `updateK8sManifest.sh` to `worker` and `result` pipelines

When you run the pipeline, just as we did for the `vote-deployment.yaml`it is important to update the `result-deployment.yaml` and `worker-deployment.yaml` files as well to include the `imagePullSecrets` . If this is not done, you will get the same error.

![](https://miro.medium.com/v2/resize:fit:700/1*TUSRk73EjmUUfBUNf_hjqA.png)

Make sure all pods are running

![](https://miro.medium.com/v2/resize:fit:700/1*ZHP1R27s8kdv7HjH_zhhdg.png)

Worker Pipeline Script

```go
trigger:
  paths:
    include:
      - worker

resources:
- repo: self

variables:
  dockerRegistryServiceConnection: 'ad3eca0a-4219-4a32-9df0-29fd9ba340b8'
  imageRepository: 'votingapp'
  containerRegistry: 'gabvotingappacr.azurecr.io'
  dockerfilePath: '$(Build.SourcesDirectory)/worker/Dockerfile'
  tag: '$(Build.BuildId)'

pool:
 name: 'voting-agent-app'

stages:
- stage: Build
  displayName: Build the voting App
  jobs:
  - job: Build
    displayName: Build

    steps:
    - task: Docker@2
      inputs:
        containerRegistry: '$(dockerRegistryServiceConnection)'
        repository: '$(imageRepository)'
        command: 'build'
        Dockerfile: 'worker/Dockerfile'
        tags: '$(tag)'

- stage: Push
  displayName: Push the voting App
  jobs:
  - job: Push
    displayName: Push

    steps:
    - task: Docker@2
      inputs:
        containerRegistry: '$(dockerRegistryServiceConnection)'
        repository: '$(imageRepository)'
        command: 'push'
        tags: '$(tag)'

- stage: Update_bash_script
  displayName: Update Bash Script
  jobs:
  - job: Updating_repo_with_bash
    displayName: Updating repo using bash script
    steps:
    - script: |
        # Convert line endings to Unix format
        dos2unix scripts/updateK8sManifests.sh

        # Run the shell script with the appropriate arguments
        bash scripts/updateK8sManifests.sh "worker" "$(imageRepository)" "$(tag)"
      displayName: Run UpdateK8sManifests Script

```

Result Pipeline Script

```go
trigger:
  paths:
    include:
      - result

resources:
- repo: self

variables:
  dockerRegistryServiceConnection: 'ad3eca0a-4219-4a32-9df0-29fd9ba340b8'
  imageRepository: 'votingapp'
  containerRegistry: 'gabvotingappacr.azurecr.io'
  dockerfilePath: '$(Build.SourcesDirectory)/result/Dockerfile'
  tag: '$(Build.BuildId)'

pool:
 name: 'voting-agent-app'

stages:
- stage: Build
  displayName: Build the voting App
  jobs:
  - job: Build
    displayName: Build

    steps:
    - task: Docker@2
      inputs:
        containerRegistry: '$(dockerRegistryServiceConnection)'
        repository: '$(imageRepository)'
        command: 'build'
        Dockerfile: 'result/Dockerfile'
        tags: '$(tag)'

- stage: Push
  displayName: Push the voting App
  jobs:
  - job: Push
    displayName: Push

    steps:
    - task: Docker@2
      inputs:
        containerRegistry: '$(dockerRegistryServiceConnection)'
        repository: '$(imageRepository)'
        command: 'push'
        tags: '$(tag)'

- stage: Update_bash_script
  displayName: Update Bash Script
  jobs:
  - job: Updating_repo_with_bash
    displayName: Updating repo using bash script
    steps:
    - script: |
        # Convert line endings to Unix format
        dos2unix scripts/updateK8sManifests.sh

        # Run the shell script with the appropriate arguments
        bash scripts/updateK8sManifests.sh "result" "$(imageRepository)" "$(tag)"
      displayName: Run UpdateK8sManifests Script
```

To check the votes, run the following commands . We can check for the `votes count` in either `redis` or `db` .

![](https://miro.medium.com/v2/resize:fit:700/1*2eaL5kjNkLcNTz2vS7gixA.png)

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
