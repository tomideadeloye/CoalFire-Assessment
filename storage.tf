resource "azurerm_storage_account" "example" {
  name                     = "storaccexample"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier              = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action = "Deny"  # Add the default action here
    virtual_network_subnet_ids = [
      azurerm_subnet.subnet1.id
    ]
  }
}

