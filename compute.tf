# Availability Set
resource "azurerm_availability_set" "example" {
  name                         = "availset-example"
  resource_group_name      = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  managed                      = true
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
}

# Network Interface for Subnet1
resource "azurerm_network_interface" "nic_sub1" {
  name                = "nic-sub1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id  
    private_ip_address_allocation = "Dynamic"
  }
}


# Virtual Machine 1 in Subnet1
resource "azurerm_virtual_machine" "vm_sub1_1" {
  name                  = "vm-sub1-1"
  resource_group_name      = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  availability_set_id   = azurerm_availability_set.example.id
  vm_size = "Standard_DS1_v2"
  network_interface_ids = [azurerm_network_interface.nic_sub1.id]
  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7.9"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk-sub1-1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    disk_size_gb      = 32
  }

  tags = {
    environment = "production"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }
}

# Virtual Machine 2 in Subnet1
resource "azurerm_virtual_machine" "vm_sub1_2" {
  name                  = "vm-sub1-2"
   resource_group_name      = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  availability_set_id   = azurerm_availability_set.example.id
  vm_size = "Standard_DS1_v2"
  network_interface_ids = [azurerm_network_interface.nic_sub1.id]
  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7.9"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk-sub1-2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    disk_size_gb      = 32
  }

  tags = {
    environment = "production"
  }
}
