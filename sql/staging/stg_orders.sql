CREATE OR REPLACE TABLE stg_orders AS

SELECT
    order_id,
    user_id,
    order_timestamp,
    DATE(order_timestamp) AS order_date,

    order_value,
    discount_amount,
    shipping_cost,

    CASE
        WHEN order_value >= 0 THEN TRUE
        ELSE FALSE
    END AS is_valid_order_value,

    CASE
        WHEN discount_amount IS NULL OR discount_amount >= 0 THEN TRUE
        ELSE FALSE
    END AS is_valid_discount_amount,

    CASE
        WHEN shipping_cost IS NULL OR shipping_cost >= 0 THEN TRUE
        ELSE FALSE
    END AS is_valid_shipping_cost,

    CASE
        WHEN order_value >= 0
         AND (discount_amount IS NULL OR discount_amount >= 0)
        THEN order_value - COALESCE(discount_amount, 0)
    END AS net_order_value,

    LOWER(TRIM(payment_method)) AS payment_method,
    LOWER(TRIM(delivery_type)) AS delivery_type,
    CAST(is_first_order AS BOOLEAN) AS is_first_order

FROM fact_orders;