{{ config(
    materialized='table'
) }}

WITH products AS (

    SELECT
        product_id,
        product_category_name,
        product_name_length,
        product_description_length,
        product_photos_qty,
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm

    FROM {{ ref('stg_products') }}

),

category_translation AS (

    SELECT
        product_category_name,
        product_category_name_english

    FROM {{ ref('stg_category_translation') }}

)

SELECT

    p.product_id,

    p.product_category_name,

    COALESCE(
        ct.product_category_name_english,
        'Unknown'
    ) AS product_category_name_english,

    p.product_name_length,
    p.product_description_length,
    p.product_photos_qty,

    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm

FROM products p

LEFT JOIN category_translation ct
    ON p.product_category_name =
       ct.product_category_name