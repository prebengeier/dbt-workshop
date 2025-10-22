with source_date as (
    select 
    shipperID, companyName, phone
    from {{ ref('shippers') }}
)