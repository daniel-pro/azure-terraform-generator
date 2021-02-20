{% if azurerm_subnet_network_security_group_associations is defined %}
{% for item in azurerm_subnet_network_security_group_associations %}

resource "azurerm_subnet_network_security_group_association" "{{ item.virtual_network }}-{{ item.subnet }}-{{ item.network_security_group }}" {
  subnet_id  = azurerm_subnet.{{ item.virtual_network }}-{{ item.subnet }}.id
  network_security_group_id  = azurerm_network_security_group.{{ item.network_security_group }}.id
}
{% endfor %}
{% endif %}

