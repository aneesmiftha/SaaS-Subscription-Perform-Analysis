create database saas_project;
use saas_project;
SELECT 
    plan_tier,
    COUNT(subscription_id) AS total_customers,
    
    -- Count how many customers have an end date (canceled)
    COUNT(NULLIF(end_date, '')) AS total_canceled_customers,
    
    -- Calculate Churn Rate percentage
    ROUND(
        (COUNT(NULLIF(end_date, '')) / COUNT(subscription_id)) * 100, 
        2
    ) AS churn_rate_percentage
FROM saas_data
GROUP BY plan_tier;
