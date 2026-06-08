
-- -----------------------------------------------------
-- Revenue Share by Country
-- -----------------------------------------------------
--
-- Purpose:
-- Calculates total revenue and revenue share by country.
--
-- Business use:
-- Helps identify GoExplore's strongest markets and understand
-- each country's contribution to total revenue.
--
-- Calculation:
-- revenue = quantity * unit_sale_price
-- revenue_share_percent = country revenue / total revenue
-- -----------------------------------------------------
SELECT
r.country,
ROUND(SUM(ds.quantity * ds.unit_sale_price), 2) AS total_revenue,
    
ROUND(SUM(ds.quantity * ds.unit_sale_price) / SUM(SUM(ds.quantity * ds.unit_sale_price)) OVER () * 100,2) AS revenue_share_percent

FROM goexplore.daily_sales ds
JOIN goexplore.retailers r
    ON ds.retailer_code = r.retailer_code

GROUP BY r.country
ORDER BY total_revenue ASC;


-- -----------------------------------------------------
-- Countries with Highest Sales
-- -----------------------------------------------------
--
-- Purpose:
-- Ranks countries by total sales revenue.
--
-- Business use:
-- Helps identify the highest-performing markets and supports
-- market comparison for expansion planning.
-- -----------------------------------------------------
SELECT
    r.country,
    SUM(ds.quantity) AS total_units,
    ROUND(SUM(ds.quantity * ds.unit_sale_price), 2) AS total_revenue
FROM goexplore.daily_sales ds
JOIN goexplore.retailers r
    ON ds.retailer_code = r.retailer_code
GROUP BY r.country
ORDER BY total_revenue DESC;


-- -----------------------------------------------------
-- Revenue by Month
-- -----------------------------------------------------
--
-- Purpose:
-- Calculates monthly revenue trends across the analysed period.
--
-- Business use:
-- Helps show whether GoExplore's revenue is increasing over time
-- and supports the business performance dashboard.
-- -----------------------------------------------------

SELECT
    `date`,
    COUNT(*) AS number_of_sales_records,
    SUM(quantity) AS total_quantity_sold,
    ROUND(SUM(quantity * unit_sale_price), 2) AS total_revenue
FROM goexplore.daily_sales
GROUP BY `date`
ORDER BY total_revenue desc;

-- -----------------------------------------------------
-- Market Benchmark Comparison
-- -----------------------------------------------------
--
-- Purpose:
-- Compares existing GoExplore markets with potential expansion countries
-- using revenue, market size, population, GDP, or regional similarity.
--
-- Business use:
-- Supports estimation of market potential for Czech Republic, Norway,
-- Poland, and Portugal.
-- -----------------------------------------------------

SELECT 
  r.country,
  COUNT(DISTINCT r.retailer_code) AS num_stores,
  COUNT(*) AS total_orders,
  ROUND(SUM(ds.quantity * ds.unit_sale_price), 2) AS total_revenue,
  ROUND(AVG(ds.quantity * ds.unit_sale_price), 2) AS avg_order_value,
  ROUND(SUM(ds.quantity * ds.unit_sale_price) / (SELECT SUM(quantity * unit_sale_price) FROM goexplore.daily_sales) * 100,2) AS revenue_share_percent
FROM goexplore.retailers r
LEFT JOIN goexplore.daily_sales ds
  ON r.retailer_code = ds.retailer_code
WHERE r.country IN ('Austria', 'Sweden', 'Denmark', 'Spain', 'Italy', 'Belgium', 'Netherlands')
GROUP BY r.country
ORDER BY total_revenue DESC;