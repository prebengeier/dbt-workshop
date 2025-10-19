
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select price
from pr_999__local.analytics.stg_products
where price is null



  
  
      
    ) dbt_internal_test