SELECT
    {{ dbt_utils.generate_surrogate_key(['seller_id']) }} AS seller_key,
    seller_id,
    seller_city,
    seller_state
FROM {{ source('bronze', 'SELLERS') }}