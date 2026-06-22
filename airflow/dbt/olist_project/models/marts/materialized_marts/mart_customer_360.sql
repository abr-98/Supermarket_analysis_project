{{ config(materialized='table') }}

WITH customer_metrics AS (

    SELECT

        c.customer_id,
        c.customer_city,
        c.customer_state,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.total_value) AS total_spent,

        AVG(oi.total_value) AS average_order_value,

        MAX(d.order_date) AS last_order_date,

        DATEDIFF(
            day,
            MAX(d.order_date),
            CURRENT_DATE
        ) AS days_since_last_order,

        AVG(o.delay_in_days) AS avg_delivery_delay,

        AVG(o.review_score) AS avg_review_score,

        COUNT(DISTINCT oi.product_category_key) AS unique_categories,

        COUNT(*) AS total_items_purchased,

        ROUND(
            COUNT(*) * 1.0
            / NULLIF(COUNT(DISTINCT o.order_id), 0),
            2
        ) AS avg_items_per_order

    FROM {{ ref('dim_customers') }} c

    LEFT JOIN {{ ref('facts_orders') }} o
        ON c.customer_key = o.customer_key

    LEFT JOIN {{ ref('fact_order_items') }} oi
        ON o.order_id = oi.order_id

    LEFT JOIN {{ ref('dim_date') }} d
        ON o.date_key = d.date_key

    GROUP BY
        c.customer_id,
        c.customer_city,
        c.customer_state

)

SELECT

    customer_id,
    customer_city,
    customer_state,

    total_orders,

    total_spent,

    average_order_value,

    last_order_date,

    days_since_last_order,

    avg_delivery_delay,

    avg_review_score,

    unique_categories,

    total_items_purchased,

    avg_items_per_order,

    CASE
        WHEN avg_review_score >= 4.5 THEN 'HIGH'
        WHEN avg_review_score >= 3 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS satisfaction_segment,

    CASE
        WHEN unique_categories >= 10 THEN 'EXPLORER'
        WHEN unique_categories >= 5 THEN 'MODERATE'
        ELSE 'SPECIALIST'
    END AS shopping_style

FROM customer_metrics