SELECT ORDER_ID,
        PRODUCT_CATEGORY_NAME,
        {{ dbt_utils.generate_surrogate_key(['ORDER_ID', 'PRODUCT_CATEGORY_NAME']) }} AS product_key
        FROM {{ ref('customer_and_order_details') }}



