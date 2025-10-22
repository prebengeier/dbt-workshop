with source_date as (
    select 
    ustomerID, companyName, contactName, contactTitle, address, city, region, postalCode, country, phone, fax
    from {{ ref('customers') }}
)