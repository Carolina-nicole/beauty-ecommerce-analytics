CREATE OR REPLACE TABLE fct_product_performance AS

SELECT
    order_date,

    product_id,
    product_name,
    brand,
    category,
    subcategory,

    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT user_id) AS unique_customers,

    SUM(quantity) AS total_units_sold,
    SUM(line_revenue) AS gross_revenue,

    AVG(unit_price) AS avg_unit_price

FROM int_order_enriched

GROUP BY
    order_date,
    product_id,
    product_name,
    brand,
    category,
    subcategory;