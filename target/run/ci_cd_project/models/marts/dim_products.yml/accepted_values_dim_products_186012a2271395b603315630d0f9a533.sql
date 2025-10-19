
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        performance_category as value_field,
        count(*) as n_records

    from dev.analytics.dim_products
    group by performance_category

)

select *
from all_values
where value_field not in (
    'High Performance','Medium Performance','Low Performance','No Sales'
)



  
  
      
    ) dbt_internal_test