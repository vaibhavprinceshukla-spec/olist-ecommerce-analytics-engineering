{{ config(
    materialized='table'
) }}

SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state,
    latitude,
    longitude
FROM {{ ref('int_customer_location') }}