### Customer Transactions


1. What is the unique count and total amount for each transaction type?

I added percentage for number of transactions. It is a better way to visualize the numbers for the decision makers. 

```SQL
SELECT 
	txn_type AS "Transactions Type", 
	COUNT(txn_type) AS "NumOfTxn",
	CONCAT(ROUND((COUNT(txn_type) / (SUM(COUNT(txn_type)) OVER()) *100),2),'%') 
		AS "% TOTAL Txn",
	CONCAT('$ ',SUM(txn_amount)) AS "Total Amount"
FROM customer_transactions 
GROUP BY txn_type
ORDER BY COUNT(txn_type) DESC
```
Number of transactions were high for deposit it is representing 45.52 % of all the total number of transactions. Although, deposit’s percentage were but if purchases and withdraw were added together they represent 54%. The money going out of bank more. This is just my opinion by looking at this data and from this query. More details needed maybe better to see month to month activities.

2. What is the average total historical deposit counts and amounts for all customers?

```SQL
WITH customerDeposit AS (
	
	SELECT 
		customer_id, 
		COUNT (txn_amount) txnCount, 
		AVG(txn_amount) txnAvg
	FROM customer_transactions
	WHERE txn_type like 'deposit'
	GROUP BY customer_id
)

SELECT 
	ROUND(AVG(txnCount),2) AS avgNumberTransactions, 
	CONCAT('$', ROUND(AVG(txnAvg),2) )AS avgAmount
FROM customerDeposit
```

The avg number of deposits by customer is ~ 5.34 and the average amount they deposited were $508.61

3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

```SQL
```

4. What is the closing balance for each customer at the end of the month?

```SQL
```

5. What is the percentage of customers who increase their closing balance by more than 5%?
```SQL
```
