{{ config(
    materialized='table'
) }}

WITH orders AS (

    SELECT *
    FROM {{ ref('stg_orders') }}

),

order_items AS (

    SELECT
        order_id,
        COUNT(*) AS total_items,
        SUM(price) AS product_revenue,
        SUM(freight_value) AS freight_value,
        SUM(price + freight_value) AS total_order_value
    FROM {{ ref('int_order_items_enriched') }}
    GROUP BY order_id

),

payments AS (

    SELECT
        order_id,
        SUM(payment_value) AS total_payment_value,
        COUNT(*) AS payment_count
    FROM {{ ref('stg_order_payments') }}
    GROUP BY order_id

),

reviews AS (

    SELECT
        order_id,
        AVG(review_score) AS average_review_score,
        COUNT(*) AS review_count
    FROM {{ ref('stg_order_reviews') }}
    GROUP BY order_id

)

SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    COALESCE(oi.total_items, 0) AS total_items,
    COALESCE(oi.product_revenue, 0) AS product_revenue,
    COALESCE(oi.freight_value, 0) AS freight_value,
    COALESCE(oi.total_order_value, 0) AS total_order_value,

    COALESCE(p.total_payment_value, 0) AS total_payment_value,
    COALESCE(p.payment_count, 0) AS payment_count,

    COALESCE(r.average_review_score, 0) AS average_review_score,
    COALESCE(r.review_count, 0) AS review_count

FROM orders o

LEFT JOIN order_items oi
    ON o.order_id = oi.order_id

LEFT JOIN payments p
    ON o.order_id = p.order_id

LEFT JOIN reviews r
    ON o.order_id = r.order_id