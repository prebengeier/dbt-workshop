
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customer_tier
from prod.analytics.dim_customers
where customer_tier is null



  
  
      
    ) dbt_internal_test