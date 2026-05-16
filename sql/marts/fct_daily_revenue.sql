CREATE OR REPLACE TABLE fct_daily_revenue AS

WITH order_level AS (

    SELECT
        order_id,
        user_id,
        order_date,

        SUM(quantity) AS total_items,

        SUM(line_revenue) AS gross_order_revenue,

        MAX(order_value) AS order_value,
        MAX(discount_amount) AS discount_amount,
        MAX(shipping_cost) AS shipping_cost,
        MAX(net_order_value) AS net_order_value

    FROM int_order_enriched

    GROUP BY
        order_id,
        user_id,
        order_date
)

SELECT
    order_date,

    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT user_id) AS unique_customers,

    SUM(total_items) AS total_items_sold,

    SUM(gross_order_revenue) AS gross_revenue,

    SUM(net_order_value) AS net_revenue,

    AVG(net_order_value) AS avg_order_value,

    SUM(net_order_value) / COUNT(DISTINCT user_id) AS avg_revenue_per_customer

FROM order_level

GROUP BY order_date;