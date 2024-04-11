
module "loganalytics" {
  source                       = "./modules/log-analytics"
  log_analytics_workspace_name = var.log_analytics_workspace_name
  location                     = var.location
  log_analytics_workspace_sku  = "PerGB2018"
  environment = var.environment
}

module "vnet_aks" {
  source                      = "./modules/vnet"
  name                        = var.vnet_name
  location                    = var.location
  network_address_space       = var.network_address_space
  aks_subnet_address_prefix   = var.aks_subnet_address_prefix
  aks_subnet_address_name     = var.aks_subnet_address_name
  appgw_subnet_address_prefix = var.appgw_subnet_address_prefix
  appgw_subnet_address_name   = var.appgw_subnet_address_name
  environment = var.environment
}

module "aks" {
  source                     = "./modules/aks"
  name                       = var.aks_name
  kubernetes_version         = var.kubernetes_version
  agent_count                = var.agent_count
  vm_size                    = var.vm_size
  location                   = var.location
  ssh_public_key             = var.ssh_public_key
  log_analytics_workspace_id = module.loganalytics.id
  aks_subnet                 = module.vnet_aks.aks_subnet_id
  agic_subnet_id             = module.vnet_aks.appgw_subnet_id
  environment = var.environment

  addons = {
    oms_agent                   = true
    azure_policy                = false
    ingress_application_gateway = true
  }

}

module "acr" {
  source   = "./modules/acr"
  name     = var.acr_name
  location = var.location
  environment = var.environment
}
