
    
    

select
    email as unique_field,
    count(*) as n_records

from dev.analytics.stg_customers
where email is not null
group by email
having count(*) > 1


