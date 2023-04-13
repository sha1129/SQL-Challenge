### Customer Node Exploration

1. How many unique nodes are there on the Data Bank system?

```SQL
SELECT 
	COUNT(DISTINCT node_id) AS "Unique Nodes"
FROM customer_nodes
```
There are 5 distinct nodes in the Customer Nodes tabel

2. What is the number of nodes per region?

```SQL
SELECT
	r.region_id,
	r.region_name,
	COUNT(node_id) AS "Number of Nodes"
FROM customer_nodes c JOIN regions r
	ON c.region_id = r.region_id 
GROUP BY 1,2
ORDER BY COUNT(node_id) DESC
```
Australia have the highest number of nodes 770 and Euro have the lowest 616

3. How many customers are allocated to each region?

```SQL
SELECT
	r.region_id,
	r.region_name,
	COUNT(DISTINCT customer_id) AS "Number of Customers"
FROM customer_nodes c JOIN regions r
	ON c.region_id = r.region_id 
GROUP BY 1,2
ORDER BY COUNT(node_id) DESC

```
4. How many days on average are customers reallocated to a different node?

```SQL
```

5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

```SQL
```