output "aks_subnet_id" {
  value = azurerm_subnet.aks_subnet.id
}

output "appgw_subnet_id" {
  value = azurerm_subnet.appgw_subnet.id
}

output "vnet_id" {
  value = azurerm_virtual_network.virtual_network.id
}

output "vnet_name" {
  value = azurerm_virtual_network.virtual_network.name
}

output "resource_group" {
  value = azurerm_resource_group.vnet_resource_group.name
}

output "resource_group_id" {
  value = azurerm_resource_group.vnet_resource_group.id
}