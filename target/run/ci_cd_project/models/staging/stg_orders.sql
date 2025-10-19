
  
  create view dev.analytics.stg_orders__dbt_tmp as (
    

with source as (
    select * from dev.analytics_dev.raw_orders
),

staged as (
    select
        order_id,
        customer_id,
        order_date,
        status,
        total_amount,
        shipping_address,
        billing_address,
        payment_method,
        created_at,
        updated_at
    from source
)

select * from staged
  );
