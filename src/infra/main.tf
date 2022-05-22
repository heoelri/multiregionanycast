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
  features {
      key_vault {
      recover_soft_deleted_key_vaults       = true
      purge_soft_delete_on_destroy          = false # required when purge is not possible
      purge_soft_deleted_secrets_on_destroy = false # required when purge is not possible
    }
  }
}

