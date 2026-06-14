# E-Commerce Customer Segmentation Pipeline (RFM Analysis)

## 📌 Project Overview
This project targets a large-scale, raw transactional dataset containing sales records from a UK-based online retail store. Using advanced database logic, I engineered an **RFM (Recency, Frequency, Monetary) Segmentation Model** to group a chaotic customer base into distinct, actionable cohorts. This script drives data-driven marketing decisions by identifying high-value customers, fresh prospects, and at-risk shoppers.

---

## 🛠️ Tech Stack & Methods
* **Database Engine:** SQL queries executed via DuckDB / Python environment
* **Data Engineering Techniques:** Data type casting, database view creation, handling null values, conditional transaction filtering
* **Analytical Features:** Window Functions (`NTILE`), Common Table Expressions (CTEs), Aggregations, Conditional Case Logic

---

## 🧼 Data Quality & Cleaning Strategy
The raw dataset originally contained **541,909 records**. Before performing behavioral segmentation, I executed a data quality check that exposed critical anomalies:
* **135,080 rows** were missing a valid `CustomerID`.
* **10,624 transactions** showed negative quantities due to stock returns or order cancellations.
* The system caught severe pricing anomalies, including negative unit prices down to **-$11,062.06**.

**Action taken:** I isolated and filtered out all missing IDs and non-positive metrics, leaving a robust, clean production layer of **397,884 verified records** to protect calculations.

---

## 📊 Strategic Business Insights
After scaling customer profiles across 1-5 grading ranks via `NTILE(5)`, the matrix grouped the active customer base into high-level commercial cohorts:

| Customer Segment | Total Customers | Avg Recency (Days) | Avg Order Count | Avg Spend Amt ($) |
| :--- | :---: | :---: | :---: | :---: |
| **Regular Customers** | 1,032 | 100.6 | 2.5 | $819.92 |
| **Champions (VIPs)** | 904 | 11.7 | 11.5 | $6,266.15 |
| **Lost / Hibernating** | 868 | 267.8 | 1.5 | $643.83 |
| **Loyal Customers** | 762 | 34.4 | 4.2 | $1,952.14 |
| **Promising / Active** | 537 | 40.9 | 1.5 | $517.19 |
| **New Customers** | 235 | 18.4 | 1.0 | $325.72 |

---

## 💡 Operational Recommendations
1. **Maximize Value from Champions:** Enroll the 904 VIP customers into an exclusive loyalty tier or referral program. They provide the core margin base, visiting every ~11 days and spending over $6,200 on average.
2. **Convert the New Shoppers:** Target the 235 new customers with an automated discount message within 14 days of their first purchase to incentivize an immediate second conversion.
3. **Re-engage or Cut Losses:** For the 868 hibernating profiles who haven't shopped in ~268 days, run a low-cost, automated re-engagement campaign. Avoid massive spending on them as they show high risk of platform churn.
