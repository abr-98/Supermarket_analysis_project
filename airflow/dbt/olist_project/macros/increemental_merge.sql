{% macro incremental_merge(unique_key='order_id') %}

{{ config(
    materialized='incremental',
    unique_key=unique_key,
    incremental_strategy='merge',
    on_schema_change='sync_all_columns'
) }}

{% endmacro %}