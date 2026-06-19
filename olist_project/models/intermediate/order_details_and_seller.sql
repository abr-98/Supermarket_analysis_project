SELECT
    O.ORDER_ID,
    O.ORDER_STATUS,
    O.MONTH,
    O.DAY,
    O.YEAR,

    S.SELLER_ID,
    S.SELLER_CITY,
    S.SELLER_STATE,

    OI.FREIGHT_VALUE,
    OI.SHIPPING_LIMIT_DATE,

    C.CUSTOMER_ID,
    C.CUSTOMER_CITY,
    C.CUSTOMER_STATE

FROM {{ ref('orders_staging') }} O

JOIN {{ ref('order_items_staging') }} OI
    ON O.ORDER_ID = OI.ORDER_ID

JOIN {{ source('bronze', 'SELLERS') }} S
    ON OI.SELLER_ID = S.SELLER_ID

JOIN {{ source('silver', 'CUSTOMERS') }} C
    ON O.CUSTOMER_ID = C.CUSTOMER_ID