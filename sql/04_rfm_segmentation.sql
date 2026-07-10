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
),
segmented AS (
    SELECT *,
        CASE 
            WHEN recency_score >= 4 AND frequency_score >= 4 THEN 'Champions'
            WHEN recency_score >= 4 AND frequency_score < 4 THEN 'New/Promising'
            WHEN recency_score < 3 AND frequency_score >= 4 THEN 'At Risk'
            ELSE 'Needs Attention'
        END AS segment
    FROM rfm_scores
)
SELECT 
    segment, 
    COUNT(*) AS num_customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_customers
FROM segmented
GROUP BY segment
ORDER BY num_customers DESC;