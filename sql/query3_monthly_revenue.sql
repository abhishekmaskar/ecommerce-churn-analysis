SELECT
    strftime('%Y-%m', InvoiceDate) AS month,
    COUNT(DISTINCT CustomerID) AS active_customers,
    COUNT(DISTINCT Invoice) AS total_orders,
    ROUND(SUM(Revenue), 2) AS monthly_revenue,
    ROUND(AVG(Revenue), 2) AS avg_order_value
FROM retail_clean
GROUP BY strftime('%Y-%m', InvoiceDate)
ORDER BY month;