-- orders

-- Checking For Missing Values
SELECT 
       SUM(order_id IS NULL) as Missing_id,
       SUM(customer_id IS NULL) as Missing_customer_id,
       SUM(order_status IS NULL) as Missing_status
FROM orders;

-- Checking For Duplicates

SELECT order_id , count(*) as N
FROM orders
GROUP BY order_id
HAVING N > 1;

-- Checking for invalid Relationships

SELECT count(*) as "Orphan Keys"
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Checking For Invalid Dates
SELECT *
FROM orders
WHERE 
(
    order_purchase_timestamp IS NOT NULL
    And order_approved_at IS NOT NULL
    And order_purchase_timestamp > order_approved_at
)
OR
(
    order_approved_at IS NOT NULL
    And order_delivered_carrier_date IS NOT NULL
    AND order_approved_at > order_delivered_carrier_date
)
OR
(
    order_delivered_carrier_date IS NOT NULL
    AND order_delivered_customer_date IS NOT NULL
    AND order_delivered_carrier_date > order_delivered_customer_date
);

SELECT
    order_status,
    COUNT(*) AS orders,
    SUM(order_approved_at IS NULL) AS missing_approved,
    SUM(order_delivered_carrier_date IS NULL) AS missing_carrier,
    SUM(order_delivered_customer_date IS NULL) AS missing_customer
FROM orders
GROUP BY order_status;

-- customers
SELECT * FROM customers;

-- Checking For Missing Values

SELECT
    SUM(customer_id IS NULL) as Missing_id,
    SUM(customer_unique_id IS NULL) as missing_unique_id,
    SUM(customer_zip_code_prefix IS NULL) as missing_zip_code,
    SUM(customer_city IS NULL) as missing_city,
    SUM(customer_state IS NULL) as missing_state
FROM customers;

-- Checking for duplicates

SELECT customer_id, count(*) as duplicates
FROM customers
GROUP BY customer_id
HAVING count(*) > 1;


SELECT customer_unique_id , count(*) as duplicates
FROM customers
GROUP BY customer_unique_id
HAVING count(*) > 1;

-- Checking the duplicated Id and Why it's Duplicated

SELECT *
FROM customers
WHERE customer_unique_id = "00172711b30d52eea8b313a7f2cced02";

-- cheking for invalid relationship

SELECT c.customer_id as Invalid_Relationship
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;


-- ORDER ITEMS

SELECT * FROM order_items;

-- checking for missing values

SELECT
    SUM(order_id IS NULL) AS Missing_id,
    SUM(order_item_id IS NULL) AS missing_item_id,
    SUM(price is NULL) AS missing_price,
    SUM(freight_value IS NULL) AS missing_freight_value
FROM order_items;

-- cheking for invalid values

SELECT price AS "Invalid Prices"
FROM order_items
WHERE price < 0;

SELECT freight_value AS "Invalid freight"
FROM order_items
WHERE freight_value < 0;

-- Checking For Valid Chronology

SELECT order_id, shipping_limit_date
FROM order_items
where STR_TO_DATE(shipping_limit_date,'%Y-%m-%d %H:%i:%s') IS NULL
AND shipping_limit_date IS NULL;

SELECT oi.shipping_limit_date
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE oi.shipping_limit_date < o.order_purchase_timestamp;

-- Checking For Duplications

SELECT order_id, count(*) as N
FROM order_items
GROUP BY order_id
HAVING count(*) > 1;

SELECT order_item_id, count(*) as N
FROM order_items
GROUP BY order_item_id
HAVING count(*) > 1;

-- Checking for Invalid Relationships

SELECT oi.order_item_id
FROM order_items oi

LEFT JOIN orders o 
ON oi.order_id = o.order_id

LEFT JOIN sellers s 
ON oi.seller_id = s.seller_id

LEFT JOIN products p
ON oi.product_id = p.product_id

WHERE  o.order_id IS NULL
    OR s.seller_id IS NULL
    OR p.product_id IS NULL;

