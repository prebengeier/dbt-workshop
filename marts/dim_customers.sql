{{
  config(
    materialized='table'
  )
}}

with customers as (
    select * from {{ ref('stg_customers') }}
),

customer_metrics as (
    select
        customer_id,
        count(*) as total_orders,
        sum(total_amount) as total_spent,
        min(order_date) as first_order_date,
        max(order_date) as last_order_date
    from {{ ref('stg_orders') }}
    group by customer_id
)

select
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    c.address,
    c.city,
    c.state,
    c.zip_code,
    c.country,
    c.created_at,
    c.updated_at,
    coalesce(cm.total_orders, 0) as total_orders,
    coalesce(cm.total_spent, 0) as total_spent,
    cm.first_order_date,
    cm.last_order_date,
    case
        when cm.total_spent >= 1000 then 'VIP'
        when cm.total_spent >= 500 then 'Premium'
        when cm.total_spent >= 100 then 'Regular'
        else 'New'
    end as customer_tier
from customers c
left join customer_metrics cm on c.customer_id = cm.customer_id