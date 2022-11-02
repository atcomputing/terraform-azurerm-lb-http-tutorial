provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "training" {
  # this assumes a resource_group already exist
  name = "testrens_guru00"
}

module "loadbalancer" {
  source                     = "atcomputing/lb-http-tutorial/azurerm"
  version                    = "~>0.0.6"
  name                       = "lb_app"
  nic_ids                    = azurerm_network_interface.webapp_nic.*.id
  nic_ip_configuration_names = azurerm_network_interface.webapp_nic[*].ip_configuration[0].name
  location                   = data.azurerm_resource_group.training.location
  resource_group_name        = data.azurerm_resource_group.training.name
}

resource "azurerm_public_ip" "webapp_ip" {
  count               = 3
  name                = "webapp_ip${count.index}"
  location            = data.azurerm_resource_group.training.location
  resource_group_name = data.azurerm_resource_group.training.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "webapp_nic" {
  count               = 3
  name                = "webapp_nic${count.index}"
  location            = data.azurerm_resource_group.training.location
  resource_group_name = data.azurerm_resource_group.training.name

  ip_configuration {
    name                          = "webapp_ip_conf"
    subnet_id                     = azurerm_subnet.frontend.id
    private_ip_address_allocation = "Dynamic"
    # only used to make provising vms easier
    public_ip_address_id = azurerm_public_ip.webapp_ip[count.index].id
  }
}
resource "azurerm_linux_virtual_machine" "webapp" {
  count               = 3
  name                = "webapp${count.index}"
  location            = data.azurerm_resource_group.training.location
  resource_group_name = data.azurerm_resource_group.training.name

  # VM has to be in availability_set to make the load balancer work
  # The load balancer module create this for you. But normaly you would create this yourself
  availability_set_id = module.loadbalancer.availability_set.id

  size           = "Standard_F2"
  admin_username = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.webapp_nic[count.index].id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  tags = {
    app = "web"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "sudo apt -qq update",
      "sudo apt -qq install -y apache2",
      "echo hello GURU user at ${self.name} | sudo tee /var/www/html/index.html",
    ]

    connection {
      type        = "ssh"
      user        = self.admin_username
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip_address
    }
  }
}

resource "azurerm_virtual_network" "vnet_guru00" {
  name                = "vnet_guru00"
  address_space       = ["10.0.0.0/16"]
  location            = "westeurope"
  resource_group_name = "testrens_guru00"
  tags                = {}
}

resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = data.azurerm_resource_group.training.name
  virtual_network_name = azurerm_virtual_network.vnet_guru00.name
  address_prefixes     = ["10.0.2.0/24"]
}
