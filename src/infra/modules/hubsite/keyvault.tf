# hub site key vault used to store secrets
resource "azurerm_key_vault" "hubsite" {
  name                        = "${azurerm_resource_group.hubsite.name}-kv"
  location                    = azurerm_resource_group.hubsite.location
  resource_group_name         = azurerm_resource_group.hubsite.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
}

# Give KV secret permissions to the service principal that runs the Terraform apply itself
resource "azurerm_key_vault_access_policy" "devops_pipeline" {
  key_vault_id = azurerm_key_vault.hubsite.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get", "List", "Delete", "Purge", "Set", "Backup", "Restore", "Recover"
  ]
}

# Storage adminpassword for router nva (quagga) in azure key vault
#resource "azurerm_key_vault_secret" "nva_admin_password" {
#  name         = "nva-admin-password"
#  value        = random_password.password.result
#  key_vault_id = azurerm_key_vault.hubsite.id

#  depends_on = [
#    azurerm_key_vault_access_policy.devops_pipeline
#  ]
#}

# Storage ssh private key for router nva (quagga) in azure key vault
resource "azurerm_key_vault_secret" "nva_privatekey" {
  name         = "nva-adminuser-privatekey"
  value        = trimspace(tls_private_key.routernv_private_key.private_key_openssh)
  key_vault_id = azurerm_key_vault.hubsite.id

  depends_on = [
    azurerm_key_vault_access_policy.devops_pipeline
  ]
}