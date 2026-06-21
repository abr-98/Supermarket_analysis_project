{% snapshot seller_snapshot %}

{{
    config(
      target_schema='SNAPSHOTS',
      unique_key='seller_id',
      strategy='check',
      check_cols=[
        'seller_city',
        'seller_state'
      ]
    )
}}

select
    seller_id,
    seller_city,
    seller_state
from {{ ref('dim_seller') }}

{% endsnapshot %}