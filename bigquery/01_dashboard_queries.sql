-- =====================================================
-- Dashboard Queries
-- GoExplore KPI Dashboard and Market Analysis
-- =====================================================
--
-- Purpose:
-- This file contains the final BigQuery SQL queries used
-- to prepare datasets for the Looker Studio dashboard pages.
--
-- Dashboard pages supported:
-- - Market Expansion Dashboard
-- - Performance and Product Analysis Dashboard
-- - Store and Product Dashboard
-- - Performance over Time Dashboard
--
-- Tables used:
-- - project-goexplore.goexplore.daily_sales
-- - project-goexplore.goexplore.retailers
-- - project-goexplore.goexplore.products
-- - project-goexplore.goexplore.methods
-- =====================================================


-- -----------------------------------------------------
-- 1. Market Expansion Dashboard Query
-- -----------------------------------------------------
--
-- Purpose:
-- Prepares country-level KPI data for the market expansion dashboard.
-- The query calculates retailer count, sales records, quantity sold,
-- total revenue, revenue per retailer, average unit price, and revenue share.
--
-- Business use:
-- Helps compare GoExplore's existing markets and identify countries
-- that can be used as benchmarks for future European expansion.
--
-- Key metrics:
-- - Total revenue
-- - Revenue share by country
-- - Retailer count
-- - Revenue per retailer
-- - Average unit price
-- - Total quantity sold
-- -----------------------------------------------------

SELECT
    r.country,
    COUNT(DISTINCT r.retailer_code) AS retailer_count,
    COUNT(*) AS sales_records,
    SUM(ds.quantity) AS total_quantity,

    ROUND(
        SUM(ds.quantity * ds.unit_sale_price),
        2
    ) AS total_revenue,

    ROUND(
        SUM(ds.quantity * ds.unit_sale_price)
        / NULLIF(COUNT(DISTINCT r.retailer_code), 0),
        2
    ) AS revenue_per_retailer,

    ROUND(
        SUM(ds.quantity * ds.unit_sale_price)
        / NULLIF(SUM(ds.quantity), 0),
        2
    ) AS avg_unit_price,

    ROUND(
        SUM(ds.quantity * ds.unit_sale_price)
        / NULLIF(
            (
                SELECT
                    SUM(ds_total.quantity * ds_total.unit_sale_price)
                FROM `project-goexplore.goexplore.daily_sales` AS ds_total
            ),
            0
        )
        * 100,
        2
    ) AS revenue_share_percent

FROM `project-goexplore.goexplore.daily_sales` AS ds
JOIN `project-goexplore.goexplore.retailers` AS r
    ON ds.retailer_code = r.retailer_code

GROUP BY
    r.country

ORDER BY
    total_revenue DESC;
    
-- -----------------------------------------------------
-- 2. Store and Product Dashboard Query
-- -----------------------------------------------------
--
-- Purpose:
-- Prepares data for comparing product performance across store categories.
-- The query calculates store count, sales records, quantity sold,
-- total revenue, revenue per store, orders per store, average product price,
-- and average order value proxy.
--
-- Business use:
-- Helps evaluate whether specialty retailers perform differently
-- from general retailers and supports product/store performance analysis.
--
-- Store category logic:
-- - Specialty: Golf Shop, Eyewear Store
-- - General: Sports Store, Outdoors Shop
--
-- Key metrics:
-- - Total revenue
-- - Revenue per store
-- - Orders per store
-- - Average product price
-- - Average order value proxy
-- - Total quantity sold
-- -----------------------------------------------------

SELECT
    CASE
        WHEN r.type IN ('Golf Shop', 'Eyewear Store') THEN 'Specialty'
        WHEN r.type IN ('Sports Store', 'Outdoors Shop') THEN 'General'
        ELSE 'Other'
    END AS store_category,

    r.type AS retailer_type,
    p.product_type,
    r.country,

    COUNT(DISTINCT r.retailer_code) AS store_count,
    COUNT(*) AS sales_records,
    SUM(ds.quantity) AS total_quantity,

    ROUND(
        SUM(ds.quantity * ds.unit_sale_price),
        2
    ) AS total_revenue,

    ROUND(
        SUM(ds.quantity * ds.unit_sale_price)
        / NULLIF(COUNT(DISTINCT r.retailer_code), 0),
        2
    ) AS revenue_per_store,

    ROUND(
        COUNT(*)
        / NULLIF(COUNT(DISTINCT r.retailer_code), 0),
        2
    ) AS orders_per_store,

    ROUND(
        SUM(ds.quantity * ds.unit_sale_price)
        / NULLIF(SUM(ds.quantity), 0),
        2
    ) AS avg_product_price,

    ROUND(
        AVG(ds.quantity * ds.unit_sale_price),
        2
    ) AS avg_order_value_proxy

