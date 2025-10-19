
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select total_spent
from pr_999__local.analytics.dim_customers
where total_spent is null



  
  
      
    ) dbt_internal_test