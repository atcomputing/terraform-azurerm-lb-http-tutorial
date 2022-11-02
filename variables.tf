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
  description = "names of ip_configuration azurerm_network_interface used as backend for the loadbalancer.has to be in same order then nic_ids"
}

variable "location" {
  type = string
  description = "The location where the loadbalancer  should exist."
}

variable "resource_group_name" {
  type = string
  description = "The name of the Resource Group in which to create the Network Interface."
}

variable "lb_public_ip_id" {
  type    = string
  description = "(Optional) The id of azurerm_public_ip, for if you want to manage that ip yourself."
  default = null
}

