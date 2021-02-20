{% if azurerm_public_ips is defined %}
{% for item in azurerm_public_ips %}

resource "azurerm_public_ip" "{{ item.name }}" {
  name                       = "{{ item.name }}"
  resource_group_name        = azurerm_resource_group.{{ item.resource_group }}.name
  location                   = azurerm_resource_group.{{ item.resource_group }}.location
  allocation_method          = "{{ item.allocation_method }}"

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

