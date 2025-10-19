
    
    

with all_values as (

    select
        customer_tier as value_field,
        count(*) as n_records

    from dev.analytics.dim_customers
    group by customer_tier

)

select *
from all_values
where value_field not in (
    'VIP','Premium','Regular','New'
)


