
  
  create view dev.analytics.stg_products__dbt_tmp as (
    

with source as (
    select * from dev.analytics_dev.raw_products
),

staged as (
    select
        product_id,
        product_name,
        category,
        subcategory,
        brand,
        price,
        cost,
        description,
        is_active,
        created_at,
        updated_at
    from source
)

select * from staged
  );
