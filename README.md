## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 0.13.1)

- <a name="requirement_azurer"></a> [azurer](#requirement\_azurer) (>= 3.29)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_availability_set.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set) (resource)
- [azurerm_lb.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) (resource)
- [azurerm_lb_backend_address_pool.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) (resource)
- [azurerm_lb_probe.http](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) (resource)
- [azurerm_lb_rule.http](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) (resource)
- [azurerm_network_interface_backend_address_pool_association.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) (resource)
- [azurerm_public_ip.lb_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: The location where the loadbalancer  should exist.

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: unique name for this loadbalancer

Type: `string`

### <a name="input_nic_ids"></a> [nic\_ids](#input\_nic\_ids)

Description: id's of the azurerm\_network\_interface used as backend for the loadbalancer

Type: `list(string)`

### <a name="input_nic_ip_configuration_names"></a> [nic\_ip\_configuration\_names](#input\_nic\_ip\_configuration\_names)

Description: names of ip\_configuration azurerm\_network\_interface used as backend for the loadbalancer.has to be in same order then nic\_ids

Type: `list(string)`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The name of the Resource Group in which to create the Network Interface.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_lb_public_ip_id"></a> [lb\_public\_ip\_id](#input\_lb\_public\_ip\_id)

Description: (Optional) The id of azurerm\_public\_ip, for if you want to manage that ip yourself.

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_availability_set"></a> [availability\_set](#output\_availability\_set)

Description: n/a

### <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip)

Description: n/a
