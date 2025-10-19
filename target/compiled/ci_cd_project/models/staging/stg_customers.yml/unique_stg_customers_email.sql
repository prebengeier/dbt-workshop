
    
    

select
    email as unique_field,
    count(*) as n_records

from pr_999__local.analytics.stg_customers
where email is not null
group by email
having count(*) > 1


