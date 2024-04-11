# Deploy sample Application to AKS

This lab is to deploy the Azure Voting App to AKS using ACR Image

1. For AKS to be able to pull images from ACR, you will need to add the below to the main.tf terraform file

```
resource "azurerm_role_assignment" "aks-acr-rg" {
  scope                = module.acr.resource_group_id
  role_definition_name = "Acrpull"
  principal_id         = module.aks.kubelet_object_id

  depends_on = [
     module.aks,
     module.acr
  ]
}
```

1. Edit your Azure DevOps pipeline to run this [Pipeline](labs/4-Deploy-App-AKS/pipelines/lab4pipeline.yaml)