------------------- CA MOIS -------------------
WITH total_payments AS (
    SELECT order_id, SUM(payment_value) AS total_payment
    FROM order_payments
    GROUP BY order_id
),
orders_mois AS (
    SELECT order_id, STRFTIME('%Y-%m', order_purchase_timestamp) AS mois
    FROM orders
)
SELECT
    o.mois,
    SUM(tp.total_payment) AS ca_mois
FROM orders_mois AS o
JOIN total_payments AS tp ON tp.order_id = o.order_id
GROUP BY o.mois
ORDER BY o.mois;