CREATE OR REPLACE TABLE int_user_lifecycle AS

WITH ranked_sessions AS (
    SELECT
        user_id,
        session_start,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY session_start ASC
        ) AS session_order
    FROM stg_sessions
),

first_session AS (
    SELECT
        user_id,
        DATE(session_start) AS first_session_date
    FROM ranked_sessions
    WHERE session_order = 1
),

ranked_orders AS (
    SELECT
        user_id,
        order_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY order_timestamp ASC
        ) AS order_rank
    FROM stg_orders
),

first_order AS (
    SELECT
        user_id,
        DATE(order_timestamp) AS first_order_date
    FROM ranked_orders
    WHERE order_rank = 1
)

SELECT
    u.user_id,
    u.signup_date,

    fs.first_session_date,
    fo.first_order_date,

    DATE_DIFF('day', u.signup_date, fs.first_session_date)
        AS days_to_first_session,

    DATE_DIFF('day', u.signup_date, fo.first_order_date)
        AS days_to_first_order,

    CASE
        WHEN fs.first_session_date IS NOT NULL
        THEN TRUE
        ELSE FALSE
    END AS has_started_session,

    CASE
        WHEN fo.first_order_date IS NOT NULL
        THEN TRUE
        ELSE FALSE
    END AS has_purchased

FROM stg_users AS u

LEFT JOIN first_session AS fs
    ON u.user_id = fs.user_id

LEFT JOIN first_order AS fo
    ON u.user_id = fo.user_id;