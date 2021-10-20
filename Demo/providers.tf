provider "azurerm" {
  
  subscription_id = var.var_subscription_id
    client_id = var.var_client_id
    tenant_id = var.var_tenant_id
    client_secret = var.var_client_secret
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.50.0"
      
    }
  }
}
