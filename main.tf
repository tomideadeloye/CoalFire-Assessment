provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "rg" {
  name     = "poc-rg"
  location = "East US"
}
