{{
  config(
    materialized='table'
  )
}}

with products as (
    select * from {{ ref('stg_products') }}
),

product_metrics as (
    select
        product_id,
        count(*) as total_orders,
        sum(quantity) as total_quantity_sold,
        sum(total_price) as total_revenue,
        avg(unit_price) as avg_selling_price
    from {{ ref('stg_order_items') }}
    group by product_id
)

select
    p.product_id,
    p.product_name,
    p.category,
    p.subcategory,
    p.brand,
    p.price,
    p.cost,
    p.description,
    p.is_active,
    p.created_at,
    p.updated_at,

    
    coalesce(pm.total_orders, 0) as total_orders,
    coalesce(pm.total_quantity_sold, 0) as total_quantity_sold,
    coalesce(pm.total_revenue, 0) as total_revenue,
    coalesce(pm.avg_selling_price, 0) as avg_selling_price
from products as p
left join product_metrics as pm on p.product_id = pm.product_id