# Define the Resource Group (assuming it's already defined)

# Define the Load Balancer
resource "azurerm_lb" "lb01" {
  name                     = "lb-poc"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name

  # Define the Frontend IP Configuration inline
  frontend_ip_configuration {
    name                             = "frontend-ip"
    private_ip_address_allocation    = "Dynamic"
    private_ip_address_version       = "IPv4"
  }
}

# Define the Health Probe
resource "azurerm_lb_probe" "lb_probe" {
  name                = "http-probe"
  loadbalancer_id     = azurerm_lb.lb01.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
}

# Define the Backend Address Pool (assuming it's defined elsewhere)
resource "azurerm_lb_backend_address_pool" "backend_pool_01" {
  name                = "backend-pool"
  loadbalancer_id     = azurerm_lb.lb01.id
}

# Define the LB Rule to direct traffic to the backend pool
resource "azurerm_lb_rule" "azurerm_lb_rule" {
  frontend_ip_configuration_name = "frontipName"
  name                           =  "http_rule"
  loadbalancer_id                = azurerm_lb.lb01.id
  #frontend_ip_configuration_id   #Value will be auto decided base on Configuration
  backend_address_pool_ids       = azurerm_lb_backend_address_pool.backend_pool_01.id
  probe_id                       = azurerm_lb_probe.lb_probe.id  
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
}
