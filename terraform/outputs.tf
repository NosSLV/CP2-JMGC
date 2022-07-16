output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

output "vm_id" {
  value = {
    for vm, bd in azurerm_linux_virtual_machine.vm : vm => bd.id
  }
}

output "vm_private_ip" {
  value = {
    for vm in azurerm_linux_virtual_machine.vm :
    vm.computer_name => vm.private_ip_address
  }
}

output "vm_public_ip" {
  value = {
    for vm in azurerm_linux_virtual_machine.vm :
    vm.computer_name => vm.public_ip_address
  }
}