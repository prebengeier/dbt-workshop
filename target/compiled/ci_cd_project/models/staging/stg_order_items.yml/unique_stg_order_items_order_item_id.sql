
    
    

select
    order_item_id as unique_field,
    count(*) as n_records

from pr_999__local.analytics.stg_order_items
where order_item_id is not null
group by order_item_id
having count(*) > 1


