# Create database
CREATE DATABASE walmart_sales;

# Create table
CREATE TABLE sales(
	invoice_id VARCHAR(20) NOT NULL,
	branch VARCHAR(2) NOT NULL,
	city VARCHAR(15) NOT NULL,
	customer_type VARCHAR(10) NOT NULL,
	gender VARCHAR(10) NOT NULL,
	product_line VARCHAR(40) NOT NULL,
	unit_price DECIMAL(6,2) NOT NULL,
	quantity INT NOT NULL,
	tax_pct FLOAT(6,2) NOT NULL,
	total DECIMAL(12, 2) NOT NULL,
	date DATETIME NOT NULL,
	time TIME NOT NULL,
	payment VARCHAR(10) NOT NULL,
	cogs DECIMAL(10,2) NOT NULL,
	gross_margin_pct FLOAT(4,2),
	gross_income DECIMAL(10, 2),
	rating FLOAT(2, 1)
) ENGINE = InnoDB;

# importing data into the table
# In MySQL Workbench. Via the select schemas menu > right-click tables > table data import wizard > select file > add to existing table (wal_sales.sales)
# Check the tables
SELECT 
    *
FROM
    sales;

# Added time of day column
ALTER TABLE sales
ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales 
SET 
    time_of_day =
    (CASE
        WHEN time BETWEEN '00:00:00' AND '11:00:00' THEN 'Morning'
        WHEN time BETWEEN '11:00:01' AND '17:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);
    
# Added name_of_day column
ALTER TABLE sales
ADD COLUMN name_of_day VARCHAR (20);

UPDATE sales
SET name_of_day = dayname(date);

# Added name_of_month column
ALTER TABLE sales
ADD COLUMN name_of_month VARCHAR (20);

UPDATE sales
SET name_of_month = monthname(date);

############################### Question ###############################
# What product lines are there?
SELECT DISTINCT
    product_line
FROM
    sales;

# Which products are most in demand by gender?
SELECT 
    product_line, gender, COUNT(gender) AS cnt
FROM
    sales
GROUP BY product_line , gender
ORDER BY gender , cnt DESC;

# Which product has the highest sales figures?
SELECT 
    product_line, SUM(quantity) AS total_sales_product
FROM
    sales
GROUP BY product_line
ORDER BY total_sales_product DESC;

# Which products generate the most revenue?
SELECT 
    product_line, SUM(total) AS total_revenue
FROM
    sales
GROUP BY product_line
ORDER BY total_revenue DESC;

# Which product has the largest VAT?
SELECT 
    product_line, AVG(tax_pct) AS VAT
FROM
    sales
GROUP BY product_line
ORDER BY VAT DESC;

# What month generates the most revenue?
SELECT 
    name_of_month, SUM(total) AS total_revenue
FROM
    sales
GROUP BY name_of_month
ORDER BY total_revenue DESC;

# Which city generates the most gross income?
SELECT 
    city, SUM(gross_income) AS total_gross_income
FROM
    sales
GROUP BY city
ORDER BY total_gross_income DESC;

# Which branch sells more products than the average product sales?
SELECT 
    branch, AVG(quantity) AS cnt
FROM
    sales
GROUP BY branch
ORDER BY cnt DESC;

# Which products have good and bad performance when judged based on average sales?
SELECT DISTINCT
    product_line,
    AVG(quantity) AS avg_qnty,
    CASE
        WHEN AVG(quantity) > 5.5 THEN 'Good'
        ELSE 'Bad'
    END AS 'Performance'
FROM
    sales
GROUP BY product_line
ORDER BY avg_qnty DESC;

# What payment types are available? How many?
SELECT DISTINCT
    payment, COUNT(payment)
FROM
    sales
GROUP BY payment;

# What types of customers are there?
SELECT DISTINCT
    customer_type
FROM
    sales;

# Which type of customer has the largest number?
SELECT DISTINCT
    customer_type, COUNT(customer_type) AS cnt
FROM
    sales
GROUP BY customer_type
ORDER BY cnt DESC;

# Which type of customer provides more revenue?
SELECT DISTINCT
    customer_type, SUM(total) AS total_revenue
FROM
    sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

# Based on customer type, in which city do most customers come from?
SELECT 
    customer_type, city, COUNT(customer_type) AS cnt
FROM
    sales
GROUP BY customer_type , city
ORDER BY customer_type , cnt DESC;

# What time of day generates the most revenue?
SELECT 
    time_of_day, SUM(total) AS total_revenue
FROM
    sales
GROUP BY time_of_day
ORDER BY total_revenue DESC;

# Which days generate the most revenue?
SELECT 
    name_of_day, SUM(total) AS total_revenue
FROM
    sales
GROUP BY name_of_day
ORDER BY total_revenue DESC;

# What is the average rating in one week?
SELECT 
    AVG(rating) AS avg_rating
FROM
    sales;

# On what days do customers give the best ratings on average?
SELECT 
    name_of_day, AVG(rating) AS avg_rating
FROM
    sales
GROUP BY name_of_day
ORDER BY avg_rating DESC;

# What is the gender of most existing customers?
SELECT 
    customer_type, gender, COUNT(customer_type) AS cnt
FROM
    sales
GROUP BY gender , customer_type
ORDER BY cnt DESC;

# What payment method do customers usually make transactions with?
SELECT 
    customer_type, payment, COUNT(payment) AS cnt
FROM
    sales
GROUP BY customer_type , payment
ORDER BY cnt DESC;

# From which branch do most sales occur?
SELECT 
    branch, COUNT(quantity) AS cnt
FROM
    sales
GROUP BY branch
ORDER BY cnt DESC;

# What is the best-selling product from each branch?
SELECT DISTINCT
    branch, product_line, COUNT(quantity) AS cnt
FROM
    sales
GROUP BY branch , product_line
ORDER BY branch , cnt DESC;

# What is the average revenue of each branch each week?
SELECT DISTINCT
    branch, name_of_day, AVG(total) AS avg_revenue
FROM
    sales
GROUP BY branch , name_of_day
ORDER BY branch , avg_revenue DESC;