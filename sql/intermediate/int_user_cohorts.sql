CREATE OR REPLACE TABLE int_user_cohorts AS

WITH ranked_sessions AS (
    SELECT
        user_id,
        session_id,
        session_start,
        traffic_source,
        traffic_medium,
        campaign_name,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY session_start ASC
        ) AS session_order
    FROM stg_sessions
),

first_touch AS (
    SELECT
        user_id,
        traffic_source AS first_touch_source,
        traffic_medium AS first_touch_medium,
        campaign_name AS first_touch_campaign
    FROM ranked_sessions
    WHERE session_order = 1
)

SELECT
    u.user_id,
    u.signup_date,
    u.signup_month AS cohort_month,
    u.acquisition_channel,
    ft.first_touch_source,
    ft.first_touch_medium,
    ft.first_touch_campaign
FROM stg_users AS u
LEFT JOIN first_touch AS ft
    ON u.user_id = ft.user_id;