-- PROJECT: Salon Business Performance Analysis
-- TOOL: MySQL
-- DESCRIPTION: Analysis of revenue, customer behavior, and business performance



-- ================================
-- SECTION 1: BUSINESS OVERVIEW
-- ================================

-- Total Revenue (completed only)
SELECT SUM(price) AS total_revenue
FROM appointments 
WHERE status = 'Completed';

-- Total number of appointments
SELECT COUNT(*) AS total_appointments
FROM appointments;

-- Revenue per Service 
SELECT service, 
SUM(price) AS total_revenue
FROM appointments 
WHERE status = 'Completed'
GROUP BY service
ORDER BY total_revenue DESC;

-- Revenue per Staff 
SELECT staff, 
SUM(price) AS total_revenue
FROM appointments 
WHERE status = 'Completed'
GROUP BY staff
ORDER BY total_revenue DESC;

-- Average Revenue per Appointment (Completed)
SELECT AVG(price) AS avg_revenue
FROM appointments
WHERE status = 'Completed';

-- ================================
-- SECTION 2: CUSTOMER ANALYSIS
-- ================================

-- Customers that have visited more than once (repeat customers)
SELECT customer_id, 
COUNT(*) AS total_appointments
FROM appointments
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY total_appointments DESC;

-- Number of times each customer has visited (Customer frequency)
SELECT customer_id, 
COUNT(*) AS number_of_visits
FROM appointments
GROUP BY customer_id
ORDER BY number_of_visits DESC;

 -- Top 5 customers by revenue
 SELECT customer_id, 
SUM(price) AS total_revenue
FROM appointments
WHERE status = 'Completed'
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 5;

-- Customers that have spent more than 20,000 (High value customers)
SELECT customer_id, 
SUM(price) AS total_revenue
FROM appointments
WHERE status = 'Completed'
GROUP BY customer_id
HAVING SUM(price) > 20000
ORDER BY total_revenue DESC;

-- Customer segmentation (Low, medium and High spenders)
WITH customer_spending AS (
SELECT customer_id, 
SUM(price) AS total_spending
FROM appointments
WHERE status = 'Completed'
GROUP BY customer_id)
SELECT *, 
CASE 
WHEN total_spending < 10000 THEN 'Low Value'
WHEN total_spending >= 10000 AND total_spending < 20000 THEN 'Medium Value'
ELSE 'High Value' 
END AS spend_category
FROM customer_spending
ORDER BY total_spending DESC; 
-- ================================
-- SECTION 3: REVENUE INSIGHTS
-- ================================

-- Revenue by price category 
WITH price_categorization AS (
SELECT appointment_id, service, price, status,
CASE 
WHEN price < 6000 THEN 'Low'
WHEN price >= 6000 AND price < 10000 THEN 'Medium'
ELSE 'High' 
END AS price_category 
FROM appointments)

SELECT price_category, 
SUM(price) AS total_revenue
FROM price_categorization
WHERE status = 'Completed' 
GROUP BY price_category
ORDER BY total_revenue DESC; 

-- Daily Revenue Trend
SELECT date, 
SUM(price) AS total_revenue 
FROM appointments
WHERE status = 'Completed'
GROUP BY date
ORDER BY date;

-- Running total revenue (cumulative revenue over time)
WITH daily_revenue AS (
SELECT date, 
SUM(price) AS total_revenue 
FROM appointments
WHERE status = 'Completed'
GROUP BY date) 

SELECT *, 
SUM(total_revenue) OVER(ORDER BY date) AS running_total
FROM daily_revenue;
