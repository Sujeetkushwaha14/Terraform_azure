resource "azurerm_resource_group" "sujeet" {
  name     = "sujeet"
  location = "south india"
}
resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.sujeet.location
  resource_group_name = azurerm_resource_group.sujeet.name
}
resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.sujeet.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.sujeet.location
  resource_group_name = azurerm_resource_group.sujeet.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.sujeet.location
  resource_group_name = azurerm_resource_group.sujeet.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "80", "443", "8000"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_public_ip" "example" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.sujeet.name
  location            = azurerm_resource_group.sujeet.location
  allocation_method   = "Static"
}
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}
resource "azurerm_linux_virtual_machine" "example" {
  name                            = "sujeet-machine"
  resource_group_name             = azurerm_resource_group.sujeet.name
  location                        = azurerm_resource_group.sujeet.location
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  admin_password                  = "sKushwaha@123"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

}

