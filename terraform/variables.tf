# Variables
variable "resource_group_name" {
  default = "JenkinsResourceGroup"
}
variable location_region {
  default = "eastus"
}

variable dev_vnet_cidr {
  default = "10.1.0.0/16"
}

variable dev_subnet1_cidr {
  default = "10.1.1.0/24"
}

variable count_vm {
  default = 1
}

variable my_public_key{}
variable ip_admin {}
