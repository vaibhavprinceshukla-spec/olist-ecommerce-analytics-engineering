{{ config(
    materialized='table'
) }}

WITH orders AS (

    SELECT *
    FROM {{ ref('int_orders_enriched') }}

),

customer_orders AS (

    SELECT

        customer_id,

        COUNT(DISTINCT order_id) AS total_orders,

        SUM(total_order_value) AS total_spend,

        AVG(total_order_value) AS average_order_value,

        MIN(order_purchase_timestamp) AS first_order_date,

        MAX(order_purchase_timestamp) AS last_order_date

    FROM orders

    GROUP BY customer_id

)

SELECT *

FROM customer_orders