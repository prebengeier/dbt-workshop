with source_date as (
    select 
    regionID, regionDescription
    from {{ ref('regions') }}
)