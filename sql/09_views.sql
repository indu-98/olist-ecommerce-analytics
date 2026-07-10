CREATE VIEW rfm_summary AS
WITH customer_orders AS (
    SELECT 
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp) AS last_purchase,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(p.payment_value) AS monetary
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN payments p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
rfm_scores AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY last_purchase DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary) AS monetary_score
    FROM customer_orders
)
SELECT *,
    CASE 
        WHEN recency_score >= 4 AND frequency_score >= 4 THEN 'Champions'
        WHEN recency_score >= 4 AND frequency_score < 4 THEN 'New/Promising'
        WHEN recency_score < 3 AND frequency_score >= 4 THEN 'At Risk'
        ELSE 'Needs Attention'
    END AS segment
FROM rfm_scores;


CREATE OR REPLACE VIEW cohort_retention AS
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
    TO_CHAR(cd.cohort_month, 'YYYY-MM') AS cohort_month,
    cd.months_since_first,
    cd.active_customers,
    cs.initial_size,
    ROUND(100.0 * cd.active_customers / cs.initial_size, 2) AS retention_pct
FROM cohort_data cd
JOIN cohort_size cs ON cd.cohort_month = cs.cohort_month;


CREATE VIEW mom_growth AS
WITH monthly_rev AS (
    SELECT 
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        SUM(p.payment_value) AS revenue
    FROM orders o
    JOIN payments p ON o.order_id = p.order_id
    GROUP BY 1
)
SELECT 
    month, 
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
    ROUND(((revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month)) * 100, 2) AS growth_pct
FROM monthly_rev;


CREATE VIEW delivery_performance AS
SELECT 
    DATE_TRUNC('month', order_purchase_timestamp) AS month,
    COUNT(*) AS total_delivered,
    SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) AS late_deliveries,
    ROUND(100.0 * SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) / COUNT(*), 2) AS late_pct
FROM orders
WHERE order_status = 'delivered'
GROUP BY 1;


CREATE VIEW repeat_customer_rate AS
WITH order_counts AS (
    SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS num_orders
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN num_orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(100.0 * SUM(CASE WHEN num_orders > 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS repeat_rate_pct
FROM order_counts;

SHOW VIEWS IN SCHEMA olist_ecommerce.public;