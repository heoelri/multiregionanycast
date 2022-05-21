terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.7.0"
    }
    random = {
      version = ">= 2.2.1"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

data "azurerm_client_config" "current" {
}

# Random Pet Name (based on Resource Group Name)
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
