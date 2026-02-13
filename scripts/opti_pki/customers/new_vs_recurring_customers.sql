-- nouveau client = première commande
-- récurrent = au moins 2 commandes
WITH orders_per_customer AS (
    SELECT
        customer_id,
        COUNT(*) AS nb_orders
    FROM orders
    GROUP BY customer_id
)
SELECT
    COUNT(CASE WHEN nb_orders = 1 THEN 1 END) AS new_customers,
    COUNT(CASE WHEN nb_orders > 1 THEN 1 END) AS returning_customers
FROM orders_per_customer;
