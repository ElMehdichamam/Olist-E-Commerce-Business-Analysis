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

## OBSERVATION 

I Found The Same Thing With order_item table there we have multiple orders has the same order_item_id and different order_id so we can say One Item has the same id can get many orders So We can say that duplications Can Makes Sense

## ISSUE 
SOME Order_id Is Duplicated 

## Explantation

By checking With 
```
SELECT *
FROM order_payments
WHERE order_id = "0016dfedd97fc2950e388d2971d718c7";

``` 

I Found Out That Order Id got duplicated if an order got order more than once and with diffrent payment Method 

## OBSERVATION
I rechecked The Quality Between Relation In the order_items Table
And I notice That Product_id and seller_id and shipping_limit_date and order_id is duplicated
But that doesn't concern the order_item_id that id belongs to the item id itself with this query
```

SELECT *
FROM order_items
WHERE order_id = "00143d0f86d6fbd9f9b38ab440ac16f5";

```
we can find out that there are three diffrent ID's that mean Three diffrent product And They counted as One Order that explain Why we have duplicated id's 
