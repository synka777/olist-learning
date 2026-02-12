------------------- CA JOUR -------------------
SELECT
    DATE(o.order_purchase_timestamp) AS jour,
    SUM(op.payment_value)            AS ca_jour
FROM orders          AS o
JOIN order_payments  AS op ON op.order_id = o.order_id
GROUP BY jour
ORDER BY jour;