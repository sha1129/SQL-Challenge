------
-- 1. What is the total amount each customer spent at the restaurant?
------

SELECT s.customer_id, SUM(m.price) as TotalAmount
FROM menu m JOIN sales s
    ON m.product_id = s.product_id
GROUP BY s.customer_id
ORDER BY TotalAmount DESC;


------
-- 2. How many days has each customer visited the restaurant?
------

SELECT  COUNT(DISTINCT order_date), customer_id 
FROM sales
GROUP BY customer_i

-- Notes use distinct inside count to get only unique dates 

------
-- 2.1 As B visited the most, what items did B buy? Order by dates ASC
------
SELECT s.customer_id, m.product_name, s.order_date
FROM sales s JOIN menu m
	ON s.product_id = m.product_id
WHERE s.customer_id LIKE 'B'
ORDER BY s.order_date





------
-- 3. What was the first item from the menu purchased by each customer?
------

WITH firstOrderRank AS (
	SELECT DENSE_RANK() OVER (PARTITION BY customer_ID ORDER BY order_date) AS ranks, customer_ID, order_date, product_id
	FROM sales
)

SELECT DISTINCT f.customer_ID, m.product_name 
FROM firstOrderRank f JOIN menu m
	ON f.product_id = m.product_id
WHERE f.ranks = 1
ORDER BY f.customer_ID
-- Again use distinct to solve the issue that we seen when customer ordered the same item twice 

------
-- 3.1 Names of the most purchased items listed in descending order 
------
SELECT m.product_name, COUNT(s.product_ID) AS "Total"
FROM sales s JOIN menu m
	ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY COUNT(s.product_ID)

------
-- 3.2 Modify above query to show each customers  
------
SELECT s.customer_ID, m.product_name, COUNT (s.product_ID)
FROM sales s JOIN menu m
	ON s.product_id = m.product_id
GROUP BY m.product_name, s.customer_ID
ORDER BY s.customer_ID

------
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
------

SELECT INITCAP(m.product_name) AS "Product Name", COUNT(s.product_id) AS "Most Sold" 
FROM sales s JOIN menu m 
	ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY COUNT(s.product_id) DESC
LIMIT 1

-- INITCAP puts strings in proper format POSTgres

------
-- 5. Which item was the most popular for each customer?
------

WITH favFood AS (
	
	SELECT 
		DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY COUNT(product_id)) AS ranks, 
		customer_id, 
		product_id
	FROM sales
	GROUP BY customer_id, product_id
	ORDER BY customer_id, product_id

)

SELECT 
	f.customer_ID AS "Customer ID", 
	m.product_name AS "Fav Food"
FROM favFood f JOIN menu m
	ON f.product_id = m.product_id
WHERE f.ranks = 1
ORDER BY f.customer_ID


------
-- 6. Which item was purchased first by the customer after they became a member?
------

WITH firstOrdersAfterMember AS (

	SELECT 
		s.customer_id, 
		m.product_name,
		s.order_date,
		RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS ranks
	FROM sales s JOIN menu m
	ON s.product_id = m.product_id
	JOIN members mb
		ON s.customer_id = mb.customer_id
	WHERE s.order_date >= mb.join_date
	ORDER BY s.order_date

)

SELECT customer_id, order_date,product_name
FROM firstOrdersAfterMember
WHERE ranks = 1

------
-- 7. Which item was purchased just before the customer became a member?
------

-- Reverse of Qs 6
WITH firstOrdersBeforeMember AS (
	
		SELECT 
			s.customer_id, 
			m.product_name,
			s.order_date,
			RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS ranks
		FROM sales s JOIN menu m
		ON s.product_id = m.product_id
		JOIN members mb
			ON s.customer_id = mb.customer_id
		WHERE s.order_date < mb.join_date
		ORDER BY s.order_date
	)

SELECT customer_id, order_date,product_name
FROM firstOrdersBeforeMember
WHERE ranks = 1

------
-- 8. What is the total items and amount spent for each member before they became a member?
------

-- Again modify above CTE to get the info 

SELECT 
	s.customer_id AS "Customer ID", 
	count(s.product_id) AS "Total Items",
	SUM(m.price) AS "Total Amount"
FROM sales s JOIN menu m
	ON s.product_id = m.product_id
JOIN members mb
	ON s.customer_id = mb.customer_id
WHERE s.order_date < mb.join_date
GROUP BY s.customer_id 

------
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
------

WITH membersPoints AS (
	
SELECT product_id, product_name,
CASE
	WHEN product_name like 'sushi' THEN price*20
	ELSE price*10 
	END AS points
FROM menu

)

SELECT s.customer_ID, SUM(mp.points) AS "Total Points"
FROM sales s JOIN membersPoints mp 
	ON s.product_ID = mp.product_ID
GROUP BY s.customer_ID

------
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
------

WITH totalPoints AS (
SELECT customer_id, 
	join_date AS start2xPoints, 
	join_date+6 As end2xPoints
FROM members

)

SELECT s.customer_id,
 	SUM (CASE
		 WHEN s.order_date BETWEEN t.start2xPoints and t.end2xPoints THEN m.price*20
		 ELSE m.price*10
		 END
) AS points
FROM totalPoints t JOIN sales s
	ON t.customer_id = s.customer_id
JOIN menu m
	ON s.product_id = m.product_id
WHERE s.order_date < DATE'2021-02-01'
GROUP BY s.customer_id
ORDER BY s.customer_id


