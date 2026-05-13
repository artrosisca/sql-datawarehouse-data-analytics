----Change over time trends but make it cumulative 
--cumulative measure by date_dimension

--total sales per month
--and running total of sales over time

SELECT
order_date,
total_sales,
SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales
--window function to calculate the running total
FROM (
	SELECT 
	DATETRUNC(month,order_date) AS order_date,
	SUM(sales_amount) AS total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(month, order_date)
) AS sub

--reset the running total for each year
SELECT
order_date,
total_sales,
SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales
--window function to calculate the running total
FROM (
	SELECT 
	DATETRUNC(YEAR,order_date) AS order_date,
	SUM(sales_amount) AS total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(YEAR, order_date)
) AS sub

--reset the running total for each year
--mobing average
SELECT
order_date,
total_sales,
SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales,
AVG(avg_price) OVER(ORDER BY order_date) AS moving_average_price
--window function to calculate the running total
FROM (
	SELECT 
	DATETRUNC(YEAR,order_date) AS order_date,
	SUM(sales_amount) AS total_sales,
	AVG(price) AS avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(YEAR, order_date)
) AS sub