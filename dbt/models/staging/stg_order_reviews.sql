WITH source AS (

    SELECT *
    FROM {{ source('olist', 'olist_order_reviews_dataset') }}

),

renamed AS (

    SELECT
        review_id,
        order_id,
        review_score,
        review_comment_title,
        review_comment_message,
        review_creation_date,
        review_answer_timestamp

    FROM source

),

-- The Olist source contains reviews with NULL/empty order_id and reviews
-- for orders that do not exist in the orders table. These rows can never
-- be joined to an order, so they are excluded to honor the not_null and
-- relationships tests declared in staging.yml.
filtered AS (

    SELECT
        r.review_id,
        r.order_id,
        r.review_score,
        r.review_comment_title,
        r.review_comment_message,
        r.review_creation_date,
        r.review_answer_timestamp

    FROM renamed r

    INNER JOIN (

        SELECT DISTINCT order_id
        FROM {{ source('olist', 'olist_orders_dataset') }}

    ) o
        ON r.order_id = o.order_id

    WHERE r.order_id IS NOT NULL
      AND TRIM(r.order_id) <> ''

)

SELECT *
FROM filtered
