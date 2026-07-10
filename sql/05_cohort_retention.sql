WITH first_purchase AS (
    SELECT 
        c.customer_unique_id,
        MIN(DATE_TRUNC('month', o.order_purchase_timestamp)) AS cohort_month
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),
customer_activity AS (
    SELECT 
        c.customer_unique_id,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
)
SELECT 
    fp.cohort_month,
    DATEDIFF('month', fp.cohort_month, ca.order_month) AS months_since_first,
    COUNT(DISTINCT ca.customer_unique_id) AS active_customers
FROM first_purchase fp
JOIN customer_activity ca ON fp.customer_unique_id = ca.customer_unique_id
GROUP BY 1, 2
ORDER BY 1, 2;



WITH first_purchase AS (
    SELECT 
        c.customer_unique_id,
        MIN(DATE_TRUNC('month', o.order_purchase_timestamp)) AS cohort_month
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),
customer_activity AS (
    SELECT 
        c.customer_unique_id,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
),
cohort_data AS (
    SELECT 
        fp.cohort_month,
        DATEDIFF('month', fp.cohort_month, ca.order_month) AS months_since_first,
        COUNT(DISTINCT ca.customer_unique_id) AS active_customers
    FROM first_purchase fp
    JOIN customer_activity ca ON fp.customer_unique_id = ca.customer_unique_id
    GROUP BY 1, 2
),
cohort_size AS (
    SELECT cohort_month, active_customers AS initial_size
    FROM cohort_data
    WHERE months_since_first = 0
)
SELECT 
    cd.cohort_month,
    cd.months_since_first,
    cd.active_customers,
    cs.initial_size,
    ROUND(100.0 * cd.active_customers / cs.initial_size, 2) AS retention_pct
FROM cohort_data cd
JOIN cohort_size cs ON cd.cohort_month = cs.cohort_month
ORDER BY cd.cohort_month, cd.months_since_first;