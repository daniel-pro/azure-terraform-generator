{%- if azurerm_resource_groups is defined %}

{% for item in azurerm_resource_groups %}

resource "azurerm_resource_group" "{{ item.name }}" {
  name     = "{{ item.name }}"
  location = "{{ item.location }}"
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
