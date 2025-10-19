
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select total_revenue
from prod.analytics.dim_products
where total_revenue is null



  
  
      
    ) dbt_internal_test