-- 1. Total products
-- 2. Products by category
-- 3. Revenue by product
-- 4. Units sold by product
-- 5. Average price by product
-- 6. Top 10 products by revenue
-- 7. Top 10 categories by revenue
-- 8. Products with the highest number of orders
-- 9. Products with low/no sales
-- 10. Average product price by category

SELECT * FROM products;

-- 1 Total Products

SELECT COUNT(DISTINCT product_id) AS Total_products
FROM products;

-- 2 Product By Category

SELECT product_category_name,COUNT(*) AS Total_products
FROM products
GROUP BY product_category_name
ORDER BY product_category_name DESC;
-- 3 Revenue By Product
SELECT 
    p.product_id,
    SUM(oi.price + oi.freight_value) AS Product_Revenue
FROM products p 
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY Product_Revenue DESC;

-- 4 Units sold by product

SELECT 
    p.product_id,
    COUNT(*) AS Units_sold
FROM products p
JOIN order_items oi
ON p.product_id = oi.order_id
GROUP BY p.product_id
ORDER BY Units_sold DESC;

-- 5 Average price by product

SELECT
    p.product_id,
    AVG(oi.price) AS Average_Price
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY Average_Price DESC;

-- 6. Top 10 products by revenue

SELECT
    p.product_id,
    AVG(oi.price) AS Average_Price
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY Average_Price DESC
LIMIT 10;

-- 7. Top 10 categories by revenue

SELECT 
    product_category_name,
    COUNT(*) AS Total_products
FROM products
GROUP BY product_category_name
ORDER BY product_category_name DESC
LIMIT 10;

-- 8. Products with the highest number of orders

SELECT
p.product_id,
COUNT(DISTINCT oi.order_id) AS number_of_orders
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY number_of_orders DESC;

-- 9. Products with low/no sales

SELECT
p.product_id,
COUNT(DISTINCT oi.order_id) AS number_of_orders
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id
HAVING COUNT(DISTINCT oi.order_id) < 5
ORDER BY number_of_orders ;

-- 10. Average product price by category

SELECT
    p.product_category_name,
    AVG(oi.price) AS Average_Price
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY Average_Price DESC;