CREATE OR REPLACE TABLE fct_user_acquisition AS

SELECT
    c.cohort_month,

    c.acquisition_channel,
    c.first_touch_source,
    c.first_touch_medium,
    c.first_touch_campaign,

    COUNT(DISTINCT c.user_id) AS total_users,

    COUNT(DISTINCT CASE
        WHEN l.first_session_date IS NOT NULL
            THEN c.user_id
    END) AS activated_users,

    COUNT(DISTINCT CASE
        WHEN l.first_order_date IS NOT NULL
            THEN c.user_id
    END) AS purchasing_users,

    COUNT(DISTINCT CASE
        WHEN l.first_session_date IS NOT NULL
            THEN c.user_id
    END)::DOUBLE
    / COUNT(DISTINCT c.user_id) AS activation_rate,

    COUNT(DISTINCT CASE
        WHEN l.first_order_date IS NOT NULL
            THEN c.user_id
    END)::DOUBLE
    / COUNT(DISTINCT c.user_id) AS purchase_rate,

    AVG(l.days_to_first_order) AS avg_days_to_first_order

FROM int_user_cohorts AS c

LEFT JOIN int_user_lifecycle AS l
    ON c.user_id = l.user_id

GROUP BY
    c.cohort_month,
    c.acquisition_channel,
    c.first_touch_source,
    c.first_touch_medium,
    c.first_touch_campaign;