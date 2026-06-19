WITH dates AS (

    SELECT DISTINCT

        TO_DATE(
            YEAR || '-' ||
            LPAD(MONTH::VARCHAR, 2, '0') || '-' ||
            LPAD(DAY::VARCHAR, 2, '0')
        ) AS ORDER_DATE

    FROM {{ ref('orders_staging') }}

)

SELECT

    {{ dbt_utils.generate_surrogate_key(['ORDER_DATE']) }} AS DATE_KEY,

    ORDER_DATE,

    YEAR(ORDER_DATE) AS YEAR,

    MONTH(ORDER_DATE) AS MONTH,

    DAY(ORDER_DATE) AS DAY,

    CASE
        WHEN MONTH(ORDER_DATE) IN (1, 2, 3) THEN 'Q1'
        WHEN MONTH(ORDER_DATE) IN (4, 5, 6) THEN 'Q2'
        WHEN MONTH(ORDER_DATE) IN (7, 8, 9) THEN 'Q3'
        ELSE 'Q4'
    END AS QUARTER,

    WEEKISO(ORDER_DATE) AS WEEK_OF_YEAR,

    DAYOFWEEK(ORDER_DATE) AS DAY_OF_WEEK,

    DAYNAME(ORDER_DATE) AS DAY_NAME,

    CASE
        WHEN DAYNAME(ORDER_DATE) IN ('Sat', 'Sun')
        THEN TRUE
        ELSE FALSE
    END AS IS_WEEKEND

FROM dates