-- nouveau client = première commande
-- récurrent = au moins 2 commandes
WITH orders_per_customer AS (
    SELECT
        customer_id,
        COUNT(order_id) AS nb_orders
    FROM orders
    GROUP BY customer_id
)
SELECT
    SUM(CASE WHEN nb_orders = 1 THEN 1 ELSE 0 END) AS new_customers,
    SUM(CASE WHEN nb_orders > 1 THEN 1 ELSE 0 END) AS returning_customers
FROM orders_per_customer;