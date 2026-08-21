-- orders

SELECT * FROM orders;

-- Checking For Missing Values
SELECT 
       SUM(order_id IS NULL OR TRIM(order_id) ='') as Missing_id,
       SUM(customer_id IS NULL OR TRIM(customer_id) ='') as Missing_customer_id,
       SUM(order_status IS NULL OR TRIM(order_status) ='') as Missing_status
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
    SUM(customer_id IS NULL OR TRIM(customer_id) ='') as Missing_id,
    SUM(customer_unique_id IS NULL OR TRIM(customer_unique_id) ='') as missing_unique_id,
    SUM(customer_zip_code_prefix IS NULL) as missing_zip_code,
    SUM(customer_city IS NULL OR TRIM(customer_city) ='') as missing_city,
    SUM(customer_state IS NULL OR TRIM(customer_state) ='') as missing_state
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
    SUM(order_id IS NULL OR TRIM(order_id) ='') AS Missing_id,
    SUM(order_item_id IS NULL OR TRIM(order_item_id) ='') AS missing_item_id,
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

SELECT oi.order_id
FROM order_items oi

LEFT JOIN orders o 
ON oi.order_id = o.order_id

LEFT JOIN sellers s 
ON oi.seller_id = s.seller_id

LEFT JOIN products p
ON oi.product_id = p.product_id

LEFT JOIN order_payments op
ON oi.order_id = op.order_id

LEFT JOIN order_reviews ore
ON oi.order_id = ore.order_id

WHERE  o.order_id IS NULL
    OR s.seller_id IS NULL
    OR p.product_id IS NULL
    OR op.order_id IS NULL
    OR ore.order_id IS NULL;


-- Checking the duplicated Id to understanding why it got duplicated

SELECT *
FROM order_items
WHERE order_id = "00143d0f86d6fbd9f9b38ab440ac16f5";
-- Products

SELECT * FROM products;

-- Checking For Missing Values

SELECT
    SUM(product_id IS NULL OR TRIM(product_id) ='') as Missing_id,
    SUM(product_category_name IS NULL OR TRIM(product_category_name) ='') as Missing_Name,
    SUM(product_description_length IS NULL) as Missing_length,
    SUM(product_photos_qty IS NULL) AS Missing_photo,
    SUM(product_weight_g IS NULL) AS Missing_weight,
    SUM(product_width_cm IS NULL) AS Missing_width,
    SUM(product_length_cm IS NULL) AS Missing_length_cm
FROM products;

-- Checking the Missing Values To explore The reason why
SELECT *
FROM products
WHERE 
      product_category_name IS NULL 
      OR TRIM(product_category_name) ='';

SELECT
    p.product_id,
    COUNT(oi.order_id) AS order_count
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE p.product_category_name IS NULL
   OR TRIM(p.product_category_name) = ''
GROUP BY p.product_id;

-- How Much Does this missing data affect My analysis

SELECT COUNT(*) AS affected_order_items
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_category_name IS NULL
   OR TRIM(p.product_category_name) = '';

-- Compare with total
SELECT COUNT(*) AS total_order_items
FROM order_items;
-- Calculate the affected Revenue
SELECT
    SUM(oi.price) AS affected_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_category_name IS NULL
   OR TRIM(p.product_category_name) = '';

-- Compare it with Total Revenue

SELECT
SUM(price) AS total_revenue
FROM order_items;

-- Checking For Invalid Values

SELECT
    SUM(product_description_length < 0) as Invalid_length,
    SUM(product_weight_g < 0) AS Invalid_weight,
    SUM(product_width_cm < 0) AS Invalid_width,
    SUM(product_description_length < 0) AS Invalid_description_length,
    SUM(product_name_length < 0) AS Invalid_name_length,
    SUM(product_photos_qty < 0) AS Invalid_photos_qty,
    SUM(product_length_cm < 0) AS Invalid_length_cm
FROM products;

-- Checking For Duplicates

SELECT product_id , count(*) as N
FROM products
GROUP BY product_id
HAVING count(*) > 1;

