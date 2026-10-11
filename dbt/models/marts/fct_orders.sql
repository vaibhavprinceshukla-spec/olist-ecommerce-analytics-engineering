{{ config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge'
) }}

SELECT
    o.order_id,
    o.customer_id,

    CAST(o.order_purchase_timestamp AS DATE) AS order_date,

    o.order_status,

    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    o.total_items,
    o.product_revenue,
    o.freight_value,
    o.total_order_value,

    o.total_payment_value,
    o.payment_count,

    o.average_review_score,
    o.review_count,

    d.delivery_days,
    d.delivery_vs_estimate_days,
    d.delivery_status

FROM {{ ref('int_orders_enriched') }} o

LEFT JOIN {{ ref('int_delivery_performance') }} d
    ON o.order_id = d.order_id

{% if is_incremental() %}

WHERE o.order_purchase_timestamp >= (
    SELECT COALESCE(
        MAX(order_purchase_timestamp),
        CAST('1900-01-01' AS TIMESTAMP)
    )
    FROM {{ this }}
)

{% endif %}