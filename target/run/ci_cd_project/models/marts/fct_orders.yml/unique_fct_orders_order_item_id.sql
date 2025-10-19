
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    order_item_id as unique_field,
    count(*) as n_records

from pr_999__local.analytics.fct_orders
where order_item_id is not null
group by order_item_id
having count(*) > 1



  
  
      
    ) dbt_internal_test