-- Prendre la première commande de chaque client
-- puis calsuler le nombre de clients encore actifs N mois après
WITH first_orders AS (
    SELECT
        customer_id,
        MIN(date(order_purchase_timestamp)) AS first_order_date
    FROM orders
    GROUP BY customer_id
),
orders_with_cohort AS (
    SELECT
        o.customer_id,
        date(o.order_purchase_timestamp) AS order_date,
        date(f.first_order_date) AS cohort_date,
        (strftime('%Y', o.order_purchase_timestamp) - strftime('%Y', f.first_order_date)) * 12 +
        (strftime('%m', o.order_purchase_timestamp) - strftime('%m', f.first_order_date)) AS cohort_month
    FROM orders o
    JOIN first_orders f ON o.customer_id = f.customer_id
),
cohort_counts AS (
    SELECT
        cohort_date,
        cohort_month,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM orders_with_cohort
    GROUP BY cohort_date, cohort_month
)
SELECT
    cohort_date,
    cohort_month,
    active_customers
FROM cohort_counts
ORDER BY cohort_date, cohort_month;
