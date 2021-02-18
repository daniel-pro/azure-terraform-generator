{%- if azurerm_virtual_networks is defined %}
{% for item in azurerm_virtual_networks %}

resource "azurerm_virtual_network" "{{ item.name }}" {
  name     = "{{ item.name }}"
  location            = azurerm_resource_group.{{ item.resource_group }}.location
  resource_group_name = azurerm_resource_group.{{ item.resource_group }}.name
  address_space = [ 
{% for address_space in item.address_space %}
                    "{{ address_space }}", 
{% endfor %}
                   ]
{% if item.dns_servers is defined %}
  dns_servers    = [
{% for dns_server in item.dns_servers %}
                     "{{ dns_server }}",
{% endfor %}
   ]

{% if item.subnets is defined %} 
{% for subnet in item.subnets %}
  subnet {
    name           = "{{ subnet.name }}"
    address_prefix = "{{ subnet.address_prefix }}"
{% if subnet.security_group is defined %}
    security_group = azurerm_network_security_group.{{ subnet.security_group }}.id
{% endif %}
  }
{% endfor %}
{% endif %}

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
