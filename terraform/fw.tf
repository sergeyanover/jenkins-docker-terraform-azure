# Network Security Group and rule
resource "azurerm_network_security_group" "dev_nsg" {
    name                = "JenkinsNetworkSecurityGroup"
    location            = var.location_region
    resource_group_name = azurerm_resource_group.dev_rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = var.ip_admin
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "SSH-12000"
        priority                   = 999
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = var.ip_admin
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "Jenkins"
        priority                   = 997
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = var.ip_admin
        destination_address_prefix = "*"
    }

    tags = {
        environment = "dev"
    }
}