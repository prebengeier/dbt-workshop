with source_date as (
    select 
    orderID, productID, unitPrice, quantity, discount
    from {{ ref('order_details') }}
)