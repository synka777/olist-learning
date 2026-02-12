-- LTV = somme des dépenses des clients de la cohorte
WITH first_orders AS (
    SELECT
        customer_id,
        MIN(date(order_purchase_timestamp)) AS first_order_date
    FROM orders
    GROUP BY customer_id
),
orders_with_revenue AS (
    SELECT
        o.customer_id,
        date(f.first_order_date) AS cohort_date,
        SUM(oi.price + oi.freight_value) AS order_revenue
    FROM orders o
    JOIN first_orders f ON o.customer_id = f.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id, o.customer_id, cohort_date
)
SELECT
    cohort_date,
    COUNT(DISTINCT customer_id) AS customers_in_cohort,
    SUM(order_revenue) AS total_revenue,
    SUM(order_revenue) * 1.0 / COUNT(DISTINCT customer_id) AS ltv_per_customer
FROM orders_with_revenue
GROUP BY cohort_date
ORDER BY cohort_date;
