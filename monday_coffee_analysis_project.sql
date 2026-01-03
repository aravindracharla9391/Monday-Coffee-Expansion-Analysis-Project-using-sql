/* 
PROJECT NAME : MONDAY COFFEE EXPANSION ANALYSIS 

PROBLEM STATEMENT:

Monday Coffee is looking to expand its coffee business into new and existing cities, but lacks a clear understanding of customer behavior,
sales trends, and market potential across different locations. The challenge is to identify which cities have the highest potential for coffee sales, 
understand which products are most popular, and evaluate how city-specific factors like population, estimated rent, and customer demographics impact sales. 
Without this analysis, business expansion decisions risk being inefficient and may fail to maximize revenue and customer engagement.

The project aims to solve this problem by analyzing historical sales data, customer data, and city demographics to provide actionable insights for strategic expansion,
 product prioritization, and marketing decisions.
 
 
PROJECT OBJECTIVE:
The objective of the Monday Coffee Expansion Analysis project is to analyze coffee sales, customer behavior, and market potential 
across various cities to support strategic business growth. The project focuses on identifying cities with the highest coffee consumption
and sales potential,  determining top-selling products, evaluating revenue and average sales per customer, and tracking monthly sales trends. Additionally,
it aims to segment customers based on purchase behavior and city demographics, and assess the relationship between city-specific factors such as population and rent with coffee sales. The insights gained from this analysis will enable Monday Coffee to make informed decisions regarding market expansion, product prioritization, and targeted marketing strategies to maximize revenue and enhance customer engagement.
*/

-- DATABASE & TABLE STRUCTURE CREATION

create database monday_coffee;
use monday_coffee;

-- Note: Data for all tables (city, products, customers, sales) was inserted using the SQL Workbench Table Data Import Wizard from the dataset.

-- Table 1: city
CREATE TABLE city
(
	city_id	INT PRIMARY KEY,
	city_name VARCHAR(15),	
	population	BIGINT,
	estimated_rent	FLOAT,
	city_rank INT
);
select * from city;

 -- Table 2: products;
CREATE TABLE products
(
	product_id	INT PRIMARY KEY,
	product_name VARCHAR(35),	
	Price float
);
select * from products;

-- Table 3: customers 
CREATE TABLE customers
(
	customer_id INT PRIMARY KEY,	
	customer_name VARCHAR(25),	
	city_id INT,
	CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES city(city_id)
);
select * from customers;

-- Table 4: sales
CREATE TABLE sales
(
	sale_id	INT PRIMARY KEY,
	sale_date	date,
	product_id	INT,
	customer_id	INT,
	total FLOAT,
	rating INT,
	CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES products(product_id),
	CONSTRAINT fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
);
select * from sales;




-- DATA ANALYSIS QUESTIONS


-- Q.1 Coffee Consumers Count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does?
SELECT 
	city_name,
	ROUND(
	(population * 0.25)/1000000, 
	2) as coffee_consumers_in_millions,
	city_rank
FROM city
ORDER BY 2 DESC;


-- Q.2 Total Revenue from Coffee Sales
-- i. What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?
SELECT 
	SUM(total) as total_revenue
FROM sales
WHERE 
	EXTRACT(YEAR FROM sale_date)  = 2023
	AND
	EXTRACT(quarter FROM sale_date) = 4;

 -- ii .What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?   
 SELECT 
	ci.city_name,
	SUM(s.total) as total_revenue
FROM sales as s
JOIN customers as c
ON s.customer_id = c.customer_id
JOIN city as ci
ON ci.city_id = c.city_id
WHERE 
	EXTRACT(YEAR FROM s.sale_date)  = 2023
	AND
	EXTRACT(quarter FROM s.sale_date) = 4
GROUP BY ci.city_name
ORDER BY total_revenue DESC;


-- Q.3  Sales Count for Each Product
-- How many units of each coffee product have been sold?
SELECT 
	p.product_name,
	COUNT(s.sale_id) as total_orders
FROM products as p
LEFT JOIN
sales as s
ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_orders DESC;


-- Q.4  Average Sales Amount per City
--  What is the average sales amount per customer in each city?

SELECT 
    ci.city_name,
    SUM(s.total) AS total_revenue,
    COUNT(DISTINCT s.customer_id) AS total_cx,
    ROUND(
        SUM(s.total) / COUNT(DISTINCT s.customer_id),
        2
    ) AS avg_sale_pr_cx
FROM sales s
JOIN customers c 
    ON s.customer_id = c.customer_id
JOIN city ci 
    ON ci.city_id = c.city_id
GROUP BY ci.city_name
ORDER BY total_revenue DESC;


--  Q.5 City Population and Coffee Consumers
-- Provide a list of cities along with their populations and estimated coffee consumers.

