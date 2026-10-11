WITH source AS (

    SELECT *
    FROM {{ source('olist', 'olist_sellers_dataset') }}

),

renamed AS (

    SELECT
        seller_city,
        seller_state,
        seller_id,
        seller_zip_code_prefix
    FROM source

)

SELECT *
FROM renamed