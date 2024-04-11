# Setup Azure DevOps Pipeline
Time to setup Azure DevOps to deploy your Terraform into Azure.

1. Install the Terraform extension/task from [here](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks) into your Azure DevOps organisation

The Terraform task enables running Terraform commands as part of Azure Build and Release Pipelines providing support for the following Terraform commands

- init
- validate
- plan
- apply
- destroy

2. Create Azure repository - select Repos & you will see various options to setup a respository (This repository will store code throughout further labs also, please note this!)

3. Copy contents from this folder into the newly created Azure DevOps repository

4. Once copied to Azure DevOps repository, Select **Repo** -> **Setup Build**

5. Select **Existing Azure Pipelines YAML file** and branch  / path to the .yaml Azure DevOps Pipeline

![](images/azuredevops-terraform-pipeline.png)

6. Save pipeline and run

![](images/azuredevops-terraform-pipeline-2.png)