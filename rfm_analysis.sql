-- ====================================================================
-- E-COMMERCE CUSTOMER SEGMENTATION & RFM ANALYSIS
-- Tool: Standard SQL (Compatible with DuckDB, PostgreSQL, BigQuery)
-- ====================================================================

-- STEP 1: RFM Metric Calculation & Scoring Matrix
-- Calculates Recency, Frequency, and Monetary metrics using Common Table Expressions (CTEs).
WITH customer_metrics AS (
    SELECT 
        CustomerID,
        DATEDIFF('day', MAX(InvoiceDate), (SELECT MAX(InvoiceDate) FROM df)) AS recency,
        COUNT(DISTINCT InvoiceNo) AS frequency,
        SUM(Quantity * UnitPrice) AS monetary
    FROM df
    WHERE CustomerID IS NOT NULL 
      AND Quantity > 0 
      AND UnitPrice > 0
    GROUP BY CustomerID
),
rfm_scores AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM customer_metrics
),
labeled_rfm AS (
    SELECT *,
        CASE 
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
            WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Loyal Customers'
            WHEN r_score >= 4 AND f_score = 1 THEN 'New Customers'
            WHEN r_score = 1 THEN 'Lost / Hibernating'
            WHEN r_score >= 3 AND f_score <= 2 THEN 'Promising / Active'
            ELSE 'Regular Customers'
        END AS customer_segment
    FROM rfm_scores
)

-- STEP 2: Final Executive Overview
-- Aggregates data by business segments for direct marketing strategy planning.
SELECT 
    customer_segment,
    COUNT(CustomerID) AS total_customers,
    ROUND(AVG(recency), 1) AS avg_recency_days,
    ROUND(AVG(frequency), 1) AS avg_order_count,
    ROUND(AVG(monetary), 2) AS avg_spend_amt
FROM labeled_rfm
GROUP BY customer_segment
ORDER BY total_customers DESC;
