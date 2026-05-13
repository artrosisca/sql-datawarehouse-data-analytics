--part to whole analysis
--proportion of a part relative to the whole
--what is the most impact category to the business

--( [measure] / Total[measure] ) * 100 by [dimension]
--( sales / Total Sales ) * 100 by category
--( quantity / total quantity ) * 100 by country

WITH category_sales AS (
SELECT 
category,
SUM(sales_amount) AS total_sales
FROM gold.fact_sales AS fc
LEFT JOIN gold.dim_products AS dp
ON fc.product_key = dp.product_key
GROUP BY category)

SELECT
category,
total_sales,
SUM(total_sales) OVER () overall_sales,
CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2), '%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC