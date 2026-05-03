CREATE OR REPLACE TABLE stg_order_items AS

SELECT
    order_id,
    product_id,
    quantity,
    unit_price,

    CASE
        WHEN quantity > 0 THEN TRUE
        ELSE FALSE
    END AS is_valid_quantity,

    CASE
        WHEN unit_price >= 0 THEN TRUE
        ELSE FALSE
    END AS is_valid_unit_price,

    CASE
        WHEN quantity > 0
         AND unit_price >= 0
        THEN quantity * unit_price
    END AS line_revenue

FROM fact_order_items;