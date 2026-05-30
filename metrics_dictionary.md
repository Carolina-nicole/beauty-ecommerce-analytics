# Product Analytics Metrics Dictionary

## 1. Project Overview

This project simulates a modern ecommerce analytics warehouse for a beauty retailer.

The warehouse was built using DuckDB and follows a layered architecture consisting of staging, intermediate, and mart models.

The objective of the warehouse is to support:

- Revenue analysis
- Product performance analysis
- Acquisition analysis
- Customer value analysis
- Retention analysis
- Funnel analysis

The mart layer serves as the semantic layer for business intelligence reporting and dashboard development.


## 2. Mart Dictionary

### Revenue & Commercial Performance

### fct_daily_revenue

**Purpose**

Provides daily revenue and order performance metrics for trend analysis.

**Grain**

One row per order date.

**Source Tables**

- stg_orders

**Key Metrics**

- order_date
- total_orders
- total_revenue
- average_order_value


### fct_product_performance

**Purpose**

Measures product and category performance based on sales activity and revenue generation.

**Grain**

One row per product.

**Source Tables**

- int_order_enriched
- stg_products

**Key Metrics**

- product_id
- product_name
- category
- units_sold
- total_revenue
- total_orders


### Acquisition

### fct_user_acquisition

**Purpose**

Measures user acquisition performance by signup cohort and acquisition channel.

**Grain**

One row per acquisition channel and signup month.

**Source Tables**

- int_user_cohorts

**Key Metrics**

- cohort_month
- acquisition_channel
- acquired_users


### Customer Analytics

### fct_customer_value

**Purpose**

Customer-level metrics for customer value, purchase frequency, and recency analysis.

**Grain**

One row per purchasing customer (`user_id`).

**Source Tables**

- stg_orders

**Key Metrics**

- total_orders
- total_revenue
- avg_order_value
- first_order_date
- last_order_date
- days_since_last_order
- customer_tenure_days
- is_repeat_customer
- avg_days_between_orders


### Retention

### fct_session_retention

**Purpose**

Measures user retention based on session activity after signup.

**Grain**

One row per signup cohort month and months since cohort.

**Source Tables**

- int_user_cohorts
- int_sessions_enriched

**Key Metrics**

- cohort_month
- months_since_cohort
- cohort_size
- retained_users
- retention_rate

### fct_purchase_retention

**Purpose**

Measures customer retention based on repeat purchasing behaviour.

**Grain**

One row per purchase cohort month and months since first purchase.

**Source Tables**

- stg_orders
- int_user_lifecycle

**Key Metrics**

- purchase_cohort_month
- months_since_first_purchase
- cohort_size
- retained_purchasers
- purchase_retention_rate


### Funnel Analytics

### fct_conversion_funnel

**Purpose**

Measures user progression through the ecommerce funnel using a non-strict funnel definition.

**Grain**

One row per user, funnel stage, event month, device type, and campaign.

**Source Tables**

- stg_events

**Key Metrics**

- user_id
- event_month
- device_type
- campaign_id
- funnel_stage
- stage_order


### fct_conversion_funnel_strict

**Purpose**

Measures user progression through the ecommerce funnel using a strict sequential funnel definition.

**Grain**

One row per user, funnel stage, event month, device type, and campaign.

**Source Tables**

- stg_events

**Key Metrics**

- user_id
- event_month
- device_type
- campaign_id
- funnel_stage
- stage_order


## 3. KPI Definitions

### Total Revenue

**Definition**

Sum of net order value across all orders.

**Formula**

total_revenue = SUM(net_order_value)

**Notes**

Net order value is calculated as:

net_order_value = order_value - discount_amount

Shipping costs are excluded from revenue calculations.


### Average Order Value (AOV)

**Definition**

Average revenue generated per order.

**Formula**

AOV = total_revenue / total_orders


### Repeat Customer

**Definition**

A customer who has placed more than one order.

**Formula**

is_repeat_customer = total_orders > 1


### Purchase Retention Rate

**Definition**

Percentage of customers within a purchase cohort who made a purchase in a subsequent month.

**Formula**

purchase_retention_rate = retained_purchasers / cohort_size


### Session Retention Rate

**Definition**

Percentage of users within a signup cohort who remained active in subsequent months.

An active user is defined as a user with at least one session during the month.

**Formula**

retention_rate = retained_users / cohort_size


### Average Days Between Orders

**Definition**

Average number of days between consecutive customer purchases.

**Methodology**

Calculated using the true average gap between orders based on the LAG() window function.


### Days Since Last Order

**Definition**

Number of days between a customer's most recent order and the dataset analysis date.

**Formula**

days_since_last_order = analysis_date - last_order_date

**Notes**

The analysis date is defined as the latest order date available in the dataset.


### Customer Tenure

**Definition**

Number of days between a customer's first order and the dataset analysis date.

**Formula**

customer_tenure_days = analysis_date - first_order_date


### Funnel Conversion

**Definition**

Percentage of users who progress from one funnel stage to the next.

**Funnel Stages**

1. homepage_view
2. product_view
3. add_to_cart
4. checkout_start
5. purchase


## 4. Business Assumptions

### Funnel Definitions

Two funnel methodologies are implemented.

#### Non-Strict Funnel

Users are counted independently at each funnel stage.

#### Strict Funnel

Users must progress sequentially through all previous stages to be counted in subsequent stages.

---

### Customer Value Metrics

Customer value metrics are calculated only for users with at least one purchase.

Users without purchases are excluded from the customer value mart.

---

### Recency Metrics

Recency calculations use the latest order date available in the dataset as the analysis date.

This approach avoids distortions caused by comparing historical or synthetic data to the current calendar date.

---

## 4. Business Assumptions

### Funnel Definitions

Two funnel methodologies are implemented:

#### Non-Strict Funnel

Users are counted independently at each funnel stage.

#### Strict Funnel

Users must progress sequentially through all previous stages to be counted in subsequent stages.

### Funnel Scope

The `signup` event is excluded from the funnel.

Analysis showed that users could sign up before adding products to their cart, after adding products to their cart, or never sign up at all. As a result, signup was not considered a consistent step in the ecommerce conversion journey.

The funnel focuses on the core purchase path:

`homepage_view → product_view → add_to_cart → checkout_start → purchase`

### Customer Value Metrics

Customer value metrics are calculated only for users with at least one purchase.

Users without purchases are excluded from the customer value mart.

### Recency Metrics

Recency metrics use the latest order date available in the dataset as the analysis date rather than the current calendar date.