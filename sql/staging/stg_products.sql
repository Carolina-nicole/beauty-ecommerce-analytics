CREATE OR REPLACE TABLE stg_products AS

SELECT
    product_id,

    TRIM(product_name) AS product_name,
    LOWER(TRIM(brand)) AS brand,
    LOWER(TRIM(category)) AS category,
    LOWER(TRIM(subcategory)) AS subcategory,

    price,

    DATE(launch_date) AS launch_date,

    CASE
        WHEN price >= 0
        THEN TRUE
        ELSE FALSE
    END AS is_valid_price,

    CASE
        WHEN launch_date IS NOT NULL
        THEN TRUE
        ELSE FALSE
    END AS is_valid_launch_date

FROM dim_products;