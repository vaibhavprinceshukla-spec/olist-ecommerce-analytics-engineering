{{ config(
    materialized='table'
) }}

SELECT
    oi.order_id,
    oi.order_item_id,

    oi.product_id,
    oi.seller_id,

    oi.price,
    oi.freight_value,

    oi.price + oi.freight_value AS item_total_value,

    oi.shipping_limit_date,

    oi.product_category_name,
    oi.product_category_name_english,

    oi.product_weight_g,
    oi.product_length_cm,
    oi.product_height_cm,
    oi.product_width_cm,

    oi.seller_zip_code_prefix,
    oi.seller_city,
    oi.seller_state

FROM {{ ref('int_order_items_enriched') }} oi