/// Resource Group ///
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location_name
}

/// Network Resources ///
resource "azurerm_virtual_network" "vnetwork" {
  name                = var.network_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnetwork.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
  count               = length(var.vms)
  name                = "VM-NIC-${keys(var.vms)[count.index]}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ip_config-${keys(var.vms)[count.index]}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.*.id[count.index]
  }
}

resource "azurerm_public_ip" "public_ip" {
  count               = length(var.vms)
  name                = "PublicIP-${keys(var.vms)[count.index]}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

/// VMs ///
resource "azurerm_linux_virtual_machine" "vm" {
  count               = length(var.vms)
  name                = "VM-${keys(var.vms)[count.index]}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = values(var.vms)[count.index]
  admin_username      = var.admin_user
  network_interface_ids = [
    azurerm_network_interface.nic.*.id[count.index],
  ]

  admin_ssh_key {
    username   = var.admin_user
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  plan {
    name      = var.vm_image
    product   = var.vm_image
    publisher = "cognosys"
  }

  source_image_reference {
    publisher = "cognosys"
    offer     = var.vm_image
    sku       = var.vm_image
    version   = "latest"
  }
}