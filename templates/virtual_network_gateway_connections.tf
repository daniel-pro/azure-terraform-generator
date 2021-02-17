{%- if azurerm_virtual_network_gateway_connections is defined %}
{% for item in azurerm_virtual_network_gateway_connections %}
resource "azurerm_virtual_network_gateway_connection" "{{ item.name }}" {
  name                            = "{{ item.name }}"
  resource_group_name             = azurerm_resource_group.{{ item.resource_group }}.name
  location                        = azurerm_resource_group.{{ item.resource_group }}.location
  type                            = "{{ item.type }}"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.{{ item.virtual_network_gateway }}.id
{% if item.local_network_gateway is defined %}
  local_network_gateway_id        = azurerm_local_network_gateway.{{ item.local_network_gateway }}.id
{% endif %}
{% if item.express_route_circuit is defined %}
  express_route_circuit_id        = azurerm_express_route_circuit.{{ item.express_route_circuit }}.id
{% endif %}
{% if item.peer_virtual_network_gateway is defined %}
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.{{ item.peer_virtual_network_gateway }}.id
{% endif %}

{% if item.shared_key is defined %}
  shared_key                      = "{{ item.shared_key }}"
{% endif %}

{% if item.connection_protocol is defined %}
  connection_protocol             = "{{ item.connection_protocol }}"
{% endif %}

{% if item.ipsec_policy is defined %}
  ipsec_policy {
      dh_group         = "{{ item.ipsec_policy.dh_group }}"
      ike_encryption   = "{{ item.ipsec_policy.ike_encryption }}"
      ike_integrity    = "{{ item.ipsec_policy.ike_integrity }}"
      ipsec_encryption = "{{ item.ipsec_policy.ipsec_encryption }}"
      ipsec_integrity  = "{{ item.ipsec_policy.ipsec_integrity }}"
      pfs_group        = "{{ item.ipsec_policy.pfs_group }}"
      sa_datasize      = "{{ item.ipsec_policy.sa_datasize }}"
      sa_lifetime      = "{{ item.ipsec_policy.sa_lifetime }}"
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

