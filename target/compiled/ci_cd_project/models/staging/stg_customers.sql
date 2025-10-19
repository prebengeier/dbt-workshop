

with source as (
    select * from dev.analytics_dev.raw_customers
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