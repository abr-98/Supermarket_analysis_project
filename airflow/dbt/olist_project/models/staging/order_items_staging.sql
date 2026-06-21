WITH flattened AS (

    SELECT
        oi.ORDER_ID,

        f.value:order_item_id::NUMBER AS ORDER_ITEM_ID,
        f.value:seller_id::STRING AS SELLER_ID,

        f.value:shipping_limit_date::DATE AS SHIPPING_LIMIT_DATE,

        f.value:price::NUMBER(10,2) AS PRICE,
        f.value:freight_value::NUMBER(10,2) AS FREIGHT_VALUE,

        f.value:product_category_name:STRING AS PRODUCT_CATEGORY_NAME,

        f.value:price + f.value:freight_value AS TOTAL_VALUE

    FROM {{ source('silver', 'ORDER_ITEMS') }} oi,
         LATERAL FLATTEN(input => oi.ORDER_DETAILS) f

)

SELECT *
FROM flattened