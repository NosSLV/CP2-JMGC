/// General ///
variable "resource_group_name" {
  description = "Resource Group created by Terraform for every deployed service"
  default     = "rg-byterraform"
}

variable "location" {
  description = "Azure Location"
  default     = "uksouth"
}

variable "storage_account" {
  description = "storage account name"
  type        = string
  default     = "storage_acc_nos"
}

variable "public_key_path" {
  description = "Public Key path used by VMs to allow connections from host machine"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_user" {
  description = "Admin and SSH user"
  default     = "azureadmin"
}

/// Network ///
variable "network_name" {
  description = "Azure Virtual Network name"
  default     = "vnetwork1"
}

variable "subnet_name" {
  description = "Sub-Network name"
  default     = "subnet1"
}

/// Images ///
variable "vm_image" {
  description = "Image to install in VMs"
  default     = "centos-8-stream-free"
}
variable "vm_image_version" {
  description = "Version of the image to install"
  default     = "latest"
}
variable "vm_image_publisher" {
  description = "Publisher of the image to install"
  default     = "cognosys"
}

/// VMs ///
variable "vms" {
  description = "Machines to install and the size that every one is going to use"
  type        = map(any)
  default = {
    "master" = {
      size = "Standard_D2_v2" # 7 GiB, 2 vCPUs
      IP   = "10.0.2.22"
    }
    "worker" = {
      size = "Standard_B2s" # 4 GiB, 2 vCPUs
      IP   = "10.0.2.23"
    }
    "nfs" = {
      size = "Standard_B2s" # 4 GiB, 2 vCPUs
      IP   = "10.0.2.30"
    }
  }
}