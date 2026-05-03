CREATE OR REPLACE TABLE stg_users AS

SELECT
    user_id,

    CAST(signup_date AS DATE) AS signup_date,

    DATE_TRUNC('month', signup_date) AS signup_month,

    LOWER(TRIM(acquisition_channel)) AS acquisition_channel,

    LOWER(TRIM(country)) AS country,

    LOWER(TRIM(state_region)) AS state_region,

    LOWER(TRIM(device_first_used)) AS device_first_used,

    LOWER(TRIM(preferred_category)) AS preferred_category,

    CAST(loyalty_member_flag AS BOOLEAN) AS loyalty_member_flag,

    CAST(email_opt_in_flag AS BOOLEAN) AS email_opt_in_flag,

    birth_year,

    EXTRACT(YEAR FROM CURRENT_DATE) - birth_year AS age,

    CASE
        WHEN signup_date IS NOT NULL
        THEN TRUE
        ELSE FALSE
    END AS is_valid_signup_date

FROM dim_users;