{{ incremental_merge('Order_Key') }}

WITH payments AS (

    SELECT
        ORDER_ID,
        SUM(PAYMENT_VALUE) AS PAYMENT_VALUE,
        MAX(PAYMENT_INSTALLMENTS) AS PAYMENT_INSTALLMENTS,

        MAX(PAYMENT_TYPE) AS PAYMENT_TYPE

    FROM {{ ref('orders_and_payments') }}

    GROUP BY ORDER_ID

),

order_values AS (

    SELECT
        ORDER_ID,
        SUM(TOTAL_VALUE) AS TOTAL_VALUE

    FROM {{ ref('customer_and_order_details') }}

    GROUP BY ORDER_ID

),

base AS (

    SELECT DISTINCT
        O.ORDER_ID,
        O.CUSTOMER_ID,

        TO_DATE(
            O.YEAR || '-' ||
            LPAD(O.MONTH::VARCHAR, 2, '0') || '-' ||
            LPAD(O.DAY::VARCHAR, 2, '0')
        ) AS ORDER_DATE,

        O.ORDER_STATUS,
        O.TIME_TO_DELIVER,
        O.ACTUAL_TURN_AROUND_TIME,
        O.DELAY_IN_DAYS,
        O.REVIEW_SCORE

    FROM {{ ref('orders_staging') }} O

)

SELECT

    B.ORDER_ID,

    {{ dbt_utils.generate_surrogate_key(['B.CUSTOMER_ID']) }}
        AS CUSTOMER_KEY,

    {{ dbt_utils.generate_surrogate_key(['B.CUSTOMER_ID', 'B.ORDER_ID', 'B.ORDER_DATE']) }}
        AS Order_Key,

    {{ dbt_utils.generate_surrogate_key(['B.ORDER_DATE']) }}
        AS DATE_KEY,

    B.ORDER_STATUS,

    OV.TOTAL_VALUE,

    P.PAYMENT_VALUE,
    P.PAYMENT_TYPE,
    P.PAYMENT_INSTALLMENTS,

    B.TIME_TO_DELIVER,
    B.ACTUAL_TURN_AROUND_TIME,
    B.DELAY_IN_DAYS,
    B.REVIEW_SCORE

FROM base B

LEFT JOIN payments P
    ON B.ORDER_ID = P.ORDER_ID

LEFT JOIN order_values OV
    ON B.ORDER_ID = OV.ORDER_ID