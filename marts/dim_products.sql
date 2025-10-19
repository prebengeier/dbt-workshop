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
    coalesce(pm.avg_selling_price, 0) as avg_selling_price,
    (p.price - p.cost) as profit_margin,
    case
        when pm.total_revenue >= 10000 then 'High Performance'
        when pm.total_revenue >= 5000 then 'Medium Performance'
        when pm.total_revenue >= 1000 then 'Low Performance'
        else 'No Sales'
    end as performance_category
from products p
left join product_metrics pm on p.product_id = pm.product_id