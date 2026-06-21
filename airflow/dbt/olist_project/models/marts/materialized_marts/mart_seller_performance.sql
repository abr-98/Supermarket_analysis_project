SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue,
    AVG(oi.price) AS average_order_value,
    AVG(DELAY_IN_DAYS) AS avg_delivery_delay,
    AVG(FREIGHT_VALUE) AS avg_freight_value   
FROM {{ ref('dim_seller') }} s
LEFT JOIN {{ ref('fact_order_items') }} oi ON s.seller_key = oi.seller_key
LEFT JOIN {{ ref('facts_orders') }} o ON o.order_id = oi.order_id
GROUP BY s.seller_id, s.seller_city, s.seller_state