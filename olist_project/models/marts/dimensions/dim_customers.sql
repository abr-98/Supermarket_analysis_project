SELECT
    {{ dbt_utils.generate_surrogate_key(['customer_id']) }} AS customer_key,
    customer_id,
    customer_city,
    customer_state
FROM {{ source('silver', 'CUSTOMERS') }}