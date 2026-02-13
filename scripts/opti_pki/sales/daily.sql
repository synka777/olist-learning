------------------- CA JOUR -------------------
WITH payments AS (
    SELECT
        order_id,
        SUM(payment_value) AS total_payment
    FROM order_payments
    GROUP BY order_id
)
SELECT
    SUBSTR(o.order_purchase_timestamp, 1, 10) AS jour,
    SUM(p.total_payment)                      AS ca_jour
FROM orders o
JOIN payments p ON p.order_id = o.order_id
GROUP BY jour
ORDER BY jour;
