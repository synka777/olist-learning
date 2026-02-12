WITH order_totals AS (
    SELECT
        o.order_id,
        o.customer_id,
        date(o.order_purchase_timestamp) AS order_date,
        SUM(oi.price + oi.freight_value) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id, o.customer_id, order_date
),
rfm AS (
    SELECT
        customer_id,
        MAX(order_date) AS last_order_date,
        COUNT(order_id) AS frequency,
        SUM(order_total) AS monetary
    FROM order_totals
    GROUP BY customer_id
)
SELECT
    customer_id,
    CAST(julianday('now') - julianday(last_order_date) AS INTEGER) AS recency_days,
    frequency,
    monetary
FROM rfm
ORDER BY monetary DESC;