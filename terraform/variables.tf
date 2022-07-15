/// General
variable "resource_group_name" {
  default = "rg-byterraform"
}

variable "location_name" {
  default = "uksouth"
}

variable "admin_user" {
  default = "azureadmin"
}

variable "public_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

/// Network
variable "network_name" {
  default = "vnetwork1"
}

variable "subnet_name" {
  default = "subnet1"
}

/// Images
variable "vm_image" {
  default = "centos-8-stream-free"
}
variable "vm_image_version" {
  default = "latest"
}
variable "vm_image_publisher" {
  default = "cognosys"
}

/// VMs
variable "vms" {
  type = map(any)
  default = {
    "master" = "Standard_D2_v2" # 7 GiB, 2 vCPUs
    "nfs"    = "Standard_B2s"   # 4 GiB, 2 vCPUs
    "worker" = "Standard_B2s"   # 4 GiB, 2 vCPUs
  }
}
