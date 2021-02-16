{%- if azurerm_network_security_groups is defined %}
{% for item in azurerm_network_security_groups %}

resource "azurerm_network_security_group" "{{ item.name }}" {
  name                = "{{ item.name }}"
  location            = azurerm_resource_group.{{ item.resource_group }}.location
  resource_group_name = azurerm_resource_group.{{ item.resource_group }}.name

{% for security_rule in item.security_rules %}
  security_rule {
    name                       = "{{ security_rule.name }}"
    priority                   = {{ security_rule.priority }}
    direction                  = "{{ security_rule.direction }}"
    access                     = "{{security_rule.access }}"
    protocol                   = "{{ security_rule.protocol }}"
    source_port_range          = "{{ security_rule.source_port_range }}"
    destination_port_range     = "{{ security_rule.destination_port_range }}"
    source_address_prefix      = "{{ security_rule.source_address_prefix }}"
    destination_address_prefix = "{{ security_rule.destination_address_prefix }}"
  }
{% endfor %}
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
