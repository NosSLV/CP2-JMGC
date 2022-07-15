variable "resource_group_name" {
  default = "rg-byterraform"
}

variable "location_name" {
  default = "uksouth"
}

variable "network_name" {
  default = "vnetwork1"
}

variable "subnet_name" {
  default = "subnet1"
}

variable "admin_user" {
  default = "azureadmin"
}

variable "vm_image" {
  default = "centos-8-stream-free"
}

variable "vms" {
  type = map(any)
  default = {
    "master" = "Standard_D2_v2" # 7 GiB, 2 vCPUs
    "nfs"    = "Standard_B2s"   # 4 GiB, 2 vCPUs
    "worker" = "Standard_B2s"   # 4 GiB, 2 vCPUs
  }
}
