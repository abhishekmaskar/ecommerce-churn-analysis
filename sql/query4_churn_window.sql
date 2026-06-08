WITH first_purchase AS (
    SELECT CustomerID,
           strftime('%Y-%m', MIN(InvoiceDate)) AS cohort_month
    FROM retail_clean
    GROUP BY CustomerID
),
cohort_size AS (
    SELECT cohort_month, COUNT(DISTINCT CustomerID) AS cohort_customers
    FROM first_purchase
    GROUP BY cohort_month
),
monthly_active AS (
    SELECT
        f.cohort_month,
        (
            (CAST(strftime('%Y', r.InvoiceDate) AS INT) -
             CAST(strftime('%Y', f.cohort_month || '-01') AS INT)) * 12 +
            (CAST(strftime('%m', r.InvoiceDate) AS INT) -
             CAST(strftime('%m', f.cohort_month || '-01') AS INT))
        ) AS month_number,
        COUNT(DISTINCT r.CustomerID) AS active_customers
    FROM retail_clean r
    JOIN first_purchase f ON r.CustomerID = f.CustomerID
    GROUP BY f.cohort_month, month_number
)
SELECT
    m.month_number,
    SUM(m.active_customers) AS total_active,
    SUM(c.cohort_customers) AS total_cohort,
    ROUND(100.0 * SUM(m.active_customers) / SUM(c.cohort_customers), 1) AS retention_pct
FROM monthly_active m
JOIN cohort_size c ON m.cohort_month = c.cohort_month
WHERE m.month_number BETWEEN 0 AND 12
GROUP BY m.month_number
ORDER BY m.month_number;