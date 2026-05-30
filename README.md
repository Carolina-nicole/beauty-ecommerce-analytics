# 💄 Beauty E-commerce Product Analytics

An end-to-end analytics engineering and business intelligence project built using SQL, DuckDB, Git, and Power BI.

The project simulates a modern beauty e-commerce company and develops a production-style analytics warehouse to support acquisition, retention, conversion, revenue, and customer value analysis.

---

## 📊 Business Objectives

This project answers key business questions across:

* User acquisition and channel performance
* Customer retention and cohort analysis
* Conversion funnel optimization
* Revenue and order performance
* Product and category performance
* Customer value and repeat purchase behaviour

---

## 🏗️ Analytics Architecture

The warehouse follows a layered analytics engineering approach:

```text
Raw Data
↓
Staging Layer
↓
Intermediate Layer
↓
Mart Layer
↓
Power BI Dashboard
```

---

## 📂 Repository Structure

```text
PRODUCT_ANALYTICS/
│
├── beauty_analytics_dataset/
├── sql/
│   ├── staging/
│   ├── intermediate/
│   └── marts/
│
├── metrics_dictionary.md
├── README.md
└── beauty_analytics.duckdb
```

---

## 📈 Analytics Models

### Revenue & Commercial Performance

* fct_daily_revenue
* fct_product_performance

### Acquisition

* fct_user_acquisition

### Customer Analytics

* fct_customer_value

### Retention

* fct_session_retention
* fct_purchase_retention

### Funnel Analytics

* fct_conversion_funnel
* fct_conversion_funnel_strict

---

## 🛠️ Technology Stack

* SQL
* DuckDB
* Git & GitHub
* Power BI

---

## 📖 Documentation

Additional project documentation is available in:

* metrics_dictionary.md

---

## 📸 Dashboard Preview

Dashboard screenshots and PDF exports will be added after the Power BI development phase.

---

## 🚀 Project Status

✅ Data warehouse completed

✅ Mart layer completed

✅ Metrics dictionary completed

🔄 Power BI dashboard development in progress
