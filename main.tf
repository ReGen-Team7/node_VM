# terraform configuration block, providers

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.50.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

resource "azurerm_public_ip" "node-ip" {
  name                = "${var.prefix}-PublicIp1"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"

  tags = {
    environment = "${var.env}"
  }
}

resource "azurerm_network_interface" "node-nic" {
  name                = "${var.prefix}-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.node-ip.id
  }

  tags = {
    environment = "${var.env}"
  }

}

resource "azurerm_network_interface_security_group_association" "node_nic_sg_association" {
  network_interface_id      = azurerm_network_interface.node-nic.id
  network_security_group_id = var.sg_id
}

resource "azurerm_network_security_rule" "ssh-2" {
  name                        = "ssh-2"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = var.sg_name
}


resource "azurerm_network_security_rule" "port8080" {
  name                        = "port-8080"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = var.sg_name
}

resource "azurerm_network_security_rule" "jenkinsnode" {
  name                        = "jenkinsnode"
  priority                    = 104
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "50000"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = var.sg_name
}

resource "azurerm_linux_virtual_machine" "node-vm" {
  name                  = "${var.prefix}-vm2"
  resource_group_name   = var.rg_name
  location              = var.location
  size                  = "Standard_B1ms"
  network_interface_ids = [azurerm_network_interface.node-nic.id]

  disable_password_authentication = false

  admin_username = var.admin_username
  admin_password = var.admin_password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }


  tags = {
    environment = "${var.env}"
  }
}


