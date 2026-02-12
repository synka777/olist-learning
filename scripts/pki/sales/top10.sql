-- Top 10 produits les plus vendus (en CA)
SELECT
    p.product_id,
    p.product_category_name_en,
    p.product_name_length,               -- champ “extra” juste pour illustrer
    SUM(op.payment_value) AS ca_produit,
    ROW_NUMBER() OVER (ORDER BY SUM(op.payment_value) DESC) AS rang
FROM order_items      AS oi
JOIN orders           AS o  ON o.order_id = oi.order_id
JOIN order_payments   AS op ON op.order_id = o.order_id
JOIN products         AS p  ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_category_name, p.product_name_length
ORDER BY ca_produit DESC
LIMIT 10;