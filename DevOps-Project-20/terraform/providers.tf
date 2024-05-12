terraform {
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