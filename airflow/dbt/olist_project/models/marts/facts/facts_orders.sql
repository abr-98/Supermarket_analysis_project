SELECT CO.ORDER_ID,
       {{ dbt_utils.generate_surrogate_key(['CO.CUSTOMER_ID']) }} AS customer_key,
       {{ dbt_utils.generate_surrogate_key([
            "TO_DATE(
                O.YEAR || '-' ||
                LPAD(O.MONTH::VARCHAR, 2, '0') || '-' ||
                LPAD(O.DAY::VARCHAR, 2, '0')
            )"
        ]) }} AS DATE_KEY,
       CO.ORDER_STATUS,
       CO.TOTAL_VALUE,
       PO.PAYMENT_VALUE,
       PO.PAYMENT_TYPE,
       PO.PAYMENT_INSTALLMENTS,
       O.TIME_TO_DELIVER,
       O.ACTUAL_TURN_AROUND_TIME,
       O.DELAY_IN_DAYS,
       O.REVIEW_SCORE
FROM {{ ref('orders_staging') }} O
JOIN {{ ref('orders_and_payments') }} PO ON O.ORDER_ID = PO.ORDER_ID
JOIN {{ ref('customer_and_order_details') }} CO ON O.ORDER_ID = CO.ORDER_ID
