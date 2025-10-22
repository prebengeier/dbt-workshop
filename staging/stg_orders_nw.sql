with source_date as (
    select 
    orderID, customerID, employeeID, orderDate, requiredDate, shippedDate, shipVia, freight, shipName, shipAddress, shipCity, shipRegion, shipPostalCode, shipCountry
    from {{ ref('orders') }}
)