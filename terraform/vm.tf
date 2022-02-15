# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.dev_rg.name
    }

    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "dev_storageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.dev_rg.name
    location                    = var.location_region
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "dev"
    }
}

# Create (and display) an SSH key
resource "tls_private_key" "jenkins_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}


# Create virtual machine
resource "azurerm_linux_virtual_machine" "jenkins_vm" {
    name                  = "JenkinsVM-${count.index}"
    count                 = var.count_vm
    location              = var.location_region
    resource_group_name   = azurerm_resource_group.dev_rg.name
    network_interface_ids = [element(azurerm_network_interface.dev_nic.*.id, count.index),]
    size                  = "Standard_DS1_v2"

    os_disk {
        name                 = "JenkinsOsDisk${count.index}"
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
        disk_size_gb         = "30"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name                   = "jenkins${count.index}"
    admin_username                  = "azureuser"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "azureuser"
 # generate a pair of keys and you may get a private key with a command: terraform output -raw tls_private_key       
 #      public_key     = tls_private_key.jenkins_ssh.public_key_openssh
 # use your own keys
        public_key     = var.my_public_key 
    }

    user_data = file("jenkins-entry-script.sh")

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.dev_storageaccount.primary_blob_endpoint
    }

    tags = {
        environment = "dev"
    }
}
