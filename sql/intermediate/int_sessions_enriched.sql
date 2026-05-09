CREATE OR REPLACE TABLE int_sessions_enriched AS

WITH sessions_with_user AS (
    SELECT
        s.session_id,
        s.user_id,

        s.session_start,
        s.session_end,
        s.session_start_date,
        s.session_end_date,
        s.session_duration,

        EXTRACT(EPOCH FROM s.session_duration) / 60 AS session_duration_minutes,

        s.traffic_source,
        s.traffic_medium,
        s.campaign_name,
        s.device_type,
        s.country,

        u.signup_date
    FROM stg_sessions AS s
    LEFT JOIN stg_users AS u
        ON s.user_id = u.user_id
),

session_sequence AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY session_start ASC
        ) AS session_order,

        LAG(session_start) OVER (
            PARTITION BY user_id
            ORDER BY session_start ASC
        ) AS previous_session_start
    FROM sessions_with_user
)

SELECT
    session_id,
    user_id,

    session_start,
    session_end,
    session_start_date,
    session_end_date,
    session_duration,
    session_duration_minutes,

    traffic_source,
    traffic_medium,
    campaign_name,
    device_type,
    country,

    session_order,

    CASE
        WHEN session_order = 1 THEN TRUE
        ELSE FALSE
    END AS is_first_session,

    previous_session_start,

    DATE_DIFF('day', previous_session_start, session_start)
        AS days_between_sessions,

    DATE_DIFF('day', signup_date, session_start_date)
        AS days_since_signup,

    CASE
        WHEN session_duration_minutes < 10
            THEN 'short'

        WHEN session_duration_minutes < 30
            THEN 'medium'

        ELSE 'long'
    END AS session_duration_bucket

FROM session_sequence;