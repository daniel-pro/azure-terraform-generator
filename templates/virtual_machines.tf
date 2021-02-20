{% if azurerm_linux_virtual_machines is defined %}
{% for item in azurerm_linux_virtual_machines %}

{% for vnic in item.vnics %}
resource "azurerm_network_interface" "{{ item.name }}-{{ vnic.name }}" {
  name                = "{{ vnic.name }}"
  location            = azurerm_resource_group.{{ item.resource_group }}.location
  resource_group_name = azurerm_resource_group.{{ item.resource_group }}.name

{% for ip_configuration in vnic.ip_configurations %}
  ip_configuration {
    name                          = "{{ vnic.name }}-ipconf{{ loop.index }}"
    subnet_id                     = azurerm_subnet.{{ ip_configuration.virtual_network }}-{{ ip_configuration.subnet }}.id
    private_ip_address_allocation = "Dynamic"
{% if ip_configuration.public_ip_address_name is defined %}
    public_ip_address_id          = azurerm_public_ip.{{ ip_configuration.public_ip_address_name }}.id
{% endif %}
  }
{% endfor %}

{% if enable_ip_forwarding is defined %}
  enable_ip_forwarding = "{{ enable_ip_forwarding }}"
{% endif %}
{% if enable_accelerated_networking is defined %}
  enable_accelerated_networking = "{{ enable_accelerated_networking }}"
{% endif %}

{% if item.tags is defined %}
  tags     = {
{% for itemtags in item.tags %}
    {{ itemtags.name }} = "{{ itemtags.value }}"
{% endfor %}
   }
{% endif %}

}
{% endfor %}

resource "azurerm_linux_virtual_machine" "{{ item.name }}" {
  name                       = "{{ item.name }}"
  resource_group_name        = azurerm_resource_group.{{ item.resource_group }}.name
  location                   = azurerm_resource_group.{{ item.resource_group }}.location
  size                       = "{{ item.size }}"
  network_interface_ids      = [
{% for vnic in item.vnics %}
                                azurerm_network_interface.{{ item.name }}-{{ vnic.name }}.id,
{% endfor %}
                               ]

  admin_username = "{{ item.username }}"

{% if item.disable_password_authenitication == 'true' %}
  admin_ssh_key {
    username   = "{{ item.username }}"
    public_key = file("{{ item.public_key_file }}")
  }
{% endif %}

  source_image_reference {
      publisher = "{{ item.source_image_reference_publisher }}"
      offer     = "{{ item.source_image_reference_offer }}"
      sku       = "{{ item.source_image_reference_sku }}"
      version   = "{{ item.source_image_reference_version }}"
    }
  
  os_disk {
     name              = "{{ item.os_disk_name }}"
     caching           = "{{ item.os_disk_caching }}"
     storage_account_type = "{{ item.os_disk_storage_account_type }}"
{% if item.os_disk_disk_size_gb is defined %}
     disk_size_gb      = {{ item.os_disk_disk_size_gb }}
{% endif %}
  }

{% if item.tags is defined %}
  tags     = {
{% for itemtags in item.tags %}
    {{ itemtags.name }} = "{{ itemtags.value }}"
{% endfor %}
   }
{% endif %}

}
{% endfor %}
{% endif %}

