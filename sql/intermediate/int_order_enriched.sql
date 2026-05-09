CREATE OR REPLACE TABLE int_order_enriched AS

SELECT
    oi.order_id,
    o.user_id,
    o.order_timestamp,
    o.order_date,

    oi.product_id,
    p.product_name,
    p.brand,
    p.category,
    p.subcategory,

    oi.quantity,
    oi.unit_price,
    oi.line_revenue,

    o.order_value,
    o.discount_amount,
    o.shipping_cost,
    o.net_order_value,

    o.payment_method,
    o.delivery_type,
    o.is_first_order

FROM stg_order_items AS oi

LEFT JOIN stg_orders AS o
    ON oi.order_id = o.order_id

LEFT JOIN stg_products AS p
    ON oi.product_id = p.product_id;