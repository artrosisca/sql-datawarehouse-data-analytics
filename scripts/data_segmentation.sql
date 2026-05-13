--[measure] by [measure]
--total products by sales range
--total customers by age

WITH product_segments AS (
SELECT 
product_key,
product_name,
cost,
CASE
	WHEN cost < 100 THEN 'Below 100'
	WHEN cost BETWEEN 100 AND 500 THEN '100-500'
	WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
	ELSE 'Above 1000'
END cost_range
FROM gold.dim_products)

SELECT 
cost_range,
COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC

--//--

/*Group Customer into three segments based on their spending behavior:
	-VIP: customers with at least 12 months of history but spending 5000 or less
	-Regular: customers with at least 12 months of history but spending 5000 or less
	-New: customers with a lifespan less than 12 months
find the total number of customers by each group*/

WITH customer_spending AS (
SELECT 
dc.customer_key,
SUM(fc.sales_amount) AS total_spending,
MIN(order_date) AS first_order,
MAX(order_date) AS last_order,
DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM gold.fact_sales AS fc
LEFT JOIN gold.dim_customers AS dc
ON fc.customer_key = dc.customer_key
GROUP BY dc.customer_key)

SELECT 
customer_segment,
COUNT(customer_key) AS total_customers
FROM(
SELECT 
customer_key,
CASE 
	WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
	WHEN lifespan >= 12 AND total_spending < 5000 THEN 'Regular'
	ELSE 'New'
END customer_segment
FROM customer_spending) AS sub
GROUP BY customer_segment
ORDER BY total_customers DESC