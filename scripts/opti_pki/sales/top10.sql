-- Top 10 produits les plus vendus (en CA)
WITH payments AS (
    SELECT
        order_id,
        SUM(payment_value) AS total_payment
    FROM order_payments
    GROUP BY order_id
),
ca_par_jour AS (
    SELECT
        SUBSTR(o.order_purchase_timestamp,1,10) AS jour,
        SUM(p.total_payment) AS ca_jour
    FROM orders o
    JOIN payments p ON p.order_id = o.order_id
    GROUP BY jour
)
SELECT
    cur.jour,
    cur.ca_jour AS ca_courant,
    prev.ca_jour AS ca_n_1,
    (cur.ca_jour - prev.ca_jour) AS variation_abs,
    CASE
        WHEN prev.ca_jour = 0 THEN NULL
        ELSE ROUND(100.0 * (cur.ca_jour - prev.ca_jour) / prev.ca_jour,2)
    END AS variation_pct
FROM ca_par_jour cur
LEFT JOIN ca_par_jour prev
    ON prev.jour = DATE(cur.jour,'-1 year')
ORDER BY cur.jour;
