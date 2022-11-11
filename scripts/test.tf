# Get a Static Public IP
resource "azurerm_public_ip" "vm_public_ip" {
  #  depends_on=[azurerm_resource_group.network-rg]
  name                = "pip-${var.app_name}-mongo-${var.environment}"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg_app.name
  allocation_method   = "Dynamic"
  domain_name_label   = "domain_name_label"
  tags                = local.default_tags
}

resource "azurerm_subnet" "vm_subnet" {
  name                 = "snet-${var.app_name}-${var.environment}"
  resource_group_name  = "vn-prod-rg"
  virtual_network_name = "vn-prod-we"
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-${var.app_name}-${var.environment}"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg_app.name

  ip_configuration {
    name                          = "ipconfig1" #internal
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "/subscriptions/subs_id/resourceGroups/data-rg/providers/Microsoft.Network/publicIPAddresses/public-ip"
  }
  tags = local.default_tags
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "vm-${var.app_name}-mongo-${var.environment}"
  location              = var.region
  resource_group_name   = azurerm_resource_group.rg_app.name
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  vm_size               = "Standard_D8s_v3"
  tags                  = local.default_tags

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  #  storage_image_reference {
  #    publisher = "Canonical"
  #    offer     = "UbuntuServer"
  #    sku       = "16.04-LTS"
  #    version   = "latest"
  #  }
  storage_os_disk {
    name              = "disk-${var.app_name}-${var.environment}"
    create_option     = "Attach"
    managed_disk_id   = "/subscriptions/subs_id/resourceGroups/t4cdata-rg/providers/Microsoft.Compute/disks/disk001"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 500
    os_type           = "Linux"
  }
  boot_diagnostics {
    enabled     = true
    storage_uri = "https://genericxx.blob.core.windows.net/"
  }
  #  os_profile {
  #    computer_name  = "hostname"
  #    admin_username = "testadmin"
  #    admin_password = "Passw0rd!"
  #  }
  #os_profile_linux_config {
  #  disable_password_authentication = false
  #}
}
