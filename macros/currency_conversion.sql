{% macro usd_to_nok(valuta_usd, kurs=10.5) %}
  ({{ valuta_usd }} * {{ kurs }})
{% endmacro %}