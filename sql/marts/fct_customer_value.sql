CREATE OR REPLACE TABLE fct_customer_value AS

WITH reference_date AS (

    SELECT
        MAX(order_date) AS analysis_date
    FROM stg_orders
),

customer_orders AS (

    SELECT
        user_id,

        COUNT(DISTINCT order_id) AS total_orders,

        SUM(net_order_value) AS total_revenue,

        AVG(net_order_value) AS avg_order_value,

        MIN(order_date) AS first_order_date,

        MAX(order_date) AS last_order_date

    FROM stg_orders

    GROUP BY user_id
),

order_gaps AS (

    SELECT
        user_id,

        DATE_DIFF(
            'day',
            LAG(order_date) OVER (
                PARTITION BY user_id
                ORDER BY order_date
            ),
            order_date
        ) AS days_between_orders

    FROM stg_orders
),

avg_order_gaps AS (

    SELECT
        user_id,

        AVG(days_between_orders) AS avg_days_between_orders

    FROM order_gaps

    WHERE days_between_orders IS NOT NULL

    GROUP BY user_id
)

SELECT
    c.user_id,

    c.total_orders,

    c.total_revenue,

    c.avg_order_value,

    c.first_order_date,

    c.last_order_date,

    DATE_DIFF(
        'day',
        c.last_order_date,
        r.analysis_date
    ) AS days_since_last_order,

    DATE_DIFF(
        'day',
        c.first_order_date,
        r.analysis_date
    ) AS customer_tenure_days,

    CASE
        WHEN c.total_orders > 1
        THEN TRUE
        ELSE FALSE
    END AS is_repeat_customer,

    g.avg_days_between_orders

FROM customer_orders AS c

CROSS JOIN reference_date AS r

LEFT JOIN avg_order_gaps AS g
    ON c.user_id = g.user_id;