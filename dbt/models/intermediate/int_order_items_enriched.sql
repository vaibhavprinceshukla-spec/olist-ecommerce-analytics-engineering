{{ config(
    materialized='table'
) }}

WITH order_items AS (

    SELECT *
    FROM {{ ref('stg_order_items') }}

),

products AS (

    SELECT *
    FROM {{ ref('int_product_enriched') }}

),

sellers AS (

    SELECT
        seller_id,
        seller_zip_code_prefix,
        seller_city,
        seller_state

    FROM {{ ref('stg_sellers') }}

)

SELECT

    oi.order_id,
    oi.order_item_id,

    oi.product_id,
    oi.seller_id,

    oi.price,
    oi.freight_value,
    oi.shipping_limit_date,

    p.product_category_name,
    p.product_category_name_english,

    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,

    s.seller_zip_code_prefix,
    s.seller_city,
    s.seller_state

FROM order_items oi

LEFT JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id