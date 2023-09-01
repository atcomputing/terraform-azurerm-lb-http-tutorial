output "public_ip" {
  value = azurerm_public_ip.lb_public_ip[0].ip_address
}
