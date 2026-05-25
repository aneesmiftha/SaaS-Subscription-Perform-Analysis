SaaS Subscription Performance & Retention Analysis
Project Overview
This project focuses on analyzing customer subscription data for a Business-to-Business (B2B) Software-as-a-Service (SaaS) platform. The objective was to clean raw operational data, engineer core SaaS metrics (Customer Lifetime Value, Churn Rate, and Tenure), and build an executive-facing dashboard to uncover which subscription tiers drive the highest business value and stability.
Tech Stack & Tools
Data Processing: Python (Built-in data chunking & staging)
Database & Business Logic:MySQL Workbench
Data Visualization:Power BI Desktop
Data Source: saas_data table containing operational subscription records
Phase 1: Database View & Metric Engineering (SQL)
To create a reliable data pipeline, a unified database VIEW was developed in MySQL. This handles the calculation of key metrics dynamically, resolving open-ended subscriptions using the current calendar date to calculate active tenure.
```sql
USE saas_project;

CREATE OR REPLACE VIEW saas_metrics_summary AS
SELECT 
    plan_tier,
    COUNT(subscription_id) AS total_customers,
    ROUND(AVG(mrr_amount), 2) AS avg_monthly_revenue,
    ROUND(AVG(TIMESTAMPDIFF(
        MONTH, 
        start_date, 
        COALESCE(NULLIF(end_date, ''), CURDATE())
    )), 1) AS avg_tenure_months,
    ROUND(AVG(mrr_amount) * AVG(TIMESTAMPDIFF(
        MONTH, 
        start_date, 
        COALESCE(NULLIF(end_date, ''), CURDATE())
    )), 2) AS customer_lifetime_value,
 ROUND((COUNT(NULLIF(end_date, '')) / COUNT(subscription_id)) * 100, 2) AS churn_rate_percentage
FROM saas_data
GROUP BY plan_tier;
Phase 2: Key Business Insights
Based on the aggregated metrics calculated from the database layer, the business performance maps across the subscription tiers as follows:
| Metric Focus | Enterprise Tier | Pro Tier | Basic Tier | Executive Takeaway |
| **Customer Count** | 1,723 | 1,675 | 1,602 | Customer acquisition is balanced evenly across all three tiers. |
| **Avg. Monthly Revenue** | $4,917.71 | $1,256.77 | $474.68 | Enterprise generates **10x** the monthly revenue of the Basic tier per user. |
|Avg. Tenure (Months)| 19.7 months | 19.8 months | 20.0 months | Customer lifespan is uniform across the board, averaging 20 months. |
|Customer Lifetime Value | $96,807.32 | $24,923.05 | $9,516.11| An Enterprise user is worth **10x** more over their lifespan than a Basic user. |
| **Churn Rate (%)** | 9.98% | 9.67% | 9.49% | Churn is healthy and tightly locked in at **~9.7%** across all price points. |
Phase 3: Dashboard Architecture (Power BI)
The processed insights were exported into Power BI Desktop to construct the **SaaS Subscription Performance & Retention Dashboard**.
Visual Elements Included:
 * **KPI Metric Cards:** High-level executive indicators displaying the macro business environment:
   * **Average Churn Rate:** Fixed at a stable 9.71 macro-average.
   * **Average Retention:** Front-facing display of the 19.83 month customer lifespan.
 * **Horizontal Clustered Bar Chart:** A direct visualization mapping **Customer Lifetime Value (LTV) by Plan Tier**, proving that the Enterprise plan acts as the core revenue engine of the business.
Strategic Recommendations
 1. **Aggressive Enterprise Marketing Pivot:** Since customer volume is nearly equal across tiers, but the Enterprise tier yields an individual LTV of **$96.8K** (compared to Basic’s $9.5K), marketing budgets should heavily favor corporate Enterprise acquisition.
 2. **Targeted Milestone Expansion:** With average customer lifespans hitting a natural wall at 20 months across all plans, automated customer success outreach and account expansion campaigns should be targeted between months 6 and 12 to cross-sell users into higher tiers before they approach the average churn window.
