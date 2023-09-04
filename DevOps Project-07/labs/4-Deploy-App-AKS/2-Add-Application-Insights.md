# Add Application Insights to Terraform

Application Insights will be used to monitor the application once deployed!

1. Deploy Application Insights using this module: 

- [Application Insights](labs/4-Deploy-App-AKS/terraform/modules/appinsights)

2. Update main.tf with [Application Insights Module](labs/4-Deploy-App-AKS/terraform/main.tf#L71-L77)


3. Update [variables.tf](labs/4-Deploy-App-AKS/terraform/variables.tf#L76-L84)


4. Add new .tfvars to [this](labs/4-Deploy-App-AKS/vars/production.tfvars#L23-L25)

`app_insights_name = "devopsjourney"\
 application_type  = "web"`

5. Edit your Azure DevOps pipeline to run this [Pipeline](labs/4-Deploy-App-AKS/pipelines/lab4pipeline.yaml)
