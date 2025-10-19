{% macro generate_schema_name(custom_schema_name, node) -%}
    {# Stabil policy:
       - seeds går alltid til 'raw'
       - sources bruker schema slik de er definert i sources.yml (ingen prefiks)
       - øvrige (models/tests/snapshots) bruker target.schema eller custom_schema_name
    #}
    {%- if node.resource_type == 'seed' -%}
        {{ return('raw') }}
    {%- elif node.resource_type == 'source' -%}
        {{ return(custom_schema_name if custom_schema_name is not none else target.schema) }}
    {%- else -%}
        {{ return(custom_schema_name if custom_schema_name is not none else target.schema) }}
    {%- endif -%}
{%- endmacro %}