CREATE OR REPLACE TABLE stg_events AS

SELECT
    event_id,
    user_id,
    session_id,
    product_id,

    event_timestamp,
    DATE(event_timestamp) AS event_date,

    LOWER(TRIM(event_name)) AS event_name,
    LOWER(TRIM(platform)) AS platform,
    LOWER(TRIM(device_type)) AS device_type,
    LOWER(TRIM(page_type)) AS page_type,
    LOWER(TRIM(campaign_id)) AS campaign_id,

    CASE
        WHEN event_timestamp IS NOT NULL
        THEN TRUE
        ELSE FALSE
    END AS is_valid_event_timestamp

FROM fact_events;