{{
  config(
    materialized='view'
  )
}}

with source as (
    select * from {{ ref('customers') }}
),

staged as (
    select
        customerid,
        companyname,
        contactname,
        contacttitle,
        region,
        postalcode,
        fax
    from source
)

select * from staged
where true