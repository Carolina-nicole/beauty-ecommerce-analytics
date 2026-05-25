CREATE OR REPLACE TABLE int_sessions_enriched AS

WITH session_sequence AS (

    SELECT
        session_id,
        user_id,

        session_start,
        session_end,
        session_start_date,
        session_end_date,
        session_duration,

        EXTRACT(EPOCH FROM session_duration) / 60 AS session_duration_minutes,

        traffic_source,
        traffic_medium,
        campaign_name,
        device_type,
        country,

        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY session_start ASC
        ) AS session_order,

        LAG(session_start_date) OVER (
            PARTITION BY user_id
            ORDER BY session_start ASC
        ) AS previous_session_date,

        FIRST_VALUE(session_start_date) OVER (
            PARTITION BY user_id
            ORDER BY session_start ASC
        ) AS first_session_date

    FROM stg_sessions
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

    previous_session_date,

    DATE_DIFF('day', previous_session_date, session_start_date)
        AS days_between_sessions,

    DATE_DIFF('day', first_session_date, session_start_date)
        AS days_since_first_session,

    CASE
        WHEN session_duration_minutes < 10 THEN 'short'
        WHEN session_duration_minutes < 30 THEN 'medium'
        ELSE 'long'
    END AS session_duration_bucket

FROM session_sequence;