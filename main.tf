terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.47.00"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "orbittask" {
  name     = var.resourcegroup_name
  location = var.location
}

resource "azurerm_storage_account" "orbittask" {
  name                     = var.str_account_name
  resource_group_name      = azurerm_resource_group.orbittask.name
  location                 = azurerm_resource_group.orbittask.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "orbittask" {
  name                = var.app_service_plan
  location            = azurerm_resource_group.orbittask.location
  resource_group_name = azurerm_resource_group.orbittask.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "orbittask" {
  name                       = var.function_app
  location                   = azurerm_resource_group.orbittask.location
  resource_group_name        = azurerm_resource_group.orbittask.name
  app_service_plan_id        = azurerm_app_service_plan.orbittask.id
  storage_account_name       = azurerm_storage_account.orbittask.name
  storage_account_access_key = azurerm_storage_account.orbittask.primary_access_key
  os_type                    = "linux"
  version                    = "~4"

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "powershell"
    WEBSITE_RUN_FROM_PACKAGE = 1
  }
}

resource "azurerm_app_service_slot" "orbittask" {
  name                = "staging"
  app_service_name    = azurerm_function_app.orbittask.name
  location            = azurerm_resource_group.orbittask.location
  resource_group_name = azurerm_resource_group.orbittask.name
  app_service_plan_id = azurerm_app_service_plan.orbittask.id
}
