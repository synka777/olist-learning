-- Panier moyen = total des ventes / nombre de commandes
WITH order_totals AS (
    SELECT
        oi.order_id,
        SUM(oi.price + oi.freight_value) AS order_total
    FROM order_items oi
    GROUP BY oi.order_id
)
SELECT
    AVG(order_total) AS avg_basket_value
FROM order_totals;
