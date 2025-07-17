# Step-by-Step Guide to Creating Your Own Self-Hosted Build Agent for Azure CI/CD Pipeline Using an Azure Virtual Machine

In this detailed guide, we will walk you through the entire process of setting up your own self-hosted build agent for an Azure Continuous Integration and Continuous Deployment (CI/CD) pipeline. This involves utilizing an Azure Virtual Machine (VM) to host your build agent. By following these steps, you will gain a deeper understanding of how to effectively manage and customize your build environment, which can lead to improved performance and greater control over your CI/CD processes.

![](https://miro.medium.com/v2/resize:fit:700/1*_x5ueAHm6iv13_94TpHETg.png)

Instead of using the agents recommended by Microsoft, there may be times when you need more control over these agents, such as the type of image they use, the image version required, scalability, and security. In such cases, you might need your own customized agents to better meet your application's needs.

Choosing to use self-hosted agents in Azure DevOps is about gaining more control and customization over the build and deployment environment, ensuring it fits your application's unique requirements. A self-hosted agent can run on Windows, Linux, macOS, or in a Docker container.

For this project, we will deploy our self-hosted agent on an Azure VM.

Step 1: Configure a Self-Hosted Agent

Step 2: Create an Azure VM

Step 3: Create a Personal Access Token (PAT)

Step 4: Log into the Azure VM and Configure the Self-Hosted Agent

## **Step 1: Configure a Self-Hosted Agent**

Make sure you already created a new project for this purpose; in this case mine is `Self-hosted-project-demo` , you can give it any name you deem fit.

![](https://miro.medium.com/v2/resize:fit:700/1*phxpRrSKzW3pmFMzd2VhLA.gif)

* Go to the Azure DevOps dashboard — [https://dev.azure.com/](https://dev.azure.com/)

* Select your project dashboard: Choose the new project you just created.

* Go to your project settings: Scroll down to the bottom of the left menu to find it.

* From the menu on the left, click on Agent pools: This is where you set up your own pool of agents to run jobs.

* Create a new Agent pool by clicking on `Add Pool` &gt; for "pool to link," select `New` &gt; for "Pool type," select `Self hosted` &gt; give it a name like `Ubuntu-Agent-Pool`, and you can add a description &gt; Make sure to check `Grant access permission to all pipelines` &gt; Finally, click on `Create`.

* Click on the newly created pool `Ubuntu-Agent-Pool` &gt; Click `New Agent` &gt; Click on `Linux` &gt; You can download or copy the configuration file *(For this project, I will be using the copied configuration file)*.

![](https://miro.medium.com/v2/resize:fit:700/1*wDGQW66Mkaf-8wdLnCG0Ow.png)

Copy the configuration

This is my copied configuration link.

```bash
https://vstsagentpackage.azureedge.net/agent/3.232.1/vsts-agent-linux-x64-3.232.1.tar.gz
```

Login to your Azure VM now. Well, if you haven’t created your Azure VM yet like me, lets do that now.

## **Step 2: Create an Azure VM**

It is pretty straight forward on how to create an Azure VM

![](https://miro.medium.com/v2/resize:fit:700/1*SmP-WU2FbdiTTBwE8KDiBA.gif)

* Go to portal.azure.com, search for `Virtual Machines`, and click on Create.

* Create a `Resource Group` if you don’t have one already. Enter the VM name `UbuntuagentVM`. For “Image,” use `Ubuntu:20`. I will leave everything else as default. Download the private key and click `Create`.

Ensure that SSH inbound port 22 is open (it's usually open by default for Linux machines), as we need this to access the VM. The downloaded private key allows us to have SSH access to the machine.

![](https://miro.medium.com/v2/resize:fit:700/1*EaBnCnHZSLS_xzSDLL4jWQ.png)

Downloaded private key

## **Step 3: Create a Personal Access Token (PAT)**

A PAT, or Personal Access Token, is a string of digits used to provide secure access to Azure DevOps for a hosted or self-hosted agent. It plays a crucial role in registering and authenticating the agent with Azure DevOps, ensuring secure communication and authorization for various tasks within the DevOps environment.

![](https://miro.medium.com/v2/resize:fit:700/1*5QfHklho-u0WQoI0u0mYiQ.gif)

Create a Personal Access Token for authentication to Azure DevOps

## **Step 4: Log into the Azure VM and Configure the Self-Hosted Agent**

In this section, we will be log into the Azure VM we created earlier through SSH. After the login, we will proceed by configuring for the Self-Hosted Agent using the configuration files genereted when creating the agent pool.

![](https://miro.medium.com/v2/resize:fit:1152/1*Y4C_E8Newz5K8cVRhvIIGQ.gif)

![](https://miro.medium.com/v2/resize:fit:1152/1*ZS6sld5KNEdLnOO5Gg8stQ.gif)

Here is a snippet of the code and steps used to configure the self-hosted Ubuntu agent.

* Go to the directory where you downloaded the unique `./ubuntuagentVM_key.pem`. In my case, I downloaded it into my `./downloads` folder. This is important because you need the key to access your Azure VM.

```bash
cd ./downloads
```

* Login into the Azure VM created earlier and copy its IP

```bash
ssh -i ubuntuagentVM_key.pem azureuser@40.124.173.167
```

* Create the Agent

```bash
mkdir myagent && cd myagent
```

* Download the unique agent configuration link

```bash
wget https://vstsagentpackage.azureedge.net/agent/2.214.1/vsts-agent-linux-x64-2.214.1.tar.gz
```

* Extract the files and Configure the Agent

```bash
tar zxvf vsts-agent-linux-x64-2.214.1.tar.gz
```

* List the files in the directory after extracting.

```bash
ls -al
```

* Run the below command

```bash
./config.sh
```

* Accept the Team Explorer Everywhere license agreement now?  
    Type Y and press enter.

* Enter server URL &gt; [https://dev.azure.com/yourorganization](https://dev.azure.com/yourorganization)

* Enter authentication type (press enter for PAT) &gt; PAT

* Copy and paste the personal access token generated earlier in step 3.

* Enter Agent pool &gt; Copy and paste the name `Ubuntu-Agent-Pool` from the agent pool created earlier and press enter.

* Enter Agent name &gt; Give it a name like `myBuildAgent_1` and press enter.

* Enter work folder &gt; You can give it a name or leave it as default by pressing enter.

**Congrats, you have successfully configured a self-hosted agent**

* Configure the Agent to run as a Service


```bash
sudo ./svc.sh install &
```

* Execute now to run as a service


```bash
./runsvc.sh &
```

* The agent should now be listening for pods


***This confirms that Build agent is successfully configured in Azure DevOps and is available to run builds***

* You can also check the status of build Agent &gt; Click on the `ubuntu-agent-pool` &gt; Click on Agents


![](https://miro.medium.com/v2/resize:fit:700/1*XjfE1Fcmlg4HbM-8fKcOEA.png)

Confirm the status of your agent is showing online

### **Congratulations! We have reached the end of this project.**
