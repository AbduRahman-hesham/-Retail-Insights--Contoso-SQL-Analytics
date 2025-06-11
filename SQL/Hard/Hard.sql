--1- What are the top 3 products per customer by total spend?
WITH customer_product_revenue AS (
SELECT
	c.customerkey,
	CONCAT(givenname, ' ', surname) AS customer_name,
	p.productname,
	SUM(quantity * unitprice * exchangerate) AS total_spent
FROM
	sales s
JOIN customer c ON
	s.customerkey = c.customerkey
JOIN product p ON
	s.productKey = p.productKey
GROUP BY
	c.customerkey,
	customer_name,
	p.productname
),
ranked_products AS (
SELECT
	*,
	DENSE_RANK() OVER (PARTITION BY customerkey
ORDER BY
	total_spent DESC) AS product_rank
FROM
	customer_product_revenue
)
SELECT
	customerkey,
	customer_name,
	productname,
	TO_CHAR(total_spent, '$999,999.00') AS total_spent,
	product_rank
FROM
	ranked_products
WHERE
	product_rank <= 3
ORDER BY
	customerkey,
	product_rank;
--2- What is each customer’s Lifetime Value (LTV)?
WITH 
customer_spending AS (
SELECT
	customerKey,
	SUM(quantity * unitprice * exchangerate) AS total_spent,
	COUNT(DISTINCT orderKey) AS total_orders,
	COUNT(DISTINCT DATE_TRUNC('month', orderdate)) AS active_months
FROM
	sales
GROUP BY
	customerKey
),
metrics AS (
SELECT
	customerKey,
	total_spent,
	total_orders,
	-- Average Order Value
	total_spent / NULLIF(total_orders, 0) AS avg_order_value,
	-- Purchase Frequency (orders per month)
	total_orders / NULLIF(active_months, 0) AS purchase_frequency,
	-- Customer Lifespan (months since first purchase)
        EXTRACT(MONTH FROM AGE(CURRENT_DATE, MIN(orderdate))) AS customer_lifespan
FROM
	customer_spending
JOIN sales
		USING (customerKey)
GROUP BY
	customerKey,
	total_spent,
	total_orders,
	active_months
)
SELECT
	customerKey,
	ROUND(total_spent::NUMERIC, 2) AS historical_ltv,
	ROUND(
        (avg_order_value * purchase_frequency * customer_lifespan)::NUMERIC, 
        2
    ) AS predicted_ltv,
	total_orders,
	ROUND(avg_order_value::NUMERIC, 2) AS avg_order_value,
	ROUND(purchase_frequency::NUMERIC, 2) AS monthly_purchases,
	customer_lifespan
FROM
	metrics
ORDER BY
	predicted_ltv DESC;
--3- Which regions are losing customers over time
WITH max_date AS (
SELECT
	MAX(orderdate) AS max_order_date
FROM
	sales
),
LAST_quarter AS (
SELECT
	st.storeKey,
	COUNT(DISTINCT s.customerKey) AS customer_count_last
FROM
	sales s
JOIN store st ON
	s.storeKey = st.storeKey
JOIN max_date md ON
	TRUE
WHERE
	s.orderdate >= md.max_order_date - INTERVAL '3 months'
GROUP BY
	st.storeKey
),
prev_quarter AS (
SELECT
	st.storeKey,
	COUNT(DISTINCT s.customerKey) AS customer_count_prev
FROM
	sales s
JOIN store st ON
	s.storeKey = st.storeKey
JOIN max_date md ON
	TRUE
WHERE
	s.orderdate BETWEEN md.max_order_date - INTERVAL '6 months' 
                      AND md.max_order_date - INTERVAL '3 months'
GROUP BY
	st.storeKey
)
SELECT
	st.storeKey,
	customer_count_last ,
	customer_count_prev,
	CASE
		WHEN customer_count_last > customer_count_prev THEN '1'
		ELSE '0'
	END AS comparison_flag
FROM
	store st
RIGHT JOIN last_quarter lq ON
	st.storeKey = lq.storeKey
LEFT JOIN prev_quarter pq ON
	st.storeKey = pq.storeKey;
