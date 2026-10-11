{{ config(
    materialized='table'
) }}

WITH orders AS (

    SELECT *
    FROM {{ ref('int_orders_enriched') }}

)

SELECT

    order_id,
    customer_id,
    order_status,

    order_purchase_timestamp,
    order_delivered_customer_date,
    order_estimated_delivery_date,

    CASE
        WHEN order_delivered_customer_date IS NOT NULL
        THEN DATEDIFF(
            order_delivered_customer_date,
            order_purchase_timestamp
        )
    END AS delivery_days,

    CASE
        WHEN order_delivered_customer_date IS NOT NULL
        THEN DATEDIFF(
            order_estimated_delivery_date,
            order_delivered_customer_date
        )
    END AS delivery_vs_estimate_days,

    CASE
        WHEN order_delivered_customer_date IS NULL
            THEN 'Not Delivered'

        WHEN order_delivered_customer_date
             <= order_estimated_delivery_date
            THEN 'On Time'

        ELSE 'Late'

    END AS delivery_status

FROM orders