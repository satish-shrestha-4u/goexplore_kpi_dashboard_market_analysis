-- -----------------------------------------------------
-- Specialty vs General Retailers
-- -----------------------------------------------------
--
-- Purpose:
-- Compares specialty retailers with general retailers.
--
-- Business use:
-- Helps determine whether focused retailer types such as Golf Shops
-- and Eyewear Stores perform differently from broader retailers such
-- as Sports Stores and Outdoors Shops.
--
-- Key metrics:
-- - Average order value
-- - Average product price
-- - Total revenue
-- - Number of orders
-- - Orders per retailer
-- -----------------------------------------------------
SELECT
    CASE
        WHEN r.type IN ('Golf Shop', 'Eyewear Store') THEN 'Specialty'
        ELSE 'General'
    END AS store_category,

    p.product_type,

    ROUND(
        SUM(ds.quantity * ds.unit_sale_price) / SUM(ds.quantity),
        2
    ) AS avg_price

FROM goexplore.daily_sales ds
JOIN goexplore.retailers r
    ON ds.retailer_code = r.retailer_code
JOIN goexplore.products p
    ON ds.product_number = p.product_number

GROUP BY store_category, p.product_type
ORDER BY avg_price DESC;

-- -----------------------------------------------------
-- Detailed Retailer Type Comparison
-- -----------------------------------------------------
--
-- Purpose:
-- Provides a more detailed comparison of specialty and general retailers
-- using multiple business KPIs.
--
-- Business use:
-- Supports the final recommendation on retailer strategy and helps
-- evaluate where GoExplore should focus retailer relationships.
-- -----------------------------------------------------

SELECT
  CASE
    WHEN r.type IN ('Golf Shop', 'Eyewear Store') THEN 'Specialty'
    WHEN r.type IN ('Sports Store', 'Outdoors Shop') THEN 'General'
  END AS store_category,

  COUNT(DISTINCT r.retailer_code) AS number_of_stores,
  COUNT(*) AS total_sales_records,
  SUM(s.quantity) AS total_quantity_sold,

  ROUND(SUM(s.quantity * s.unit_sale_price), 2) AS total_revenue,

  ROUND(AVG(s.quantity * s.unit_sale_price), 2) AS avg_order_value,

  ROUND(
    SUM(s.quantity * s.unit_sale_price) / SUM(s.quantity),
    2
  ) AS avg_product_price,

  ROUND(
    COUNT(*) / COUNT(DISTINCT r.retailer_code),
    2
  ) AS orders_per_store

FROM goexplore.daily_sales s
JOIN goexplore.retailers r
  ON s.retailer_code = r.retailer_code

WHERE r.type IN ('Golf Shop', 'Eyewear Store', 'Sports Store', 'Outdoors Shop')

GROUP BY store_category
ORDER BY total_revenue DESC;

-- -----------------------------------------------------
-- Revenue per Store Category
-- -----------------------------------------------------
--
-- Purpose:
-- Calculates revenue by retailer or store category.
--
-- Business use:
-- Helps identify which retailer categories contribute most to revenue
-- and whether specialty stores generate stronger value per order.
-- -----------------------------------------------------

SELECT
    CASE
        WHEN r.type IN ('Golf Shop', 'Eyewear Store') THEN 'Specialty'
        ELSE 'General'
    END AS store_category,
    ROUND(SUM(ds.quantity * ds.unit_sale_price), 2) AS total_revenue,
    COUNT(DISTINCT r.retailer_code) AS number_of_stores,
    ROUND(
        SUM(ds.quantity * ds.unit_sale_price)
        / COUNT(DISTINCT r.retailer_code),
        2
    ) AS revenue_per_store
FROM goexplore.daily_sales ds
JOIN goexplore.retailers r
    ON ds.retailer_code = r.retailer_code
GROUP BY store_category
ORDER BY revenue_per_store DESC;

-- Top Retailers by Sales
-- -----------------------------------------------------
--
-- Purpose:
-- Identifies retailers with the highest sales revenue.
--
-- Business use:
-- Helps find key retailer partners and supports retailer performance
-- analysis in the dashboard.
-- -----------------------------------------------------

SELECT
    r.retailer_name,
    r.type,
    r.country,
    ROUND(SUM(ds.quantity * ds.unit_sale_price), 2) AS total_sales
FROM goexplore.daily_sales ds
JOIN goexplore.retailers r
    ON ds.retailer_code = r.retailer_code
GROUP BY r.retailer_name, r.type, r.country
ORDER BY total_sales DESC;