SELECT
    Country,
    COUNT(DISTINCT CustomerID) AS customers,
    COUNT(DISTINCT Invoice) AS orders,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    ROUND(AVG(Revenue), 2) AS avg_order_value
FROM retail_clean
GROUP BY Country
ORDER BY total_revenue DESC
LIMIT 15;