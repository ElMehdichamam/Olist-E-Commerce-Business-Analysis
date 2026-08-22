-- 05_customer_analysis.sql

-- 1. Total customers
-- 2. Active customers
-- 3. One-time vs repeat customers
-- 4. Orders per customer
-- 5. Revenue per customer
-- 6. Average Order Value per customer
-- 7. Top customers by revenue
-- 8. Customer distribution by state/city
-- 9. Customer purchase frequency

-- 1 Counting Numbers Of Customers

SELECT COUNT(DISTINCT customer_unique_id ) AS Total_Customers
FROM customers;

-- 2 Finding ACTIVE CUSTOMER

SELECT COUNT(DISTINCT c.customer_unique_id) AS Active_Customer
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id;

-- 3

SELECT 
    customer_unique_id,
    number_of_orders,
    CASE
        WHEN number_of_orders = 1 THEN "One-time"
        ELSE "Repeat"
    END AS customer_type
FROM (
    SELECT c.customer_unique_id , COUNT(DISTINCT o.order_id) AS number_of_orders
    FROM customers c
    LEFT JOIN orders o 
    ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
) x;



-- 4 Order Per Customer

SELECT c.customer_id,
       COUNT(o.order_id) AS Total_orders 
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- 5 Revenue Per Customer

SELECT 
    c.customer_id,
    COALESCE(sum(oi.price + oi.freight_value),0) AS total_revenue
FROM customers c

LEFT JOIN orders o
ON c.customer_id = o.customer_id

LEFT JOIN order_items oi
ON o.order_id = oi.order_id

GROUP BY c.customer_id;

-- 6

SELECT c.customer_id,
    COALESCE(SUM(oi.price + oi.freight_value),0)/
    NULLIF(COUNT(DISTINCT o.order_id),0) AS Average_order_value 
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
LEFT JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY Average_orders DESC;


-- 7 TOP customer BY Revenue

SELECT  
        c.customer_id,
        SUM(oi.price + oi.freight_value ) AS Top_revenue
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
LEFT JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_id
ORDER BY Top_revenue DESC
LIMIT 1;

-- 8 Distribution By City And State

-- By State

SELECT customer_state,
       COUNT(*) AS Customer 
FROM customers
GROUP BY customer_state
ORDER BY Customer DESC;

-- By City

SELECT customer_city,
       COUNT(*) AS Customer
FROM customers
GROUP BY customer_city
ORDER BY Customer DESC;

-- 9 Customer Purchase Frequency

SELECT
    c.customer_id,
    COUNT( DISTINCT o.order_id) AS purchase_frequency
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY purchase_frequency DESC;