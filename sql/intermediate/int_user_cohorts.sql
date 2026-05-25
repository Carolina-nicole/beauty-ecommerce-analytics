CREATE OR REPLACE TABLE int_user_cohorts AS

WITH ranked_sessions AS (

    SELECT
        user_id,
        session_id,
        session_start_date,
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
        session_start_date AS first_session_date,

        DATE_TRUNC('week', session_start_date)::DATE AS cohort_week,
        DATE_TRUNC('month', session_start_date)::DATE AS cohort_month,

        traffic_source AS first_touch_source,
        traffic_medium AS first_touch_medium,
        campaign_name AS first_touch_campaign

    FROM ranked_sessions

    WHERE session_order = 1
)

SELECT
    u.user_id,

    ft.first_session_date,
    ft.cohort_week,
    ft.cohort_month,

    u.signup_date,
    u.signup_month,
    u.acquisition_channel,

    ft.first_touch_source,
    ft.first_touch_medium,
    ft.first_touch_campaign

FROM stg_users AS u

LEFT JOIN first_touch AS ft
    ON u.user_id = ft.user_id;