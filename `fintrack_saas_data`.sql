create database FinTrack_SaaS_data;
use FinTrack_SaaS_data;
SHOW TABLES;
CREATE VIEW saas_master AS
SELECT 
    c.customer_id,
    c.country,
    c.industry,
    c.signup_date,
    c.company_size,
    s.plan,
    s.monthly_price,
    s.status,
    u.logins,
    u.invoices_created,
    u.support_tickets,
    f.revenue,
    f.cost,
    f.profit
FROM customer c
join subscriptions s ON c.customer_id = s.customer_id join  `usage` u ON c.customer_id = u.customer_id join financials f ON c.customer_id = f.customer_id;
SELECT * FROM saas_master LIMIT 10;
---Q1 — Total Revenue---
SELECT SUM(revenue) AS total_revenue FROM saas_master;
--Q2 — Revenue by Plan--
SELECT plan, SUM(revenue) AS revenue FROM saas_master GROUP BY plan ORDER BY revenue DESC;
--Q3 — Churn Rate--
SELECT ROUND(100 * SUM(status='Churned')/COUNT(*),2) AS churn_rate  FROM saas_master;
--Q4 — Profit by Country--
SELECT country, SUM(profit) AS profit FROM saas_master  GROUP BY country ORDER BY profit DESC;
--Q5 — High Risk Customer--
SELECT customer_id, plan, country, revenue, profit FROM saas_master WHERE status='Active' AND plan='Basic' AND profit < 10;

*🧠 1️⃣ Revenue Metrics (CFO view)*

--Total Monthly Revenue (MRR)--
SELECT SUM(revenue) AS MRR FROM saas_master WHERE status='Active';
--Revenue by Plan--
SELECT plan, SUM(revenue) AS revenue FROM saas_master GROUP BY plan ORDER BY revenue DESC;

*🧠 2️⃣ Churn Intelligence*

--Churn by Plan--
SELECT plan,ROUND(100 * SUM(status='Churned')/COUNT(*),2) AS churn_rate FROM saas_master GROUP BY plan;
--Churn by Country--
SELECT country, ROUND(100 * SUM(status='Churned')/COUNT(*),2) AS churn_rate FROM saas_master GROUP BY country ORDER BY churn_rate DESC;

*🧠 3️⃣ Profitability Analysis*

--Profit by Plan--
SELECT plan, SUM(profit) AS total_profit FROM saas_master GROUP BY plan ORDER BY total_profit DESC;
--Loss-making Customers--
SELECT customer_id, plan, country, profit FROM saas_master WHERE profit < 0;
--Customers likely to churn--
SELECT customer_id, plan, logins, support_tickets FROM saas_master WHERE logins < 5 AND support_tickets > 5 AND status='Active';
-----------------------------------------------------------------------------------------------------------------------------------------
---How much money are we losing every month because customers are leaving?---
SELECT ROUND(SUM(revenue),2) AS churned_revenue_loss FROM saas_master WHERE status = 'Churned';

---Which country is both unprofitable AND losing customers?---
SELECT country,ROUND(SUM(profit),2) AS total_profit,ROUND(100 * SUM(status='Churned')/COUNT(*),2) AS churn_rate FROM saas_master GROUP BY country 
ORDER BY churn_rate DESC, total_profit ASC;







