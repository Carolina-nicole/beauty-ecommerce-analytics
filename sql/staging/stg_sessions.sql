CREATE OR REPLACE TABLE stg_sessions AS

SELECT
    session_id,
    user_id,

    session_start,
    session_end,

    DATE(session_start) AS session_start_date,
    DATE(session_end) AS session_end_date,

    LOWER(TRIM(traffic_source)) AS traffic_source,
    LOWER(TRIM(traffic_medium)) AS traffic_medium,
    LOWER(TRIM(campaign_name)) AS campaign_name,
    LOWER(TRIM(device_type)) AS device_type,
    LOWER(TRIM(country)) AS country,

    /* validation flags */

    CASE
        WHEN session_start IS NOT NULL
        THEN TRUE
        ELSE FALSE
    END AS is_valid_session_start,

    CASE
        WHEN session_end IS NULL
          OR session_end >= session_start
        THEN TRUE
        ELSE FALSE
    END AS is_valid_session_end,

    /* derived metric */

    CASE
        WHEN session_end >= session_start
        THEN session_end - session_start
    END AS session_duration

FROM fact_sessions;