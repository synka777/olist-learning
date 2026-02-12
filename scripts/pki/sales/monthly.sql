------------------- CA MOIS -------------------
SELECT
    STRFTIME('%Y-%m', o.order_purchase_timestamp) AS mois,
    SUM(op.payment_value)                         AS ca_mois
FROM orders          AS o
JOIN order_payments  AS op ON op.order_id = o.order_id
GROUP BY mois
ORDER BY mois;