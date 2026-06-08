WITH first_purchase AS (
    SELECT
        CustomerID,
        strftime('%Y-%m', InvoiceDate) AS cohort_month
    FROM retail_clean
    GROUP BY CustomerID
    HAVING InvoiceDate = MIN(InvoiceDate)
),

customer_activity AS (
    SELECT
        r.CustomerID,
        strftime('%Y-%m', r.InvoiceDate) AS activity_month,
        f.cohort_month,
        (
            (CAST(strftime('%Y', r.InvoiceDate) AS INT) -
             CAST(strftime('%Y', f.cohort_month || '-01') AS INT)) * 12 +
            (CAST(strftime('%m', r.InvoiceDate) AS INT) -
             CAST(strftime('%m', f.cohort_month || '-01') AS INT))
        ) AS month_number
    FROM retail_clean r
    JOIN first_purchase f ON r.CustomerID = f.CustomerID
)

SELECT
    cohort_month,
    month_number,
    COUNT(DISTINCT CustomerID) AS active_customers
FROM customer_activity
WHERE month_number >= 0
GROUP BY cohort_month, month_number
ORDER BY cohort_month, month_number;