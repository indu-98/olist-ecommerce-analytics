SELECT 
    DATE_TRUNC('month', order_purchase_timestamp) AS month,
    COUNT(*) AS total_delivered,
    SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) AS late_deliveries,
    ROUND(100.0 * SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) / COUNT(*), 2) AS late_pct
FROM orders
WHERE order_status = 'delivered'
GROUP BY 1
ORDER BY 1;