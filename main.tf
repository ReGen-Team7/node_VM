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

# # Create a resource group
# resource "azurerm_resource_group" "regen-rg" {
#   name     = "${var.prefix}-rg"
#   location = var.location

#   tags = {
#     environment = "${var.env}"
#   }
# }

# resource "azurerm_virtual_network" "regen-vn" {
#   name                = "${var.prefix}-network"
#   location            = azurerm_resource_group.regen-rg.location
#   resource_group_name = azurerm_resource_group.regen-rg.name
#   address_space       = ["10.0.0.0/16"]

#   tags = {
#     environment = "${var.env}"
#   }
# }

# resource "azurerm_subnet" "regen-subnet" {
#   name                 = "${var.prefix}-subnet"
#   resource_group_name  = azurerm_resource_group.regen-rg.name
#   virtual_network_name = azurerm_virtual_network.regen-vn.name
#   address_prefixes     = ["10.0.1.0/24"]
# }

# resource "azurerm_network_security_group" "node-sg" {
#   name                = "${var.prefix}-SecurityGroup1"
#   location            = "${var.location}"
#   resource_group_name = "${var.rg_name}"
# }

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
  name                        = "port8080"
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



  # admin_ssh_key {
  #   username   = var.admin_username
  #   public_key = file("/home/adminuser/.ssh/id_rsa.pub")
  # }

  # connection {
  #   type        = "ssh"
  #   user        = "adminuser"
  #   private_key = file("~/.ssh/id_rsa") #????????????????????????????????
  #   host        = azurerm_public_ip.node-ip.ip_address
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo apt-get update",
  #     "sudo apt-get install -y docker.io",
  #     "sudo systemctl start docker",
  #     "sudo systemctl enable docker",
  #     "sudo docker run -d -p 8080:8080 your-docker-image-name"
  #   ]
  # }

  tags = {
    environment = "${var.env}"
  }
}


