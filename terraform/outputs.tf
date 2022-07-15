output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.*.id
}

output "vm_public_ip" {
    value = azurerm_public_ip.public_ip.*.id
}