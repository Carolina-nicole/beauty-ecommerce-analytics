CREATE OR REPLACE TABLE fct_conversion_funnel AS

SELECT DISTINCT
    user_id,

    DATE_TRUNC('month', event_date)::DATE AS event_month,

    device_type,
    campaign_id,

    CASE
        WHEN event_name = 'homepage_view' THEN 1
        WHEN event_name = 'product_view' THEN 2
        WHEN event_name = 'add_to_cart' THEN 3
        WHEN event_name = 'checkout_start' THEN 4
        WHEN event_name = 'purchase' THEN 5
    END AS stage_order,

    event_name AS funnel_stage

FROM stg_events

WHERE event_name IN (
    'homepage_view',
    'product_view',
    'add_to_cart',
    'checkout_start',
    'purchase'
);