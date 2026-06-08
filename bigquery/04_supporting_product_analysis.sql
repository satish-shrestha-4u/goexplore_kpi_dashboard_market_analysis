-- =====================================================
-- Supporting Product Analysis
-- GoExplore KPI Dashboard and Market Analysis
-- =====================================================
--
-- Purpose:
-- This file contains supporting BigQuery queries used to analyse
-- product performance, product categories, product prices, revenue,
-- and quantity sold.
--
-- These queries support the product analysis dashboard and product
-- strategy insights.
-- =====================================================


-- -----------------------------------------------------
-- Average Price by Product Type
-- -----------------------------------------------------
--
-- Purpose:
-- Calculates the average product price for each product type.
--
-- Business use:
-- Helps compare product categories and understand which product types
-- are positioned at higher or lower price points.
-- -----------------------------------------------------

SELECT
    p.product_type,
    ROUND(
        SUM(ds.quantity * ds.unit_sale_price) / SUM(ds.quantity),
        2
    ) AS avg_price
FROM goexplore.daily_sales ds
JOIN goexplore.products p
    ON ds.product_number = p.product_number
GROUP BY p.product_type
ORDER BY avg_price DESC;

-- -----------------------------------------------------
-- Most Popular Product Categories
-- -----------------------------------------------------
--
-- Purpose:
-- Identifies product categories with the highest sales volume.
--
-- Business use:
-- Helps understand customer demand and supports product assortment analysis.
-- -----------------------------------------------------

SELECT
    p.product_type,
    SUM(ds.quantity) AS total_quantity_sold
FROM goexplore.daily_sales ds
JOIN goexplore.products p
    ON ds.product_number = p.product_number
GROUP BY p.product_type
ORDER BY total_quantity_sold DESC;


-- -----------------------------------------------------
-- Product Line Revenue and Profitability Analysis
-- -----------------------------------------------------
--
-- Purpose:
-- Calculates total quantity sold, total revenue, total profit,
-- and profit margin by product line.
--
-- Business use:
-- Helps identify which product lines generate the highest revenue
-- and which product lines are most profitable.
--
-- Key metrics:
-- - Total quantity sold
-- - Total revenue
-- - Total profit
-- - Profit margin percentage
-- -----------------------------------------------------

SELECT 
    p.product_line,
    SUM(s.quantity) AS total_quantity,
    ROUND(SUM(s.quantity * s.unit_sale_price), 2) AS total_revenue,
    ROUND(SUM(s.quantity * (s.unit_sale_price - p.unit_cost)),
            2) AS total_profit,
    ROUND(SUM(s.quantity * (s.unit_sale_price - p.unit_cost)) / NULLIF(SUM(s.quantity * s.unit_sale_price), 0) * 100,
            2) AS profit_margin_percent
FROM
    `project-goexplore.goexplore.daily_sales` AS s
        LEFT JOIN
    `project-goexplore.goexplore.products` AS p ON s.product_number = p.product_number
GROUP BY p.product_line
ORDER BY total_revenue DESC;
    

-- -----------------------------------------------------
-- Revenue vs Quantity by Product Line
-- -----------------------------------------------------
--
-- Purpose:
-- Compares revenue and quantity sold across product lines.
--
-- Business use:
-- Helps distinguish high-volume products from high-revenue products.
-- -----------------------------------------------------

SELECT 
    p.product_line,
    p.product_type,
    SUM(s.quantity) AS total_quantity,
    ROUND(AVG(s.unit_sale_price), 2) AS avg_price,
    ROUND(SUM(s.quantity * s.unit_sale_price), 2) AS total_revenue,
    ROUND(SUM(s.quantity * (s.unit_sale_price - p.unit_cost)),
            2) AS total_profit,
    ROUND(SUM(s.quantity * (s.unit_sale_price - p.unit_cost)) / SUM(s.quantity * s.unit_sale_price) * 100,
            2) AS profit_margin_pct
FROM
    `project-goexplore.goexplore.daily_sales` s
        LEFT JOIN
    `project-goexplore.goexplore.products` p ON s.product_number = p.product_number
GROUP BY p.product_line , p.product_type
ORDER BY total_revenue DESC;