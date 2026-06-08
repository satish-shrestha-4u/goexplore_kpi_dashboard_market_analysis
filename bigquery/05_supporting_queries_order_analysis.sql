-- -----------------------------------------------------
-- Most Used Order Methods
-- -----------------------------------------------------
--
-- Purpose:
-- Counts and compares order volume by order method.
--
-- Business use:
-- Helps identify the dominant sales channel and supports the insight
-- that web orders are the main order channel.
-- -----------------------------------------------------

SELECT
    m.order_method_type,
    COUNT(*) AS number_of_sales,
    SUM(ds.quantity) AS total_quantity,
    ROUND(SUM(ds.quantity * ds.`unit_sale_price`), 2) AS total_revenue
FROM goexplore.daily_sales ds
JOIN goexplore.methods m
    ON ds.order_method_code = m.order_method_code
GROUP BY m.order_method_type
ORDER BY number_of_sales DESC;