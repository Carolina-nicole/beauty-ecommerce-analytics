CREATE OR REPLACE TABLE fct_purchase_retention AS

WITH user_purchase_activity AS (

    SELECT DISTINCT
        o.user_id,

        l.first_order_month AS purchase_cohort_month,

        DATE_TRUNC('month', o.order_date)::DATE AS purchase_month

    FROM stg_orders AS o

    INNER JOIN int_user_lifecycle AS l
        ON o.user_id = l.user_id

    WHERE l.first_order_month IS NOT NULL
),

retention_base AS (

    SELECT
        user_id,
        purchase_cohort_month,
        purchase_month,

        DATE_DIFF(
            'month',
            purchase_cohort_month,
            purchase_month
        ) AS months_since_first_purchase

    FROM user_purchase_activity

    WHERE purchase_month >= purchase_cohort_month
),

cohort_sizes AS (

    SELECT
        first_order_month AS purchase_cohort_month,

        COUNT(DISTINCT user_id) AS cohort_size

    FROM int_user_lifecycle

    WHERE first_order_month IS NOT NULL

    GROUP BY first_order_month
)

SELECT
    r.purchase_cohort_month,
    r.months_since_first_purchase,
    c.cohort_size,

    COUNT(DISTINCT r.user_id) AS retained_purchasers,

    COUNT(DISTINCT r.user_id)::DOUBLE
        / c.cohort_size AS purchase_retention_rate

FROM retention_base AS r

INNER JOIN cohort_sizes AS c
    ON r.purchase_cohort_month = c.purchase_cohort_month

GROUP BY
    r.purchase_cohort_month,
    r.months_since_first_purchase,
    c.cohort_size

ORDER BY
    r.purchase_cohort_month,
    r.months_since_first_purchase;