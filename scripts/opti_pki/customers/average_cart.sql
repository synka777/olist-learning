-- Panier moyen = total des ventes / nombre de commandes
SELECT
    AVG(order_total) AS avg_basket_value
FROM (
    SELECT
        order_id,
        SUM(price + freight_value) AS order_total
    FROM order_items
    GROUP BY order_id
) AS order_totals;
