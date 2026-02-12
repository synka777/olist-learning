-- Evolution du CA jour‑à‑jour comparée à la même date l’an passé
SELECT
    cur.jour,
    cur.ca_jour                                 AS ca_courant,
    prev.ca_jour                                AS ca_n_1,
    (cur.ca_jour - prev.ca_jour)                AS variation_abs,
    CASE
        WHEN prev.ca_jour = 0 THEN NULL
        ELSE ROUND(100.0 * (cur.ca_jour - prev.ca_jour) / prev.ca_jour, 2)
    END                                        AS variation_pct
FROM
    (SELECT DATE(o.order_purchase_timestamp) AS jour,
            SUM(op.payment_value)            AS ca_jour
     FROM orders o
     JOIN order_payments op ON op.order_id = o.order_id
     GROUP BY jour) AS cur
LEFT JOIN
    (SELECT DATE(o.order_purchase_timestamp, '-1 year') AS jour,
            SUM(op.payment_value)                     AS ca_jour
     FROM orders o
     JOIN order_payments op ON op.order_id = o.order_id
     GROUP BY jour) AS prev
ON cur.jour = prev.jour
ORDER BY cur.jour;