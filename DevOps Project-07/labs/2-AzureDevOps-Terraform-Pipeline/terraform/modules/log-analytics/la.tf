resource "azurerm_resource_group" "kubernetes_resource_group" {
  location = var.location
  name     = "${var.log_analytics_workspace_name}-rg"
  tags = {
    Environment = var.environment
  }
}

resource "azurerm_log_analytics_workspace" "Log_Analytics_WorkSpace" {
    # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
    name                = var.log_analytics_workspace_name
    location            = var.location
    resource_group_name = azurerm_resource_group.kubernetes_resource_group.name
    sku                 = var.log_analytics_workspace_sku
      tags = {
    Environment = var.environment
  }
}

resource "azurerm_log_analytics_solution" "Log_Analytics_Solution_ContainerInsights" {
    solution_name         = "ContainerInsights"
    location              = azurerm_log_analytics_workspace.Log_Analytics_WorkSpace.location
    resource_group_name   = azurerm_resource_group.kubernetes_resource_group.name
    workspace_resource_id = azurerm_log_analytics_workspace.Log_Analytics_WorkSpace.id
    workspace_name        = azurerm_log_analytics_workspace.Log_Analytics_WorkSpace.name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}