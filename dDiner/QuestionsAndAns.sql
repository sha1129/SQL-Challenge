
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

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





