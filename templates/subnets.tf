{% if azurerm_subnets is defined %}
{% for item in azurerm_subnets %}

resource "azurerm_subnet" "{{ item.virtual_network }}-{{ item.name }}" {
  name                 = "{{ item.name }}"
  resource_group_name  = azurerm_resource_group.{{ item.resource_group }}.name
  virtual_network_name = azurerm_virtual_network.{{ item.virtual_network }}.name
  address_prefixes     = [
{% for address_prefix in item.address_prefixes %}
                          {{ address_prefix }},
{% endfor %}
                         ]
}
{% endfor %}
{% endif %}

