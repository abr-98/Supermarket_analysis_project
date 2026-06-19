SELECT

    dc.customer_state,

    ds.seller_state,

    COUNT(DISTINCT fo.order_id) AS total_orders,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN fo.DELAY_IN_DAYS > 0
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS delay_percentage,

    ROUND(
        AVG(fo.delay_in_days),
        2
    ) AS avg_delay_days,

    ROUND(
        AVG(foi.freight_value),
        2
    ) AS avg_freight_cost,

    ROUND(
        SUM(foi.freight_value),
        2
    ) AS total_freight_cost

FROM {{ ref('facts_orders') }} fo

JOIN {{ ref('dim_customers') }} dc
    ON fo.customer_key = dc.customer_key

JOIN {{ ref('fact_order_items') }} foi
    ON fo.order_id = foi.order_id

JOIN {{ ref('dim_seller') }} ds
    ON foi.seller_key = ds.seller_key

GROUP BY
    dc.customer_state,
    ds.seller_state