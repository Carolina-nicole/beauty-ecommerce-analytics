CREATE OR REPLACE TABLE fct_session_retention AS

WITH user_activity AS (

    SELECT DISTINCT
        s.user_id,

        c.cohort_month,

        DATE_TRUNC(
            'month',
            s.session_start_date
        )::DATE AS activity_month

    FROM stg_sessions AS s

    INNER JOIN int_user_cohorts AS c
        ON s.user_id = c.user_id
),

retention_base AS (

    SELECT
        user_id,

        cohort_month,
        activity_month,

        DATE_DIFF(
            'month',
            cohort_month,
            activity_month
        ) AS months_since_cohort

    FROM user_activity

    WHERE activity_month >= cohort_month
),

cohort_sizes AS (

    SELECT
        cohort_month,

        COUNT(DISTINCT user_id) AS cohort_size

    FROM int_user_cohorts

    GROUP BY cohort_month
)

SELECT
    r.cohort_month,

    r.months_since_cohort,

    c.cohort_size,

    COUNT(DISTINCT r.user_id) AS retained_users,

    COUNT(DISTINCT r.user_id)::DOUBLE
        / c.cohort_size AS retention_rate

FROM retention_base AS r

INNER JOIN cohort_sizes AS c
    ON r.cohort_month = c.cohort_month

GROUP BY
    r.cohort_month,
    r.months_since_cohort,
    c.cohort_size

ORDER BY
    r.cohort_month,
    r.months_since_cohort;