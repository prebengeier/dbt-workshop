
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        customer_tier as value_field,
        count(*) as n_records

    from pr_999__local.analytics.dim_customers
    group by customer_tier

)

select *
from all_values
where value_field not in (
    'VIP','Premium','Regular','New'
)



  
  
      
    ) dbt_internal_test