variable "name" {
  type = string
}

variable "nic_ids" {
  type = list(string)
}

variable "nic_ip_configuration_names" {
  type = list(string)
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

#variable "subnet_id" {
#  type = string
#}

variable "lb_public_ip_id" {
  type    = string
  default = null
}

resource "azurerm_public_ip" "lb_public_ip" {
  count               = var.lb_public_ip_id == null ? 1 : 0
  name                = "${var.name}_public_ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Basic"

  frontend_ip_configuration {
    name                 = "${var.name}_frontend_config"
    #subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.lb_public_ip[0].id
  }
}

resource "azurerm_lb_rule" "http" {
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "http-inbound-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.main.frontend_ip_configuration[0].name
  #probe_id                       = azurerm_lb_probe.ssh-inbound-probe.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.main.id]

}

resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "${var.name}_pool"
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  #for_each = var.nic_ids
  count                   = length(var.nic_ids)
  network_interface_id    = var.nic_ids[count.index]
  ip_configuration_name   = var.nic_ip_configuration_names[count.index]
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}

resource "azurerm_availability_set" "main" {
  name                         = "main"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

output availability_set {
	value = azurerm_availability_set.main
}
