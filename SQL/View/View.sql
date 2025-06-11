-- view that returns for each month: total sales, new customers, repeat customers, and top category 
CREATE OR REPLACE
VIEW monthly_business_summary AS
WITH sales_base AS (
SELECT
	s.orderdate,
	DATE_TRUNC('month', s.orderdate) AS MONTH,
	s.customerkey,
	s.productKey,
	s.quantity * s.unitprice * s.exchangerate AS revenue
FROM
	sales s
),
first_purchase AS (
SELECT
	customerkey,
	MIN(DATE_TRUNC('month', orderdate)) AS first_month
FROM
	sales
GROUP BY
	customerkey
),
monthly_sales AS (
SELECT
	sb.month,
	ROUND(SUM(sb.revenue)::numeric, 2) AS total_sales,
	COUNT(DISTINCT CASE WHEN fp.first_month = sb.month THEN sb.customerkey END) AS new_customers,
	COUNT(DISTINCT CASE WHEN fp.first_month < sb.month THEN sb.customerkey END) AS repeat_customers
FROM
	sales_base sb
JOIN first_purchase fp ON
	sb.customerkey = fp.customerkey
GROUP BY
	sb.month
),
top_category AS (
SELECT
	DATE_TRUNC('month', s.orderdate) AS MONTH,
	p.categoryname,
	SUM(s.quantity * s.unitprice * s.exchangerate) AS category_revenue,
	RANK() OVER (PARTITION BY DATE_TRUNC('month', s.orderdate)
ORDER BY
	SUM(s.quantity * s.unitprice * s.exchangerate) DESC) AS category_rank
FROM
	sales s
JOIN product p ON
	s.productKey = p.productKey
GROUP BY
	MONTH,
	p.categoryname
)
SELECT
	ms.month,
	TO_CHAR(ms.month, 'YYYY-MM') AS month_label,
	ms.total_sales,
	ms.new_customers,
	ms.repeat_customers,
	tc.categoryname AS top_category,
	round((abs(ms.repeat_customers)::numeric/(ms.new_customers+ms.repeat_customers))*100,2) AS persentage_of_loyality
FROM
	monthly_sales ms
LEFT JOIN top_category tc
ON
	ms.month = tc.month
	AND tc.category_rank = 1
ORDER BY
	ms.month;

SELECT * FROM monthly_business_summary;
