{{ incremental_merge('ORDER_ITEM_KEY') }}
SELECT O.ORDER_ID,
        {{ dbt_utils.generate_surrogate_key([
            'O.ORDER_ID',
            'S.ORDER_ITEM_ID'
        ]) }} AS order_item_key,
        {{ dbt_utils.generate_surrogate_key(['S.PRODUCT_CATEGORY_NAME', 'S.ORDER_ID']) }} AS product_category_key,
       {{ dbt_utils.generate_surrogate_key(['O.SELLER_ID']) }} AS seller_key,
       {{ dbt_utils.generate_surrogate_key(['O.CUSTOMER_ID']) }} AS customer_key,
       {{ dbt_utils.generate_surrogate_key([
            "TO_DATE(
                O.YEAR || '-' ||
                LPAD(O.MONTH::VARCHAR, 2, '0') || '-' ||
                LPAD(O.DAY::VARCHAR, 2, '0')
            )"
        ]) }} AS DATE_KEY,
       S.PRICE,
       S.FREIGHT_VALUE,
       S.TOTAL_VALUE,
       S.SHIPPING_LIMIT_DATE
FROM {{ ref('order_details_and_seller') }} O
JOIN {{ ref('order_items_staging') }} S ON O.ORDER_ID = S.ORDER_ID


