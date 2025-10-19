

with source as (
    select * from pr_999__local.analytics_dev.raw_order_items
),

staged as (
    select
        order_item_id,
        order_id,
        product_id,
        quantity,
        unit_price,
        total_price,
        discount_amount,
        created_at
    from source
)

select * from staged