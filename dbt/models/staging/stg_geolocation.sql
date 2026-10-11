WITH source AS (

    SELECT *
    FROM {{ source('olist', 'olist_geolocation_dataset') }}

),

renamed AS (

    SELECT
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        geolocation_city,
        geolocation_state

    FROM source

)

SELECT *
FROM renamed