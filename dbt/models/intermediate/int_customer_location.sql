{{ config(
    materialized='table'
) }}

WITH customers AS (

    SELECT
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state

    FROM {{ ref('stg_customers') }}

),

geolocation AS (

    SELECT

        geolocation_zip_code_prefix,

        AVG(geolocation_lat) AS latitude,
        AVG(geolocation_lng) AS longitude

    FROM {{ ref('stg_geolocation') }}

    GROUP BY
        geolocation_zip_code_prefix

)

SELECT

    c.customer_id,
    c.customer_unique_id,

    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,

    g.latitude,
    g.longitude

FROM customers c

LEFT JOIN geolocation g
    ON c.customer_zip_code_prefix =
       g.geolocation_zip_code_prefix