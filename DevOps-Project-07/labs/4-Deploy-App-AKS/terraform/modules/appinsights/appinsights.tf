data "azurerm_resource_group" "appinsightsrg" {
  name = "${var.name}-rg"
}

resource "azurerm_application_insights" "appinsights" {
  name                = "${var.name}-rg"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.appinsightsrg.name
  application_type    = var.application_type
}