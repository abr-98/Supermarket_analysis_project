SELECT 
    SUM(P.PAYMENT_VALUE) AS total_payment_value,
    AVG(P.PAYMENT_VALUE) AS average_payment_value,
    COUNT(DISTINCT F.ORDER_ID) AS total_orders_with_payment,
    COUNT(DISTINCT CASE WHEN P.PAYMENT_TYPE = 'credit_card' THEN F.ORDER_ID END) AS total_credit_card_payments,
    COUNT(DISTINCT CASE WHEN P.PAYMENT_TYPE = 'boleto' THEN F.ORDER_ID END) AS total_boleto_payments,
    COUNT(DISTINCT CASE WHEN P.PAYMENT_TYPE = 'voucher' THEN F.ORDER_ID END) AS total_voucher_payments,
    COUNT(DISTINCT CASE WHEN P.PAYMENT_TYPE = 'debit_card' THEN F.ORDER_ID END) AS total_debit_card_payments,
    AVG(P.PAYMENT_INSTALLMENTS) AS average_payment_installments
FROM {{ ref('fact_order_items') }} F
JOIN {{ ref('dim_payments') }} P ON F.ORDER_ID = P.ORDER_ID