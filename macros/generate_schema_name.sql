{% macro generate_schema_name(custom_schema_name, node) %}
  {% set base = custom_schema_name or target.schema %}
  {% set sid  = var('schema_id', 'local') %}
  {% if target.name == 'pr' and sid not in ['','local'] %}
    {{ return(base ~ '__' ~ sid) }}
  {% else %}
    {{ return(base) }}
  {% endif %}
{% endmacro %}
