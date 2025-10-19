
    
    

select
    order_item_id as unique_field,
    count(*) as n_records

from prod.analytics.fct_orders
where order_item_id is not null
group by order_item_id
having count(*) > 1


