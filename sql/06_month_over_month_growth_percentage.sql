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
FROM monthly_rev
ORDER BY month;