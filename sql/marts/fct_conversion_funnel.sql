CREATE OR REPLACE TABLE fct_conversion_funnel_non_strict AS

WITH user_stage_flags AS (

    SELECT
        user_id,

        MAX(CASE WHEN event_name = 'homepage_view' THEN 1 ELSE 0 END) AS reached_homepage_view,
        MAX(CASE WHEN event_name = 'product_view' THEN 1 ELSE 0 END) AS reached_product_view,
        MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS reached_add_to_cart,
        MAX(CASE WHEN event_name = 'checkout_start' THEN 1 ELSE 0 END) AS reached_checkout_start,
        MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS reached_purchase

    FROM stg_events

    GROUP BY user_id
),

funnel_counts AS (

    SELECT
        SUM(reached_homepage_view) AS homepage_users,
        SUM(reached_product_view) AS product_view_users,
        SUM(reached_add_to_cart) AS add_to_cart_users,
        SUM(reached_checkout_start) AS checkout_start_users,
        SUM(reached_purchase) AS purchase_users
    FROM user_stage_flags
)

SELECT 1 AS stage_order, 'homepage_view' AS funnel_stage, homepage_users AS users_reached
FROM funnel_counts

UNION ALL

SELECT 2, 'product_view', product_view_users
FROM funnel_counts

UNION ALL

SELECT 3, 'add_to_cart', add_to_cart_users
FROM funnel_counts

UNION ALL

SELECT 4, 'checkout_start', checkout_start_users
FROM funnel_counts

UNION ALL

SELECT 5, 'purchase', purchase_users
FROM funnel_counts

ORDER BY stage_order;