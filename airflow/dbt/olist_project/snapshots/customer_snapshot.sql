{% snapshot customer_snapshot %}

{{
    config(
      target_schema='SNAPSHOTS',
      unique_key='customer_id',
      strategy='check',
      check_cols=[
        'customer_city',
        'customer_state'
      ]
    )
}}

select
    customer_id,
    customer_city,
    customer_state
from {{ ref('dim_customers') }}

{% endsnapshot %}