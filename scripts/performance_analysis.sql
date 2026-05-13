--(current[measure] - target[measure])
--process of comparing current with target value
--current year - previous year (yoy)

--analyzing year performance of products, by comparing their sales to both average sales perfomance of the product and te previous year`s sales

--trocar aqui por month -> month over month
WITH yearly_product_sales AS (
SELECT 
YEAR(fc.order_date) AS order_year,
dp.product_name,
SUM(fc.sales_amount) AS current_sales
FROM gold.fact_sales AS fc
LEFT JOIN gold.dim_products AS dp
ON fc.product_key = dp.product_key
WHERE fc.order_date IS NOT NULL
GROUP BY
YEAR(fc.order_date),
dp.product_name
)

SELECT 
order_year,
product_name,
current_sales,
AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
CASE 
	WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above average'
	WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below average'
	ELSE 'Average'
END avg_change,
--year over year analysis
LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS previous_year_sales,
current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_previous_year,
CASE 
	WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
	WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
	ELSE 'No change'
END previous_year_change
FROM yearly_product_sales
ORDER BY product_name, order_year