# goexplore_kpi_dashboard_market_analysis
Business KPI dashboard and market analysis project using Google Sheets, BigQuery, and Looker Studio/Data Studio.

This project presents a business analytics solution for GoExplore, a camping and hiking equipment supplier with strong year-on-year growth.

The goal was to move from a raw spreadsheet to a structured analytics workflow, including spreadsheet analysis, BigQuery data modelling, and business KPI dashboards.

## Project Overview

GoExplore needed a clearer view of business performance across markets, retailers, products, and sales channels.

The project focused on preparing the data, defining relevant KPIs, querying the data in BigQuery, and building dashboards to support business decision-making.

## Business Questions

### 1. European Market Expansion

GoExplore wanted to evaluate potential expansion into new European countries (the Czech Republic, Norway, Poland, and Portugal) by comparing them with existing GoExplore markets using indicators such as revenue performance, performance patterns, population, GDP, and regional similarity.

### 2. Specialty vs General Retailers

The business also wanted to understand whether specialty retailers perform differently from general retailers.

Specialty retailers include stores focused on a specific product range, such as Golf Shops or Eyewear Stores. General retailers include broader stores such as Sports Stores or Outdoors Shops.

The comparison focused on business metrics such as:
- Average order value
- Average product price
- Number of orders per retailer
- Revenue contribution by retailer type


## Key KPIs and Insights

| KPI | Finding |
|---|---|
| Revenue Growth | Revenue increased by **33% in 2016** and **24% in 2017**, showing strong and consistent growth. |
| Top Markets | The strongest markets were the **USA (15.8%)**, **UK (8.6%)**, and **Germany (8.4%)**. |
| Specialty vs General Stores | **Golf Shops** had a much higher average order value than **Sports Stores**: **€14,640 vs €5,245**. |
| Order Methods | Web orders dominated, with **124K out of around 149K total orders**. |
| Highest Discounts | **Brazil** had the highest discount rate at **4.36%**, but contributed a relatively low revenue share. |

## Data Workflow

```text
Original spreadsheet
        ↓
Google Sheets review
        ↓
BigQuery
        ↓
SQL queries and KPI calculations
        ↓
Looker Studio dashboards
        ↓
Final business presentation
```

## Dashboard

The main KPI dashboard is included in the dashboards/ folder as a PDF export or screenshot.

The dashboard provides an overview of revenue performance, market trends, retailer behaviour, order channels, and discount patterns.

## How to Use This Repository

* Open the dashboard files in dashboards/ to review the final KPI report.
* Review the SQL queries in bigquery_queries/ to understand how the KPIs were calculated.
* Check the original spreadsheet in raw_data/ to see the starting dataset.
* Open the files in presentation/ to review the final business recommendation.

## Project Collaboration

This was completed as a collaborative analytics project.
Contributors:
* Aylin Yildiz
* Mohammad Yahya Faqirzada
* Sarah Alkhaledova
* Satish Shrestha


## Tools Used

- Google Sheets
- BigQuery
- SQL
- Looker Studio
- Data modelling
- Dashboard design

## Repository Structure

```text
raw_data/              Original spreadsheet data
bigquery/      SQL queries used for analysis and KPI calculation
dashboards/            Looker Studio dashboard screenshots or PDF exports
presentation/          Final stakeholder presentation
images/                Supporting visuals and project screenshots
