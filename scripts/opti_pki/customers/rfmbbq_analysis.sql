SELECT
    r.customer_id,
    CAST(julianday('now') - julianday(r.last_order_date) AS INTEGER) AS recency_days,
    r.frequency,
    r.monetary
FROM (
    SELECT
        o.customer_id,
        MAX(SUBSTR(o.order_purchase_timestamp,1,10)) AS last_order_date,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price + oi.freight_value) AS monetary
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
) AS r
ORDER BY monetary DESC;
