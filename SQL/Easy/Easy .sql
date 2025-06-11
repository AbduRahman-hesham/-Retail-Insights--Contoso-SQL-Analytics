--What are the total sales per month
SELECT
	DATE_TRUNC('month', orderdate) AS month_start,
	EXTRACT(YEAR FROM orderdate) AS YEAR,
	TO_CHAR(orderdate, 'Month') AS MONTH,
	TO_CHAR(sum(quantity * unitprice * exchangerate), '$999,999,999') AS Revenue
FROM 
	sales
GROUP BY
	month_start,
	YEAR,
	MONTH
ORDER BY
	month_start;

--Which product categories generate the most revenue?
SELECT 
	DISTINCT(categoryname) Category_Name,
	TO_CHAR(sum(quantity * unitprice * exchangerate), '$999,999,999') AS Revenue
FROM 
	sales s
LEFT JOIN
	product p ON
	s.productKey = p.productkey
GROUP BY
	Category_Name;
--Who are the top 10 customers by total revenue?
SELECT
	c.customerKey,
	concat(givenname, ' ', surname ),
	TO_CHAR(sum(quantity * unitprice * exchangerate), '$999,999,999') AS Revenue
FROM 
	sales s
LEFT JOIN
	customer c ON
	s.customerKey = c.customerKey
GROUP BY
	c.customerKey
ORDER BY
	revenue DESC
LIMIT 10;
--What are the average, min, and max sales per region?
SELECT 
	countryname,
	TO_CHAR(sum(quantity * unitprice * exchangerate), '$999,999,999') AS Revenue,
	TO_CHAR(avg(quantity * unitprice * exchangerate), '$999,999,999') AS avg,
	TO_CHAR(max(quantity * unitprice * exchangerate), '$999,999,999') AS max
FROM
	sales s
LEFT JOIN store st ON
	s.storeKey = st.storeKey
GROUP BY
	countryname
ORDER BY
	revenue DESC















	