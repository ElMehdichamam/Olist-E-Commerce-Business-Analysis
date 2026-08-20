# Olist Data Quality Report

## Order Chronology

### Issue
Some orders contain timestamps that don't follow the expected
chronological order.

Expected order:

Purchase → Approval → Carrier → Customer Delivery

### Detection

```sql
order_approved_at < order_purchase_timestamp
order_delivered_carrier_date < order_approved_at
order_delivered_customer_date < order_delivered_carrier_date
```

## Order Date Completeness & Status

### Observation

Some order timestamps are missing depending on the order status.

For example, orders with statuses such as `canceled` or `unavailable`
may not have approval, carrier, or customer-delivery timestamps.

### Interpretation

Missing timestamps are not automatically data-quality errors.

If an order was canceled before delivery, the absence of a
`order_delivered_customer_date` is expected.

Therefore, date completeness must be evaluated in the context
of `order_status`.

### Validation

I checked the relationship between `order_status` and missing
timestamps using:

```sql
SELECT
    order_status,
    COUNT(*) AS total_orders,
    SUM(order_approved_at IS NULL) AS missing_approved,
    SUM(order_delivered_carrier_date IS NULL) AS missing_carrier,
    SUM(order_delivered_customer_date IS NULL) AS missing_customer
FROM orders
GROUP BY order_status;
```

### Issue
Some Customer Unique ID is Duplicated .
## Explantation
Duplicated Customer unique id doesn't mean Bad data If we check 

    ```
    SELECT *
    FROM customers
    WHERE customer_unique_id = "00172711b30d52eea8b313a7f2cced02";

    ```
we will found out two customer have the same unique id but different customer_id that because customer_id is realted to orders not customer itself and that logically cause one cusotmer might have multiple order


