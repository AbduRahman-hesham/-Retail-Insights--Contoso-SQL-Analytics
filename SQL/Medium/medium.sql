--Which employees have higher-than-average sales performance
WITH customer_revenue AS (
    SELECT 
        c.customerkey,
        CONCAT(c.givenname, ' ', c.surname) AS full_name,
        SUM(s.quantity * s.unitprice * s.exchangerate) AS revenue
    FROM 
        sales s
        LEFT JOIN customer c ON s.customerkey = c.customerkey
    GROUP BY 
        c.customerkey, full_name
),
average_revenue AS (
    SELECT AVG(revenue) AS avg_revenue
    FROM customer_revenue
)
SELECT 
    cr.customerkey,
    cr.full_name,
    TO_CHAR(cr.revenue, '$999,999,999.00') AS revenue
FROM 
    customer_revenue cr,
    average_revenue ar
WHERE 
    cr.revenue > ar.avg_revenue
ORDER BY 
    cr.revenue DESC;

--What are the top-selling products per region?
WITH ranking AS (
SELECT 
	countryname,
	productname,
	TO_CHAR(sum(quantity * unitprice * exchangerate), '$999,999,999') AS Revenue,
	RANK() OVER(PARTITION BY countryname ORDER BY sum(quantity * unitprice * exchangerate) DESC) AS RANK
FROM
	sales s
LEFT JOIN store st ON
	s.storekey = st.storekey
LEFT JOIN product p ON
	s.productkey = p.productkey
GROUP BY
	countryname,
	productname
)
SELECT
	countryname,
	productname,
	RANK
FROM
	ranking
WHERE
	RANK <= 4
ORDER BY
	countryname,
	RANK;
--What is the monthly growth in revenue (MoM %)
WITH current_Month AS (
SELECT
	EXTRACT(YEAR FROM orderdate) AS YEAR,
	DATE_TRUNC('month', orderdate) AS month,
	sum(quantity * unitprice * exchangerate) AS CURRENT_rev
FROM 
	sales
GROUP BY YEAR,MONTH
ORDER BY YEAR,month
),prev_month AS (
SELECT 
	YEAR,
	MONTH,
	current_rev,
	lag(current_rev,1)over() AS prev
	FROM current_month
)
SELECT
	YEAR,
	MONTH,
    TO_CHAR(current_rev, '$999,999,999') AS current,
    TO_CHAR(prev, '$999,999,999') AS previous,
    TO_CHAR(
            ROUND(
                ((current_rev - prev) / prev * 100)::NUMERIC,
                2
            ),
            'FM999,999,999.00%'  -- The % symbol here
        )
FROM prev_month



