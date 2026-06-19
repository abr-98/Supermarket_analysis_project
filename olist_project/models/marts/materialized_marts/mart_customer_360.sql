SELECT 
    c.customer_id,
    c.customer_city,
    c.customer_state,
    COUNT(o.order_id) AS total_orders,
    SUM(oi.price) AS total_spent,
    AVG(oi.price) AS average_order_value,
    AVG(DATEDIFF(day, d.order_date, CURRENT_DATE)) AS avg_days_between_orders,
    AVG(DATEDIFF(day, d.order_date, CURRENT_DATE)) AS avg_days_since_last_order,
    AVG(DELAY_IN_DAYS) AS avg_delivery_delay
FROM {{ ref('dim_customers') }} c
LEFT JOIN {{ ref('facts_orders') }} o ON c.customer_id = o.customer_key
LEFT JOIN {{ ref('fact_order_items') }} oi ON o.order_id = oi.order_id
LEFT JOIN {{ ref('dim_date') }} d ON o.date_key = d.date_key
GROUP BY c.customer_id, c.customer_city, c.customer_state