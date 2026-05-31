# Dashboard Blueprint

## Dashboard Narrative

The dashboard follows the customer lifecycle:

**Acquire → Convert → Generate Revenue → Retain → Create Customer Value**

The objective is to guide stakeholders through the full ecommerce journey, from acquisition to long-term customer value.

---

# Page 1: Executive Overview

## Business Question

How is the business performing and growing over time?

## Sub-Questions

* How large is the business?
* Is the business growing?
* What drives growth?
* Is growth supported by a healthy customer base?

## KPIs

* Total Revenue
* Total Orders
* Purchasing Customers
* Average Order Value (AOV)
* Repeat Customer Rate

## Visuals

* Revenue Trend by Month
* Orders Trend by Month
* Revenue by Category

## Executive Takeaway

Understand the scale, growth, and overall health of the business.

## Data Sources

* fct_daily_revenue
* fct_customer_value

---

# Page 2: Acquisition & Conversion

## Business Question

How effectively are acquired users converting into customers?

## Sub-Questions

* How many users convert into purchasing customers?
* Which acquisition channels are most effective?
* Where are users dropping off in the conversion funnel?

## KPIs

* Acquired Users
* Purchasing Customers
* Purchase Conversion Rate
* Add-to-Cart Rate
* Checkout Completion Rate

## Visuals

* Non-Strict Funnel
* Strict Funnel
* Conversion Rate by Acquisition Channel
* Conversion Rate by Device
* Conversion Rate Trend Over Time (Optional)

## Executive Takeaway

Understand how effectively users move through the conversion funnel and where the largest opportunities for conversion improvement exist.

## Data Sources

* fct_user_acquisition
* fct_conversion_funnel
* fct_conversion_funnel_strict

---

# Page 3: Revenue & Product Performance

## Business Question

How is revenue evolving and what is driving it?

## Sub-Questions

* How much revenue is the business generating?
* Is revenue growing over time?
* Which products and categories drive revenue?

## KPIs

* Total Revenue
* Total Orders
* Purchasing Customers
* Average Order Value (AOV)

## Visuals

* Revenue Trend by Month
* Revenue by Category
* Top Products by Revenue
* Average Order Value Trend (Optional)

## Executive Takeaway

Understand which products and categories drive revenue growth and where the greatest commercial opportunities exist.

## Data Sources

* fct_daily_revenue
* fct_product_performance

---

# Page 4: Retention & Customer Value

## Business Question

Is the business sustained by a healthy customer base?

## Sub-Questions

* How many times are customers buying?
* How often are customers buying?
* How long do customers remain active?

## KPIs

* Session Retention Rate
* Purchase Retention Rate
* Average Orders per Customer
* Average Days Between Orders
* Repeat Customer Rate

## Visuals

* Session Retention Heatmap
* Purchase Retention Heatmap
* Orders per Customer Distribution
* Average Days Between Orders Distribution

## Executive Takeaway

Understand whether customers return, how frequently they purchase, and the long-term value they generate for the business.

## Data Sources

* fct_session_retention
* fct_purchase_retention
* fct_customer_value

---

# Design Principles

* One primary business question per page.
* Each visual should answer a single business question.
* Dashboard follows the customer lifecycle.
* Consistent KPI definitions across all pages.
* Minimal visual clutter.
* Executive-friendly storytelling.
* Detailed analysis progresses from acquisition to customer value.
* Dashboard design may evolve during development while preserving the overall narrative.
