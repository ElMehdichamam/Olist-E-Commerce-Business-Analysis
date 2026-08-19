
CREATE DATABASE IF NOT EXISTS olist;
USE olist;


-- ============================================
-- 1. GEOLOCATION
-- ============================================

CREATE TABLE geolocation (
    geolocation_id INT AUTO_INCREMENT PRIMARY KEY,
    geolocation_zip_code_prefix INT NOT NULL,
    geolocation_lat DECIMAL(10,6),
    geolocation_lng DECIMAL(10,6),
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2),

    INDEX idx_geolocation_zip (geolocation_zip_code_prefix)
);


-- ============================================
-- 2. CUSTOMERS
-- ============================================

CREATE TABLE customers (
    customer_id VARCHAR(32) PRIMARY KEY,
    customer_unique_id VARCHAR(32),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state CHAR(2),

    INDEX idx_customers_zip (customer_zip_code_prefix)
);


-- ============================================
-- 3. SELLERS
-- ============================================

CREATE TABLE sellers (
    seller_id VARCHAR(32) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state CHAR(2),

    INDEX idx_sellers_zip (seller_zip_code_prefix)
);


-- ============================================
-- 4. PRODUCTS
-- ============================================

CREATE TABLE products (
    product_id VARCHAR(32) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);


-- ============================================
-- 5. ORDERS
-- ============================================

CREATE TABLE orders (
    order_id VARCHAR(32) PRIMARY KEY,
    customer_id VARCHAR(32) NOT NULL,
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,

    INDEX idx_orders_customer (customer_id),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);


-- ============================================
-- 6. ORDER ITEMS
-- ============================================

CREATE TABLE order_items (
    order_id VARCHAR(32) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(32) NOT NULL,
    seller_id VARCHAR(32) NOT NULL,
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),

    PRIMARY KEY (order_id, order_item_id),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id)
);


-- ============================================
-- 7. ORDER PAYMENTS
-- ============================================

CREATE TABLE order_payments (
    order_id VARCHAR(32) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10,2),

    PRIMARY KEY (order_id, payment_sequential),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);


-- ============================================
-- 8. ORDER REVIEWS
-- ============================================

CREATE TABLE order_reviews (
    review_id VARCHAR(32) PRIMARY KEY,
    order_id VARCHAR(32),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME,

    INDEX idx_reviews_order (order_id),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);


-- ============================================
-- 9. CATEGORY TRANSLATION
-- ============================================

CREATE TABLE category_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);