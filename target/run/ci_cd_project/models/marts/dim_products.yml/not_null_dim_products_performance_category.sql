
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select performance_category
from pr_999__local.analytics.dim_products
where performance_category is null



  
  
      
    ) dbt_internal_test