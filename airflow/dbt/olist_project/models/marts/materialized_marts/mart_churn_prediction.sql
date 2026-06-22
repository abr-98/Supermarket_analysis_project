{{ config(materialized='table') }}

WITH customer_orders AS (

    SELECT
        o.customer_key,
        o.order_id,
        d.order_date,
        o.delay_in_days,
        o.review_score,
        o.order_status

    FROM {{ ref('facts_orders') }} o
    JOIN {{ ref('dim_date') }} d
        ON o.date_key = d.date_key

),

customer_items AS (

    SELECT
        o.customer_key,

        COUNT(*) AS total_items_volume,

        SUM(oi.total_value) AS monetary

    FROM {{ ref('facts_orders') }} o

    JOIN {{ ref('fact_order_items') }} oi
        ON o.order_id = oi.order_id

    GROUP BY o.customer_key

),

payment_features AS (

    SELECT
        customer_key,

        COUNT(DISTINCT payment_type) AS payment_method_count,

        MAX(payment_installments) AS max_installments,

        MAX_BY(payment_type, payment_count) AS primary_payment_type

    FROM (

        SELECT
            o.customer_key,
            fo.payment_type,
            fo.payment_installments,
            COUNT(*) AS payment_count

        FROM {{ ref('facts_orders') }} fo

        JOIN {{ ref('facts_orders') }} o
            ON fo.order_id = o.order_id

        GROUP BY
            o.customer_key,
            fo.payment_type,
            fo.payment_installments

    )

    GROUP BY customer_key

),

customer_metrics AS (

    SELECT

        c.customer_id AS customer_unique_id,

        DATEDIFF(
            day,
            MAX(co.order_date),
            CURRENT_DATE
        ) AS recency,

        COUNT(DISTINCT co.order_id) AS frequency,

        MAX(co.delay_in_days) AS max_delivery_delay,

        CASE
            WHEN SUM(
                CASE
                    WHEN co.order_status = 'delivered'
                    THEN 1
                    ELSE 0
                END
            ) > 0
            THEN 1
            ELSE 0
        END AS is_delivered,

        AVG(co.review_score) AS avg_satisfaction,

        MIN(co.review_score) AS min_review_score,

        COUNT(co.review_score) AS total_reviews_given

    FROM {{ ref('dim_customers') }} c

    LEFT JOIN customer_orders co
        ON c.customer_key = co.customer_key

    GROUP BY c.customer_id

)

SELECT

    cm.customer_unique_id,

    cm.recency,

    cm.frequency,

    ci.monetary,

    dc.customer_city AS city,

    dc.customer_state AS state,

    ci.total_items_volume,

    cm.max_delivery_delay,

    cm.is_delivered,

    pf.payment_method_count,

    pf.primary_payment_type,

    pf.max_installments,

    cm.avg_satisfaction,

    cm.min_review_score,

    cm.total_reviews_given

FROM customer_metrics cm

JOIN {{ ref('dim_customers') }} dc
    ON cm.customer_unique_id = dc.customer_id

LEFT JOIN customer_items ci
    ON dc.customer_key = ci.customer_key

LEFT JOIN payment_features pf
    ON dc.customer_key = pf.customer_key