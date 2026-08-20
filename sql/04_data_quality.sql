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
