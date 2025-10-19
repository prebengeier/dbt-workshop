
  
  create view pr_999__local.analytics.stg_customers__dbt_tmp as (
    

with source as (
    select * from pr_999__local.analytics_dev.raw_customers
),

staged as (
    select
        customer_id,
        first_name,
        last_name,
        email,
        phone,
        address,
        city,
        state,
        zip_code,
        country,
        created_at,
        updated_at
    from source
)

select * from staged
where true
  );
