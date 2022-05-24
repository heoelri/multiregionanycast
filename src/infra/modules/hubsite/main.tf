data "azurerm_client_config" "current" {
}

# generate random password
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"

  keepers = {
    value = azurerm_resource_group.hubsite.name # generate once 
  }
}

resource "random_id" "suffix" {
  keepers = {
    value = azurerm_resource_group.hubsite.name # generate once 
  }

  byte_length = 8
}

# generate private key for routernva vm ssh access
resource "tls_private_key" "routernv_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_resource_group" "hubsite" {
  name     = "hub-site-${var.location}"
  location = var.location
}