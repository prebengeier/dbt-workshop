{% macro drop_pr_schemas(database, schema_prefix, pr_number) %}
  {% set prefix = schema_prefix ~ '_' ~ pr_number ~ '__' %}
  {% set sql %}
    select schema_name
    from information_schema.schemata
    where startswith(lower(schema_name), lower('{{ prefix }}'))
  {% endset %}

  {% set results = run_query(sql) %}
  {% if execute %}
    {% for row in results %}
      {% set schema_name = row[0] %}
      {% do log('Dropping schema ' ~ schema_name, info=True) %}
      {% do run_query('DROP SCHEMA IF EXISTS ' ~ schema_name ~ ' CASCADE') %}
    {% endfor %}
  {% endif %}
{% endmacro %}
