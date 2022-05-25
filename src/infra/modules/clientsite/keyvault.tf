# client site key vault used to store secrets
resource "azurerm_key_vault" "clientsite" {
  name                        = substr("${azurerm_resource_group.clientsite.name}-kv", 0, 22)
  location                    = azurerm_resource_group.clientsite.location
  resource_group_name         = azurerm_resource_group.clientsite.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
}

# Give KV secret permissions to the service principal that runs the Terraform apply itself
resource "azurerm_key_vault_access_policy" "devops_pipeline" {
  key_vault_id = azurerm_key_vault.clientsite.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get", "List", "Delete", "Purge", "Set", "Backup", "Restore", "Recover"
  ]
}

# Storage adminpassword for client vm (quagga) in azure key vault
resource "azurerm_key_vault_secret" "clientvm_admin_password" {
  name         = "clientvm-admin-password"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.clientsite.id

  depends_on = [
    azurerm_key_vault_access_policy.devops_pipeline
  ]
}