-- Checking For Product That Didn't got ordered

SELECT p.product_id
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;


-- Sellers
SELECT * FROM sellers;

-- Checking for Missing Values 

SELECT 
SUM(seller_id IS NULL OR TRIM(seller_id) ='') as Missing_id,
SUM(seller_zip_code_prefix IS NULL) AS Missing_seller_zip,
SUM(seller_city IS NULL OR TRIM(seller_city) ='') as Missing_city,
SUM(seller_state IS NULL OR TRIM(seller_state) ='') as missing_state
FROM sellers;

-- Checking For Duplicates

SELECT seller_id , count(*) as Duplicates
FROM sellers
GROUP BY seller_id
HAVING count(*) > 1;

-- Checking For Invalid Relationships

SELECT s.seller_id
FROM sellers s
LEFT JOIN order_items oi
ON s.seller_id = oi.seller_id
WHERE oi.seller_id IS NULL;

-- Order Payment

SELECT * FROM order_payments;

-- Checking For Missing Values

SELECT 
SUM(order_id IS NULL OR TRIM(order_id) ='') AS Missing_id,
SUM(payment_sequential IS NULL) AS Missing_Sequential,
SUM(payment_type IS NULL OR TRIM(payment_type) ='') AS Missing_Payment_Type,
SUM(payment_installments IS NULL) AS Missing_payment_installments,
SUM(payment_value IS NULL) AS Missing_payment_value
FROM order_payments;

-- Checking For Invalid Values

SELECT 
SUM(payment_sequential < 0) AS Invalid_payment_sequential,
SUM(payment_installments < 0) AS Invalid_payment_installments,
SUM(payment_value < 0) as Invalid_payment_value
FROM order_payments;

-- Checking For Duplicates

SELECT order_id , count(*) AS N
FROM order_payments
GROUP BY order_id
HAVING count(*) > 1;

-- Looking for the duplicated ID to explore the reason why it's duplicated

SELECT *
FROM order_payments
WHERE order_id = "0016dfedd97fc2950e388d2971d718c7";

-- Checking For Invalid Relationships

SELECT op.order_id
FROM order_payments op

LEFT JOIN orders o 
ON o.order_id = op.order_id
WHERE o.order_id IS NULL;

-- Order Review

SELECT * FROM order_reviews;

-- Checking For Missing Value

SELECT
SUM(review_id IS NULL OR TRIM(review_id) ='') AS Missing_review,
SUM(order_id IS NULL OR TRIM(order_id) ='') AS Missing_order,
SUM(review_score IS NULL) AS Missing_Score,
SUM(review_comment_title IS NULL OR TRIM(review_comment_title) = '') AS Missing_Title,
SUM(review_comment_message IS NULL OR TRIM(review_comment_message) = '') AS Missing_Message
FROM order_reviews;

-- GEOLOCATION 
SELECT * FROM geolocation;

-- Checking For Missing Values

SELECT 
SUM(geolocation_id IS NULL) AS Missing_Id,
SUM(geolocation_zip_code_prefix IS NULL) AS Missing_geolocation_zip,
SUM(geolocation_lat IS NULL) AS Missing_geolocation_lat,
SUM(geolocation_lng IS NULL) AS Missing_geolocation_lng,
SUM(geolocation_city IS NULL OR TRIM(geolocation_city) = '') AS Missing_geolocation_city,
SUM(geolocation_state IS NULL OR TRIM(geolocation_state) ='') AS Missing_geolocation_state
FROM geolocation;

-- Checking For Invalid Values
SELECT *
FROM geolocation
WHERE geolocation_lat NOT BETWEEN -90 AND 90;

SELECT *
FROM geolocation
WHERE geolocation_lng NOT BETWEEN -180 AND 180;

-- category translation

SELECT * FROM category_translation;

-- Checking For Missing Values
SELECT
SUM(product_category_name IS NULL OR TRIM(product_category_name) ='') AS Missing_Name,
SUM(product_category_name_english IS NULL OR TRIM(product_category_name_english) = '') AS Missing_English_Name
FROM category_translation; 