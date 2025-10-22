{% snapshot snapshot_customers_timestamp %}
{{
  config(
    target_schema = 'analytics_snapshots',
    unique_key    = 'customer_id',
    strategy      = 'timestamp',
    updated_at    = 'updated_at',
    invalidate_hard_deletes = true
  )
}}
select
  customer_id, first_name, last_name, email, phone,
  address, city, state, zip_code, country,
  created_at, updated_at
from {{ ref('stg_customers') }}
{% endsnapshot %}