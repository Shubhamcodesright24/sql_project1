CREATE DATABASE sql_project_p2
-- creating table
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

-- Data Cleaning

SELECT * FROM retail_sales
LIMIT 10;


SELECT COUNT(*) FROM retail_sales

--checking for null values
SELECT * FROM retail_sales
WHERE 
	transactions_id is NULL
    OR
	sale_date is NULL
	OR
	sale_time is NULL
    OR
	customer_id is NULL
	OR
	gender is NULL
	OR
	age is NULL
	OR
	category is NULL
	OR
	quantity is NULL
	OR
	price_per_unit is NULL
	OR
	cogs is NULL
	OR
	total_sale is NULL;

-- deleting null values
	DELETE  FROM retail_sales
WHERE 
	transactions_id is NULL
    OR
	sale_date is NULL
	OR
	sale_time is NULL
    OR
	customer_id is NULL
	OR
	gender is NULL
	OR
	category is NULL
	OR
	quantity is NULL
	OR
	price_per_unit is NULL
	OR
	cogs is NULL
	OR
	total_sale is NULL;


--Data Exploration

-- how many sales we had?

SELECT COUNT(*) as total_sales from retail_sales

-- how many unique customers we had?

SELECT COUNT(DISTINCT customer_id)  from retail_sales

-- how many unique category we had?

SELECT DISTINCT category from retail_sales



--Data Analysis and Business Problems

--Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND
quantity > 3
AND
TO_CHAR(sale_date , 'YYYY-MM') = '2022-11';


--Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
category,
SUM(total_sale) as net_sales,
COUNT(*) as total_sales
FROM retail_sales
GROUP BY 1;

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT
ROUND(AVG(age),2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'


--Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT * FROM retail_sales
WHERE total_sale>= 1000

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT 
category,
gender,
COUNT(*) as total_trans
FROM retail_sales
GROUP
	BY
	category,
	gender
	ORDER BY 1


--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT 
	year,
	month,
	avg_sale
FROM 
(
	SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
	RANK () OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC ) as rank
	FROM retail_sales
	GROUP BY 1,2
) as t2

WHERE rank = 1


--Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT
	customer_id,
	SUM(total_sale)
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


--Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT
	category,
	COUNT(DISTINCT(customer_id))
FROM retail_sales
GROUP BY 1


--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sales 
AS
(
SELECT *,
		CASE
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS Shift
FROM retail_sales
)
SELECT
	Shift,
	COUNT(transactions_id)
	FROM hourly_sales
GROUP BY 1

-- END OF THE PROJECT
