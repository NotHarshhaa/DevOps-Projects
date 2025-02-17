# Azure DevOps pipeline + Terraform Deployment Tutorial

![None](https://miro.medium.com/v2/resize:fit:700/0*5iGW5XrxHIeZb-eX.png)

## In-depth guide to using Azure DevOps to deploy Terraform code to Azure

Recently needed to use Terraform to deploy Azure services via Azure DevOps.

Having focused on Bicep for the past couple of years, it's been a while since I've used Terraform, so I was looking for a quick example Azure DevOps (ADO) deployment pipeline.

There are some good references out there, but I felt most of them skimmed over some key configuration, such as Azure subscription permissions or ADO secrets.

This guide will cover everything required to deploy an example Azure Service Bus instance via Terraform and ADO.

In addition to creating an example pipeline, we'll also add enhanced capabilities, including -

* Hosting the Terraform backend state on Azure blob storage

* Creating a deployment Service Principal + setting RBAC permissions on the Azure subscription

* Create a multi-stage ADO pipeline with an approval step

* Demonstrating how we can scale with multiple deployments


> *If you'd like to skip straight to the download of the example pipeline and Terraform code, it can be found on* [*GitHub*](https://github.com/NotHarshhaa/DevOps-Projects/tree/master/DevOps-Project-20/terraform)*.*

### **Overall Topology**

In this diagram, we can see all of the different supporting components required to deploy the Terraform code and the actual Service Bus instance itself -

![None](https://miro.medium.com/v2/resize:fit:700/0*5iGW5XrxHIeZb-eX.png)

There are a couple of things worth highlighting -

* **ADO build agent** — more advanced deployment scenarios sometimes require the use of self-hosted agents due to network or security requirements. But for simplicity, we'll use the ADO-hosted Linux (Ubuntu) build agent, which already has Terraform installed.

* **Git repo** — all of the pipeline config and Terraform code is hosted in a single ADO Git repo

* **Terraform state file** — the state file is hosted in the same Azure subscription, but this could be located on any storage account (permissions permitting)

* **Azure resource group** — the target resource group for the Service Bus instance is *env01-tfdemo-rg*. This will also be created by Terraform.


For easy reference, these are the files we'll be working with -

![None](https://miro.medium.com/v2/resize:fit:700/0*HD9rHU2N71ryGAuW.png)

> *The pipeline yaml definitions can reside anywhere within our repo but I prefer to store them in a /deploy folder.*

Okay, let's get into it!

### **Create the Service Principal**

First things first, a Service Principal (SPN) is required to allow Terraform on the ADO build agent to authenticate against the Azure subscription and create Azure resources -

* Within the Azure Portal, open **Microsoft Entra ID**

* Create a new **App registration**, *tfdemo-spn* (accept the default settings)

* Make a note of the *Application (client) ID* and *Directory (tenant) ID* as we'll need these later

* Under Certificates & Secrets, create a new secret called *ADO*. Make a note of this value, too.


![None](https://miro.medium.com/v2/resize:fit:700/0*TcXK0wSIBfL2De7I.png)

### **Create the Terraform State Storage Account**

Terraform stores its view of our infrastructure and associated metadata in a [state](https://developer.hashicorp.com/terraform/language/state) file. The state file is central to Terraform's operation and must be stored in an appropriate location.

Storing the state file locally is fine for basic testing, but for automated deployments, it must be hosted somewhere the ADO build agent can access. Typically, this is an Azure blob storage account (or an S3 bucket if you're using AWS).

The steps below describe how to implement this part of the configuration (this is completed manually). Within the Azure Portal -

* Create a new resource group, *tfstate-tfdemo-rg*

* Create a new storage account, *tfstatedemostg* (accept all default configuration settings)

* Create a *tfstate* blob container.


![None](https://miro.medium.com/v2/resize:fit:700/0*M2hk7fQjuvsZFPMV.png)

* Under **Access Control (IAM)** for the storage account, grant the *Storage Blob Data Contributor* role to the SPN


![None](https://miro.medium.com/v2/resize:fit:700/0*aNWzEt0OhbJ2I03U.png)

There's no need to manually create the tfstate file. This will be automatically be created when Terraform first runs within the pipeline.

### **Set Azure Subscription Permissions**

In the above step, we granted the SPN permission to write the *tfstate* file to the storage account. The SPN also needs additional permissions to deploy the Azure resources in the wider subscription.

Setting appropriate SPN permissions is a topic in itself, but for now, we'll grant the SPN *Contributor* permissions on the entire subscription. This allows Terraform on the build agent to create the *env01-tfdemo-rg* resource group and the Service Bus resources inside it -

1. Within the Azure Portal, browse to the target subscription

2. Select **Access control (IAM)**

3. Create a new **role assignment** and assign the SPN the *Contributor* role


![None](https://miro.medium.com/v2/resize:fit:700/0*A4td9JJmFUWkEgdj.png)

> *An alternate approach is to pre-create the target resource group. This allows the SPN permissions to be more tightly scoped to the existing resource group instead of the entire subscription.*

### **Create the Service Bus Terraform Code**

In this example, we'll keep it nice and simple and deploy a Service Bus namespace and two queues. This is the Terraform code, *servicebus.tf* -

```yaml
Copy# Service Bus - namespace
resource "azurerm_servicebus_namespace" "sbus" {
  name                = "${var.project}-${var.environment}-sbns"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  
  tags = local.tags
  
  local_auth_enabled            = false
  minimum_tls_version           = "1.2"
  network_rule_set {
    default_action                = "Allow"      
    public_network_access_enabled = true
    trusted_services_allowed      = false
  }
  public_network_access_enabled = true
  sku                           = "Standard"
}

# Service Bus - queue01
resource "azurerm_servicebus_queue" "queue01" {
  name         = "queue01"
  namespace_id = azurerm_servicebus_namespace.sbus.id

  default_message_ttl                     = "P14D"
  dead_lettering_on_message_expiration    = false
  duplicate_detection_history_time_window = "PT10M"
  enable_batched_operations               = true
  enable_partitioning                     = false
  lock_duration                           = "PT1M"
  max_delivery_count                      = 10
  max_size_in_megabytes                   = 1024
  requires_duplicate_detection            = false
  requires_session                        = false
}

# Service Bus - queue02
resource "azurerm_servicebus_queue" "queue02" {
  name         = "queue02"
  namespace_id = azurerm_servicebus_namespace.sbus.id

  default_message_ttl                     = "P14D"
  dead_lettering_on_message_expiration    = false
  duplicate_detection_history_time_window = "PT10M"
  enable_batched_operations               = true
  enable_partitioning                     = false
  lock_duration                           = "PT1M"
  max_delivery_count                      = 10
  max_size_in_megabytes                   = 1024
  requires_duplicate_detection            = false
  requires_session                        = false
}
```

Also of interest is the *providers.tf* file. Here, we can see that the state file is configured to be hosted on the storage account we created earlier -

```yaml
Copyterraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate-tfdemo-rg"
    storage_account_name = "tfstatetfdemostg"
    container_name       = "tfstate"
    key                  = "tfdemo.env01.tfstate"
  }
}

provider "azurerm" {
  features {}
}
```

The full Terraform code can be found on [GitHub](https://github.com/andrew-kelleher/terraformadopipeline) and includes the additional files, such as *tfdemo.env01.tfvars* which defines the resource names.

### **Configure Azure DevOps**

Within ADO, we need to configure a couple of things to get everything working.

#### **Create a Variable Group**

The variable group contains the details of the Service Principal we created earlier. Terraform will use these values to authenticate against the target Azure subscription -

* Create a variable group, *Terraform\_SPN* , within **Pipelines → Library**

* Create the following variables using the SPN's values from earlier

* **ARM\_CLIENT\_ID**

* **ARM\_CLIENT\_SECRET**

* **ARM\_SUBSCRIPTION\_ID**

* **ARM\_TENANT\_ID**


> *These variable names are of special* [*significance*](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret#configuring-the-service-principal-in-terraform) *to Terraform. When set as environment variables within the ADO build agent, Terraform will automatically attempt to authenticate against Azure using their values.*

Your variable group should look something like this -

![None](https://miro.medium.com/v2/resize:fit:700/0*m3N_RVVxm9WznDRg.png)

#### **Create the ADO Environment**

By creating an ADO [environment](https://techcommunity.microsoft.com/t5/healthcare-and-life-sciences/azure-devops-pipelines-environments-and-variables/ba-p/3707414) and referencing it within our pipeline, we can add an approval step.

When deploying the pipeline, we want an opportunity to review the output from the **Terraform Plan** stage. Only once we're comfortable with the planned changes do we approve the **Terraform Apply** stage to create the resources.

To create an ADO environment -

* Within **Pipelines → Environments** select **New Environment**

* Set the name as *env01* and click **Create**

* Once created, select **Approvals and Checks** and click "**+**"


![None](https://miro.medium.com/v2/resize:fit:700/0*lwx6MDC8kbvKvkoY.png)

* Select **Next** and add the required approver, i.e. ourselves (fine-tune these settings as required for your organization)


![None](https://miro.medium.com/v2/resize:fit:700/0*aVMcQ_NuQ6cXCWC3.png)

The created environment…

![None](https://miro.medium.com/v2/resize:fit:700/0*Z1LsCoH66MgO41gZ.png)

#### **Create the Pipeline**

For this example, I'm leveraging an Azure DevOps yaml [template](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/templates?view=azure-devops&pivots=templates-includes). If we wish to later scale out our deployments with multiple environments, etc., it is much easier to create a single reusable Terraform deployment pipeline.

First, the template deployment pipeline definition, *terraform-template.yml* -

```yaml
Copyparameters:
- name: rootFolder
  type: string
- name: tfvarsFile
  type: string
- name: adoEnvironment
  type: string

stages:
- stage: 'Terraform_Plan'
  displayName: 'Terraform Plan'
  jobs:
  - job: 'Terraform_Plan'
    pool:
      vmImage: 'ubuntu-latest'
    steps:
    - script: |
        echo "Running Terraform init..."
        terraform init
        echo "Running Terraform plan..."
        terraform plan -var-file ${{ parameters.tfvarsFile }}
      displayName: 'Terraform plan'
      workingDirectory: ${{ parameters.rootFolder }}
      env:
        ARM_CLIENT_SECRET: $(ARM_CLIENT_SECRET) # this needs to be explicitly set as it's a sensitive value

- stage: 'Terraform_Apply'
  displayName: 'Terraform Apply'
  dependsOn:
  - 'Terraform_Plan'
  condition: succeeded()
  jobs:
  - deployment: 'Terraform_Apply'
    pool:
      vmImage: 'ubuntu-latest'
    environment: ${{ parameters.adoEnvironment }} # using an ADO environment allows us to add a manual approval check
    strategy:
      runOnce:
        deploy:
          steps:
          - checkout: self
          - script: |
              echo "Running Terraform init..."
              terraform init
              echo "Running Terraform apply..."
              terraform apply -var-file ${{ parameters.tfvarsFile }} -auto-approve
            displayName: 'Terraform apply'
            workingDirectory: ${{ parameters.rootFolder }}
            env:
              ARM_CLIENT_SECRET: $(ARM_CLIENT_SECRET)
```

… and the pipeline definition, *tfdemo-env01-terraform.yml*, for our specific deployment (*tfdemo-env01-rg*) that calls the template above -

```yaml
Copyname: Terraform - deploy Service Bus to env01

trigger: none

variables:
  - group: Terraform_SPN
  - name: rootFolder
    value: '/terraform/'
  - name: tfvarsFile
    value: 'tfdemo.env01.tfvars'
  - name: adoEnvironment
    value: 'env01'
  
stages:
- template: templates/terraform-template.yml
  parameters:
    rootFolder: $(rootFolder)
    tfvarsFile: $(tfvarsFile)
    adoEnvironment: $(adoEnvironment)
```

To create the pipeline -

* **Pipelines → New pipeline**

* Select **Azure Repos Git**

* Select the repo, i.e. *tfdemo*


![None](https://miro.medium.com/v2/resize:fit:700/0*yY-R-oUlT_HlVX7J.png)

* Select **Existing Azure Pipelines YAML** file. *Note — we select the pipeline .yml rather than the template .yml*


![None](https://miro.medium.com/v2/resize:fit:700/0*9o7gmDvrioFMgTh7.png)

* From the **Run** dropdown, select **Save**


![None](https://miro.medium.com/v2/resize:fit:700/0*T5kb7_y4Q6Noot5l.png)

* The default pipeline name of *tfdemo* is fine, but this can be renamed to something more meaningful, i.e. *tfdemo-env01-terraform*


Browsing our list of pipelines, our newly created pipeline is now visible -

![None](https://miro.medium.com/v2/resize:fit:700/0*y_2ke5BSfJ4SWxe4.png)

That's it! We've created a new pipeline, the variable group and ADO environment.

### **Run and Test the Pipeline**

Finally, we're ready to run the pipeline and deploy our Service Bus instance for the first time.

After the pipeline has completed the *Terraform\_Plan* stage, we can validate what Terraform expects to deploy. As the Service Bus instance doesn't yet exist, it correctly states that it will be created -

![None](https://miro.medium.com/v2/resize:fit:700/0*PwxzGCYXsD6Gx4mt.png)

Now we've satisfied ourselves that the *Terraform\_Plan* stage is correct, click **Review** and **Approve** on the *Terraform\_Apply* stage.

The pipeline takes a few minutes to complete -

![None](https://miro.medium.com/v2/resize:fit:700/0*1dUp-tbM2maDzGay.png)

…and the resource group and Service Bus instance are created successfully -

![None](https://miro.medium.com/v2/resize:fit:700/0*7LhlW8AthtNelYR8.png)

On the first run of the pipeline, you will be prompted to grant access to the *Terraform\_SPN* variable group and the *ENV01* environment. Just click **Permit** when prompted.

### **Scaling the Deployment**

In this example, we've deployed a single resource group with limited resources. But it's possible quite easily to scale this approach.

For example, imagine the scenario where we must deploy an application hosting environment. Depending on the application, this could include a multitude of Azure services such as an AKS cluster, storage accounts, Application Gateway, VNET, Azure SQL databases, etc.

These services can all be deployed to the same resource group to provide a self-contained hosting environment, i.e. DEV. We can then take this a step further by deploying additional environments, i.e. UAT, PROD, etc., by reusing the same Terraform and pipeline definitions.

The key to making this work is *parameterising everything* within the Terraform and pipeline definitions.

The diagram below shows how, by copying/pasting our existing definitions, and updating a few key values within them, replica environments can easily be deployed.

![None](https://miro.medium.com/v2/resize:fit:700/0*BuyRRwrLmfHWVqnO.png)

### **Conclusion**

I hope you found this post useful. In this example, we deployed a simple Terraform definition for an Azure Service Bus instance using an ADO pipeline. This Terraform code can easily be extended to deploy additional Azure services as required.

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
