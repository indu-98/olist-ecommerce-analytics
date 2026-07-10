SELECT 
    ct.product_category_name_english AS category,
    SUM(oi.price) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS num_orders
FROM order_items oi
JOIN products pr ON oi.product_id = pr.product_id
JOIN category_translation ct ON pr.product_category_name = ct.product_category_name
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;