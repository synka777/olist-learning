------------------- CA ANNÉE -------------------
SELECT
    STRFTIME('%Y', o.order_purchase_timestamp) AS annee,
    SUM(op.payment_value)                       AS ca_annee
FROM orders          AS o
JOIN order_payments  AS op ON op.order_id = o.order_id
GROUP BY annee
ORDER BY annee;