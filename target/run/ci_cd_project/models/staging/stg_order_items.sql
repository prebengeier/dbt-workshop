
  
  create view prod.analytics.stg_order_items__dbt_tmp as (
    

with source as (
    select * from prod.analytics.raw_order_items
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
  );