FROM `project-goexplore.goexplore.daily_sales` AS ds
JOIN `project-goexplore.goexplore.retailers` AS r
    ON ds.retailer_code = r.retailer_code
JOIN `project-goexplore.goexplore.products` AS p
    ON ds.product_number = p.product_number

WHERE
    r.type IN ('Golf Shop', 'Eyewear Store', 'Sports Store', 'Outdoors Shop')

GROUP BY
    store_category,
    retailer_type,
    p.product_type,
    r.country

ORDER BY
    total_revenue DESC; 
    
-- -----------------------------------------------------
-- 3. Performance and Product Analysis Dashboard Query
-- -----------------------------------------------------
--
-- Purpose:
-- Prepares product-level KPI data for the product analysis dashboard.
-- The query calculates sales records, quantity sold, total revenue,
-- average unit price, and product ranking by country.
--
-- Business use:
-- Helps identify top-performing products, product types, retailer types,
-- and country-level product performance.
--
-- Key metrics:
-- - Total revenue
-- - Total quantity sold
-- - Average unit price
-- - Product rank by country
-- - Retailer type
-- -----------------------------------------------------

SELECT
    p.product_number,
    p.product_name,
    p.product_type,
    r.country,
    r.type AS retailer_type,

    COUNT(*) AS sales_records,
    SUM(ds.quantity) AS total_quantity,

    ROUND(
        SUM(ds.quantity * ds.unit_sale_price),
        2
    ) AS total_revenue,

    ROUND(
        SUM(ds.quantity * ds.unit_sale_price)
        / NULLIF(SUM(ds.quantity), 0),
        2
    ) AS avg_unit_price,

    RANK() OVER (
        PARTITION BY r.country
        ORDER BY SUM(ds.quantity * ds.unit_sale_price) DESC
    ) AS product_rank_by_country

FROM `project-goexplore.goexplore.daily_sales` AS ds
JOIN `project-goexplore.goexplore.products` AS p
    ON ds.product_number = p.product_number
JOIN `project-goexplore.goexplore.retailers` AS r
    ON ds.retailer_code = r.retailer_code

GROUP BY
    p.product_number,
    p.product_name,
    p.product_type,
    r.country,
    r.type

ORDER BY
    total_revenue DESC;
    
-- -----------------------------------------------------
-- 4. Performance over Time Dashboard Query
-- -----------------------------------------------------
--
-- Purpose:
-- Prepares time-based sales data for analysing revenue and quantity trends.
-- The query calculates monthly revenue, monthly quantity, average order value,
-- average unit price, and month-over-month revenue growth.
--
-- Business use:
-- Helps monitor business performance over time, compare growth patterns
-- across countries and retailer types, and identify revenue trends.
--
-- Key metrics:
-- - Monthly revenue
-- - Monthly quantity sold
-- - Average order value
-- - Average unit price
-- - Previous month revenue
-- - Month-over-month revenue growth
-- -----------------------------------------------------

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC(ds.date, MONTH) AS month,
        r.country,
        r.type AS retailer_type,

        COUNT(*) AS sales_records,
        SUM(ds.quantity) AS total_quantity,

        ROUND(
            SUM(ds.quantity * ds.unit_sale_price),
            2
        ) AS total_revenue

    FROM `project-goexplore.goexplore.daily_sales` AS ds
    JOIN `project-goexplore.goexplore.retailers` AS r
        ON ds.retailer_code = r.retailer_code

    GROUP BY
        month,
        r.country,
        r.type
),

monthly_growth AS (
    SELECT
        month,
        country,
        retailer_type,
        sales_records,
        total_quantity,
        total_revenue,

        ROUND(
            total_revenue / NULLIF(sales_records, 0),
            2
        ) AS avg_order_value,

        ROUND(
            total_revenue / NULLIF(total_quantity, 0),
            2
        ) AS avg_unit_price,

        LAG(total_revenue) OVER (
            PARTITION BY country, retailer_type
            ORDER BY month
        ) AS previous_month_revenue

    FROM monthly_sales
)

SELECT
    month,
    country,
    retailer_type,
    sales_records,
    total_quantity,
    total_revenue,
    avg_order_value,
    avg_unit_price,
    previous_month_revenue,

    ROUND(
        (total_revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0)
        * 100,
        2
    ) AS mom_growth_percent

FROM monthly_growth

ORDER BY
    month,
    country,
    retailer_type;