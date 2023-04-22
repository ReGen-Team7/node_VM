variable "location" {
  type    = string
  default = "North Europe"
}
variable "prefix" {
  type    = string
  default = "node"
}

variable "env" {
  type    = string
  default = "node"
}


variable "admin_username" {
  type    = string
  default = "nodeuser"
}

variable "admin_password" {
  type    = string
  default = "Team7p@ss"
}

variable "rg_name" {
  type    = string
  default = "team7-codehub-reg"
}

variable "vn_name" {
  type    = string
  default = "team7-codehub-network"
}

variable "subnet_name" {
  type    = string
  default = "team7-codehub-subnet"
}

variable "subnet_id" {
  type    = string
  default = "/subscriptions/ce9533ff-7454-41d3-9296-f22f30d82fef/resourceGroups/team7-codehub-reg/providers/Microsoft.Network/virtualNetworks/team7-codehub-network/subnets/team7-codehub-subnet"
}

variable "sg_id" {
  type    = string
  default = "/subscriptions/ce9533ff-7454-41d3-9296-f22f30d82fef/resourceGroups/team7-codehub-reg/providers/Microsoft.Network/networkSecurityGroups/team7-codehub-acceptanceTestSecurityGroup1"
}

variable "sg_name" {
  type    = string
  default = "team7-codehub-acceptanceTestSecurityGroup1"
}