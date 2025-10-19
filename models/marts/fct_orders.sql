{{
  config(
    materialized='table'
  )
}}

with orders as (
    select * from {{ ref('stg_orders') }}
),

order_items as (
    select * from {{ ref('stg_order_items') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

order_details as (
    select
        oi.order_item_id,
        oi.order_id,
        oi.product_id,
        oi.quantity,
        oi.unit_price,
        oi.total_price,
        oi.discount_amount,
        o.order_date,
        o.status,
        o.customer_id,
        o.total_amount as order_total,
        p.product_name,
        p.category,
        p.brand,
        p.price as product_price,
        p.cost as product_cost,
        c.first_name,
        c.last_name,
        c.email,
        c.city,
        c.state,
        c.country,
        oi.created_at
    from order_items oi
    inner join orders o on oi.order_id = o.order_id
    inner join products p on oi.product_id = p.product_id
    inner join customers c on o.customer_id = c.customer_id
)

select * from order_details
where true