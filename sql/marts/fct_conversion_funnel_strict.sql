CREATE OR REPLACE TABLE fct_conversion_funnel_strict AS

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

strict_users AS (

    SELECT
        user_id,

        reached_homepage_view,

        CASE
            WHEN reached_homepage_view = 1
             AND reached_product_view = 1
            THEN 1
            ELSE 0
        END AS reached_product_view,

        CASE
            WHEN reached_homepage_view = 1
             AND reached_product_view = 1
             AND reached_add_to_cart = 1
            THEN 1
            ELSE 0
        END AS reached_add_to_cart,

        CASE
            WHEN reached_homepage_view = 1
             AND reached_product_view = 1
             AND reached_add_to_cart = 1
             AND reached_checkout_start = 1
            THEN 1
            ELSE 0
        END AS reached_checkout_start,

        CASE
            WHEN reached_homepage_view = 1
             AND reached_product_view = 1
             AND reached_add_to_cart = 1
             AND reached_checkout_start = 1
             AND reached_purchase = 1
            THEN 1
            ELSE 0
        END AS reached_purchase

    FROM user_stage_flags
),

user_dimensions AS (

    SELECT DISTINCT
        user_id,

        DATE_TRUNC('month', event_date)::DATE AS event_month,

        device_type,
        campaign_id

    FROM stg_events
),

final_funnel AS (

    SELECT
        d.user_id,
        d.event_month,
        d.device_type,
        d.campaign_id,

        1 AS stage_order,
        'homepage_view' AS funnel_stage

    FROM strict_users AS s

    INNER JOIN user_dimensions AS d
        ON s.user_id = d.user_id

    WHERE s.reached_homepage_view = 1

    UNION ALL

    SELECT
        d.user_id,
        d.event_month,
        d.device_type,
        d.campaign_id,

        2,
        'product_view'

    FROM strict_users AS s

    INNER JOIN user_dimensions AS d
        ON s.user_id = d.user_id

    WHERE s.reached_product_view = 1

    UNION ALL

    SELECT
        d.user_id,
        d.event_month,
        d.device_type,
        d.campaign_id,

        3,
        'add_to_cart'

    FROM strict_users AS s

    INNER JOIN user_dimensions AS d
        ON s.user_id = d.user_id

    WHERE s.reached_add_to_cart = 1

    UNION ALL

    SELECT
        d.user_id,
        d.event_month,
        d.device_type,
        d.campaign_id,

        4,
        'checkout_start'

    FROM strict_users AS s

    INNER JOIN user_dimensions AS d
        ON s.user_id = d.user_id

    WHERE s.reached_checkout_start = 1

    UNION ALL

    SELECT
        d.user_id,
        d.event_month,
        d.device_type,
        d.campaign_id,

        5,
        'purchase'

    FROM strict_users AS s

    INNER JOIN user_dimensions AS d
        ON s.user_id = d.user_id

    WHERE s.reached_purchase = 1
)

SELECT DISTINCT *
FROM final_funnel;