WITH city_table as 
(
	SELECT 
		city_name,
		ROUND((population * 0.25)/1000000, 2) as coffee_consumers
	FROM city
),
customers_table
AS
(
	SELECT 
		ci.city_name,
		COUNT(DISTINCT c.customer_id) as unique_cx
	FROM sales as s
	JOIN customers as c
	ON c.customer_id = s.customer_id
	JOIN city as ci
	ON ci.city_id = c.city_id
	GROUP BY 1
)
SELECT 
	customers_table.city_name,
	city_table.coffee_consumers as coffee_consumer_in_millions,
	customers_table.unique_cx
FROM city_table
JOIN 
customers_table
ON city_table.city_name = customers_table.city_name;

-- -- Q6  Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?

SELECT *
FROM (
    SELECT
        city_name,
        product_name,
        total_orders,
        DENSE_RANK() OVER (
            PARTITION BY city_name
            ORDER BY total_orders DESC
        ) AS rnk
    FROM (
        SELECT
            ci.city_name,
            p.product_name,
            COUNT(s.sale_id) AS total_orders
        FROM sales s
        JOIN products p ON s.product_id = p.product_id
        JOIN customers c ON c.customer_id = s.customer_id
        JOIN city ci ON ci.city_id = c.city_id
        GROUP BY ci.city_name, p.product_name
    ) t
) t1
WHERE rnk <= 3;

-- Q.7 Customer Segmentation by City
-- How many unique customers are there in each city who have purchased coffee products?

SELECT 
    ci.city_name,
    COUNT(DISTINCT s.customer_id) AS unique_cx
FROM city ci
LEFT JOIN customers c
    ON c.city_id = ci.city_id
LEFT JOIN sales s
    ON s.customer_id = c.customer_id
    AND s.product_id IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14)
GROUP BY ci.city_name
ORDER BY unique_cx DESC;

-- -- Q. 8 Average Sale vs Rent
-- Find each city and their average sale per customer and avg rent per customer

SELECT 
    cr.city_name,
    cr.estimated_rent,
    ct.total_cx,
    ct.avg_sale_pr_cx,
    ROUND(cr.estimated_rent / ct.total_cx, 2) AS avg_rent_per_cx
FROM
    (SELECT 
        ci.city_name,
            SUM(s.total) AS total_revenue,
            COUNT(DISTINCT s.customer_id) AS total_cx,
            ROUND(SUM(s.total) / COUNT(DISTINCT s.customer_id), 2) AS avg_sale_pr_cx
    FROM
        sales s
    JOIN customers c ON s.customer_id = c.customer_id
    JOIN city ci ON ci.city_id = c.city_id
    GROUP BY ci.city_name) ct
        JOIN
    (SELECT 
        city_name, estimated_rent
    FROM
        city) cr ON cr.city_name = ct.city_name
ORDER BY ct.avg_sale_pr_cx DESC;

-- Q.9
-- Monthly Sales Growth
-- Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly)
-- by each city

WITH monthly_sales AS (
    SELECT 
        ci.city_name,
        MONTH(s.sale_date) AS month,
        YEAR(s.sale_date) AS year,
        SUM(s.total) AS total_sale
    FROM sales s
    JOIN customers c ON c.customer_id = s.customer_id
    JOIN city ci ON ci.city_id = c.city_id
    GROUP BY ci.city_name, year, month
),

growth_ratio AS (
    SELECT
        city_name,
        month,
        year,
        total_sale AS cr_month_sale,
        LAG(total_sale) OVER (
            PARTITION BY city_name 
            ORDER BY year, month
        ) AS last_month_sale
    FROM monthly_sales
)

SELECT
    city_name,
    month,
    year,
    cr_month_sale,
    last_month_sale,
    ROUND(
        (cr_month_sale - last_month_sale) / last_month_sale * 100,
        2
    ) AS growth_ratio
FROM growth_ratio
WHERE last_month_sale IS NOT NULL
ORDER BY city_name, year, month;

-- Q.10
-- Market Potential Analysis
-- Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer


WITH city_table AS (
    SELECT 
        ci.city_name,
        SUM(s.total) AS total_revenue,
        COUNT(DISTINCT s.customer_id) AS total_cx,
        ROUND(
            SUM(s.total) / COUNT(DISTINCT s.customer_id),
            2
        ) AS avg_sale_pr_cx
    FROM sales s
    JOIN customers c ON s.customer_id = c.customer_id
    JOIN city ci ON ci.city_id = c.city_id
    GROUP BY ci.city_name
),

city_rent AS (
    SELECT 
        city_name, 
        estimated_rent,
        ROUND((population * 0.25) / 1000000, 3) 
            AS estimated_coffee_consumer_in_millions
    FROM city
)

SELECT 
    cr.city_name,
    ct.total_revenue,
    cr.estimated_rent AS total_rent,
    ct.total_cx,
    cr.estimated_coffee_consumer_in_millions,
    ct.avg_sale_pr_cx,
    ROUND(
        cr.estimated_rent / ct.total_cx,
        2
    ) AS avg_rent_per_cx
FROM city_rent cr
JOIN city_table ct
    ON cr.city_name = ct.city_name;
    
      
