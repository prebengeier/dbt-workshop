
{% snapshot snapshot_customers_check_subset %}
{{
  config(
    target_schema = 'analytics_snapshots',
    unique_key    = 'customer_id',
    strategy      = 'check',
    check_cols    = ['first_name','last_name','email','phone',
                     'address','city','state','zip_code','country']
  )
}}
select
  customer_id, first_name, last_name, email, phone,
  address, city, state, zip_code, country,
  created_at, updated_at
from {{ ref('stg_customers') }}
{% endsnapshot %}
