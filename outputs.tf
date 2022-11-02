output availability_set {
	value = azurerm_availability_set.main
}


output public_ip {
	value = azurerm_public_ip.lb_public_ip[0].ip_address
}
