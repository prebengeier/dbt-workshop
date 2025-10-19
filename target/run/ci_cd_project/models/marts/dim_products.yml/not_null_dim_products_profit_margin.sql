
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select profit_margin
from pr_999__local.analytics.dim_products
where profit_margin is null



  
  
      
    ) dbt_internal_test