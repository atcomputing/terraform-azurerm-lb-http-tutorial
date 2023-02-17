variable "name" {
  type = string
  description = "unique name for this loadbalancer"
}

variable "nic_ids" {
  type = list(string)
  description = "id's of the azurerm_network_interface used as backend for the loadbalancer"
}

variable "nic_ip_configuration_names" {
  type = list(string)
  description = "names of ip_configuration of the azurerm_network_interface resource used as backend for the loadbalancer. This has to be in same order then nic_ids"
}

variable "location" {
  type = string
  description = "The location of the loadbalancer."
}

variable "resource_group_name" {
  type = string
  description = "The name of the Resource Group."
}

variable "lb_public_ip_id" {
  type    = string
  description = "(Optional) The id of azurerm_public_ip, when you want to manage the ip yourself."
  default = null
}

