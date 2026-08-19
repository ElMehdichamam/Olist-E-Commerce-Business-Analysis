SELECT order_id,
       SUM(order_id IS NULL),
       SUM(customer_id IS NULL),
       SUM(order_status IS NULL)
FROM orders;

SELECT * FROM orders;