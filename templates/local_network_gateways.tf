{%- if azurerm_local_network_gateways is defined %}
{% for item in azurerm_local_network_gateways %}
resource "azurerm_local_network_gateway" "{{ item.name }}" {
  name                = "{{ item.name }}"
  resource_group_name = azurerm_resource_group.{{ item.resource_group }}.name
  location            = azurerm_resource_group.{{ item.resource_group }}.location
  gateway_address     = "{{ item.gateway_address }}"
  address_space       = [
{% for element in item.address_space %}
                          "{{ element }}",
{% endfor %}
                        ]

{% if item.bgp_settings is defined %}
{% for bgp_setting in item.bgp_settings %}
  bgp_settings {
      asn                 = "{{ bgp_setting.asn }}"
      bgp_peering_address = "{{ bgp_setting.bgp_peering_address }}"
      peer_weight         = "{{ bgp_setting.peer_weight }}"
    }
{% endfor %}
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
