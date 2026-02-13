-- Sans données de visiteurs, on fait :
-- taux = commandes livrées / commandes totales
SELECT
    ROUND(
        COUNT(CASE WHEN order_status = 'delivered' THEN 1 END) * 1.0 / COUNT(*),
        4
    ) AS conversion_rate
FROM orders;
