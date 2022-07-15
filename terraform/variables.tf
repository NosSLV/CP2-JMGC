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

variable "vms" {
    type = list(string)
    default = [
        "master",
        "worker",
        "nfs"
    ]
}

variable "machine_types" {
    type = map
    default = {
        var.vms[0] = "Standard_D2_v2" # 7GB, 2CPU
        var.vms[1] = "Standard_A2_v2" # 4GB, 2CPU
        var.vms[2] = "Standard_A2_v2" # 4GB, 2CPU
    }
}