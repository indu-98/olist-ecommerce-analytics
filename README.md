# Olist E-Commerce Analytics

## Overview
End-to-end analytics project on 96K+ customers and 99K+ orders from a Brazilian 
e-commerce platform. Built using Snowflake for data modeling and SQL analysis, 
with Power BI for interactive visualization via a live connection.

## Tools
Snowflake, SQL (CTEs, window functions, views), Power BI

## Key Findings
- Only 3.12% of customers placed more than one order (2,997 of 96,096 total)
- RFM segmentation: just 1.07% of customers are "Champions" (frequent, recent 
  buyers); 38.29% are "At Risk" and 21.71% "Needs Attention"
- Cohort retention drops below 1% by month 6 across nearly all cohorts
- Revenue grew steadily through 2017, plateauing around 900K-1.2M/month from 
  late 2017 onward

## Business Insight
Three independent methods (RFM segmentation, cohort retention analysis, and 
repeat purchase rate) all confirm the same finding: Olist's growth is almost 
entirely acquisition-driven, with minimal organic repeat purchasing. 
Recommendation: prioritize first-purchase experience and acquisition efficiency 
over loyalty programs, since repeat buying behavior is rare across the customer base.

## Dashboard
See `dashboard/` folder for screenshots of all 3 report pages:
1. Executive Overview - KPIs and revenue trend
2. Customer Segmentation - RFM analysis
3. Cohort Retention - month-over-month retention heatmap

## Data Model
7 relational tables (customers, orders, order_items, payments, products, 
sellers, category_translation) plus 5 analytical views built in Snowflake 
(RFM segmentation, cohort retention, MoM growth, delivery performance, 
repeat customer rate), connected live to Power BI.

## Files
- `sql/` - schema and all analysis queries/views
- `dashboard/` - dashboard screenshots and .pbix file
