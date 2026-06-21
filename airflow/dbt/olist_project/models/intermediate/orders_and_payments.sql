SELECT 
    O.ORDER_ID,
    O.MONTH,
    O.DAY,
    O.YEAR,
    OI.TOTAL_VALUE,
    P.PAYMENT_VALUE,
    P.PAYMENT_TYPE,
    P.PAYMENT_INSTALLMENTS
FROM {{ ref('orders_staging') }} O
JOIN {{ ref('order_items_staging') }} OI ON O.ORDER_ID = OI.ORDER_ID
JOIN {{ source('bronze', 'PAYMENTS') }} P ON O.ORDER_ID = P.ORDER_ID