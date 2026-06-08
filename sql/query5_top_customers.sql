SELECT
    CustomerID,
    Country,
    COUNT(DISTINCT Invoice) AS total_orders,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    ROUND(AVG(Revenue), 2) AS avg_order_value,
    MIN(strftime('%Y-%m', InvoiceDate)) AS first_purchase,
    MAX(strftime('%Y-%m', InvoiceDate)) AS last_purchase
FROM retail_clean
GROUP BY CustomerID, Country
ORDER BY total_revenue DESC
LIMIT 20;