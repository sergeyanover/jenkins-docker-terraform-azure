# Virtual network
resource "azurerm_virtual_network" "dev_network" {
  name                = "JenkinsVnet"
  address_space       = [var.dev_vnet_cidr]
  location            = var.location_region
  resource_group_name = azurerm_resource_group.dev_rg.name
}

# Subnet
resource "azurerm_subnet" "dev_subnet" {
    name                   = "JenkinsSubnet"
    resource_group_name    = azurerm_resource_group.dev_rg.name
    virtual_network_name   = azurerm_virtual_network.dev_network.name
    address_prefixes       = [var.dev_subnet1_cidr]
}

# Public IPs
resource "azurerm_public_ip" "dev_publicip" {
    name                         = "JenkinsPublicIP-${count.index}"
    count                        = var.count_vm
    location                     = var.location_region
    resource_group_name          = azurerm_resource_group.dev_rg.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "dev"
    }
}

# Network interface
resource "azurerm_network_interface" "dev_nic" {
    name                      = "JenkinsNIC-${count.index}"
    count                     = var.count_vm
    location                  = var.location_region
    resource_group_name       = azurerm_resource_group.dev_rg.name

    ip_configuration {
        name                          = "JenkinsNicConfiguration"
        subnet_id                     = azurerm_subnet.dev_subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = element(azurerm_public_ip.dev_publicip.*.id, count.index)
    }

    tags = {
        environment = "dev"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "dev_nic_nsg" {
    count                     = var.count_vm
    network_interface_id      = element(azurerm_network_interface.dev_nic.*.id, count.index)
    network_security_group_id = azurerm_network_security_group.dev_nsg.id   
}