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
    public_ip_address_id = var.lb_public_ip_id == null ? azurerm_public_ip.lb_public_ip[0].id : var.lb_public_ip_id
  }
}

resource "azurerm_lb_rule" "http" {
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "http-inbound-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.main.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.http.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id]
}

resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "${var.name}_pool"
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count                   = length(var.nic_ids)
  network_interface_id    = var.nic_ids[count.index]
  ip_configuration_name   = var.nic_ip_configuration_names[count.index]
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}

resource "azurerm_lb_probe" "http" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "${var.name}_http_probe"
  port            = 80
  protocol        = "Http"
  request_path    = "/"
}
