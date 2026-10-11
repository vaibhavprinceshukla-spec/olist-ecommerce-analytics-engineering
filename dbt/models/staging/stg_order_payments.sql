WITH source AS (

    SELECT *
    FROM {{ source('olist', 'olist_order_payments_dataset') }}

),

renamed AS (

    SELECT
        order_id,
        payment_sequential,
        payment_type,
        payment_installments,
        payment_value
    FROM source

)

SELECT *
FROM renamed