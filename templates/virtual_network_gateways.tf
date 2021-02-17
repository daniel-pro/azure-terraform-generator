{%- if azurerm_virtual_network_gateways is defined %}
{% for item in azurerm_virtual_network_gateways %}

data "azurerm_subnet" "{{ item.virtual_network }}-{{ item.subnet }}" {
  name                 = "GatewaySubnet"
  virtual_network_name = azurerm_virtual_network.{{ item.virtual_network }}.name
  resource_group_name  = azurerm_resource_group.{{ item.resource_group }}.name
}

resource "azurerm_public_ip" "{{ item.name }}-pubip01" {
  name                = "{{ item.name }}-pubip01"
  location            = azurerm_resource_group.{{ item.resource_group }}.location
  resource_group_name = azurerm_resource_group.{{ item.resource_group }}.name
  allocation_method   = "Dynamic"
}

{% if item.active_active == 'true' %}
resource "azurerm_public_ip" "{{ item.name }}-pubip02" {
  name                = "{{ item.name }}-pubip02"
  location            = azurerm_resource_group.{{ item.resource_group }}.location
  resource_group_name = azurerm_resource_group.{{ item.resource_group }}.name
  allocation_method   = "Dynamic"
}
{% endif %}

resource "azurerm_virtual_network_gateway" "{{ item.name }}" {
  name                = "{{ item.name }}"
  resource_group_name = azurerm_resource_group.{{ item.resource_group }}.name
  location            = azurerm_resource_group.{{ item.resource_group }}.location
  type                = "{{ item.type }}"
  vpn_type            = "{{ item.vpn_type }}"
  sku                 = "{{ item.sku }}"
  active_active       = "{{ item.active_active }}"
  enable_bgp          = "{{ item.enable_bgp }}"
{% if item.generation is defined %}
  generation          = "{{ item.generation }}"
{% endif %}

{% if item.enable_bgp == 'true' %}
{% for bgp_setting in item.bgp_settings %}
  bgp_settings {
      asn             = "{{ bgp_setting.asn }}"
      peering_address = "{{ bgp_setting.peering_address }}"
      peer_weight     = "{{ bgp_setting.peer_weight }}"
    }
{% endfor %}
{% endif %}

  ip_configuration {
    name                          = "{{ item.name }}_ip_config01"
    public_ip_address_id          = azurerm_public_ip.{{ item.name }}-pubip01.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.{{ item.virtual_network }}-{{ item.subnet }}.id
  }

{% if item.active_active == 'true' %}
  ip_configuration {
      name                          = "{{ item.name }}_ip_config02"
      public_ip_address_id          = azurerm_public_ip.{{ item.name }}-pubip02.id
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = data.azurerm_subnet.{{ item.virtual_network }}-{{ item.subnet }}.id
    }
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
{% endif %}
