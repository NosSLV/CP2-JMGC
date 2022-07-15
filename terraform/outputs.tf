output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.*.id
}

output "vm_private_ip" {
  value = {
    for nic in azurerm_network_interface.nic :
    nic.name => nic.private_ip_address
  }
}

output "vm_public_ip" {
  value = {
    for ip in azurerm_public_ip.public_ip :
    ip.name => ip.ip_address
  }
}