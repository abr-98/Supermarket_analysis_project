SELECT 
    C.CUSTOMER_ID,
    C.CUSTOMER_CITY,
    C.CUSTOMER_STATE,
    O.ORDER_ID,
    O.ORDER_STATUS,
    O.MONTH,
    O.DAY,
    O.YEAR,
    OI.TOTAL_VALUE,
    OI.PRODUCT_CATEGORY_NAME
FROM {{ source('silver', 'CUSTOMERS') }} C
JOIN {{ ref('orders_staging') }} O ON C.CUSTOMER_ID = O.CUSTOMER_ID
JOIN {{ ref('order_items_staging') }} OI ON O.ORDER_ID = OI.ORDER_ID