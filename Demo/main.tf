########### Terraform Init ###########

## Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  backend "artifactory" {
    url     = "https://repos.medcity.net/repository"
    repo    = "HRGDemoDev"
    subpath = "dev"
  }
}


##Configure the provider with github

provider "azurerm" {
  features {}

  tenant_id       = var.AZURE_TENANT_ID
  subscription_id = var.AZURE_SUBSCRIPTION_ID
  client_id       = var.AZURE_CLIENT_ID
  client_secret   = var.AZURE_CLIENT_SECRET
}

## creating resource grp

resource "azurerm_resource_group" "hrg-hri-dev" {
  name     = "hrg-hri-dev"
  location = "East US 2"
}


## creating storage account

resource "azurerm_storage_account" "hrghrisadev" {
  name                     = "hrghrisadev"
  resource_group_name      = "hrg-hri-dev"
  location                 = "East US 2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"

  tags = {
    "cost_center"   = var.HCA_COST_CENTER
    "app_code"      = var.HCA_APP_CODE
    "department_id" = var.HCA_DEPARTMENT_ID
    "cost_id"       = var.HCA_COST_ID
  }
}

## creating Storage container

resource "azurerm_storage_container" "hridatamodel" {
  name                  = "hridatamodel"
  storage_account_name  = azurerm_storage_account.hrghrisadev.name
  container_access_type = "private"
}


##Creating Azure Data Factory

resource "azurerm_data_factory" "hrghriadfdev" {
  name                = "hrghriadfdev"
  resource_group_name = "hrg-hri-dev"
  location            = "East US 2"

  github_configuration {
    account_name    = "HCAHRGAnalytics"
    branch_name     = "dev"
    repository_name = "azure-data-factory"
    root_folder     = "/"
    git_url         = "https://github.com"
  }

  tags = {
    "cost_center"   = var.HCA_COST_CENTER
    "app_code"      = var.HCA_APP_CODE
    "department_id" = var.HCA_DEPARTMENT_ID
    "cost_id"       = var.HCA_COST_ID
  }
}

##Creating Azure mssql server

resource "azurerm_mssql_server" "example" {
  name                         = "HCAsqlserver"
  resource_group_name          = "hrg-hri-dev"
  location                     = "East US 2"
  version                      = "12.0"
  administrator_login          = "Admin"
  administrator_login_password = "12345"
}

##Creating Azure mssql server data base

resource "azurerm_sql_database" "example" {
  name                = "hcasqldatabase"
  resource_group_name = "hrg-hri-dev"
  location            = "East US 2"
  server_name         = "HCAsqlserver"

#   extended_auditing_policy {
#     storage_endpoint                        = azurerm_storage_account.example.primary_blob_endpoint
#     storage_account_access_key              = azurerm_storage_account.example.primary_access_key
#     storage_account_access_key_is_secondary = true
#     retention_in_days                       = 6
  }

##Creating Azure Data Lake

resource "azurerm_data_lake_store" "example" {
  name                = "HCAdatalake"
  resource_group_name = "hrg-hri-dev"
  location            = "East US 2"
  encryption_state    = "Enabled"
  encryption_type     = "ServiceManaged"
}



