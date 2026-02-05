-- Consider the following schema for Order Database:
-- SALESMAN (Salesman_id, Name, City, Commission)
-- CUSTOMER (Customer_id, Cust_Name, City, Grade,Salesman_id)
-- ORDERS (Ord_No, Purchase_Amt, Ord_Date, Customer_id, Salesman_id)
-- Write SQL queries to:
-- 1. Count the customers with grades above Bangalore’s average.
-- 2. Find the name and numbers of all salesmen who had more than one customer.
-- 3. List all salesmen and indicate those who have and don’t have customers in their cities (Use UNION operation).
-- 4. Create a view that finds the salesman who has the customer with the highest order of a day.
-- 5. Demonstrate the DELETE operation by removing salesman with id 1000. All his orders must also be deleted.
-- 6. Create an index on (Customer(id)) to demonstrate the usage.

-- Create Database
CREATE DATABASE orders;
USE orders;

-- Create Tables

CREATE TABLE salesman (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(20),
    city VARCHAR(10),
    commission VARCHAR(3)
);

CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    cust_name VARCHAR(20),
    city VARCHAR(20),
    grade INT,
    salesman_id INT,
    FOREIGN KEY (salesman_id) REFERENCES salesman(salesman_id) ON DELETE CASCADE
);

CREATE TABLE orders (
    ord_no INT PRIMARY KEY,
    purchase_amt INT,
    ord_date DATE,
    customer_id INT,
    salesman_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (salesman_id) REFERENCES salesman(salesman_id) ON DELETE CASCADE
);

-- Insert Values

INSERT INTO salesman VALUES
(1000, 'Ravi', 'Bengaluru', '20%'),
(1001, 'Kumar', 'Bengaluru', '30%'),
(1002, 'Vivek', 'Mysuru', '10%'),
(1003, 'Chethan', 'Mangaluru', '50%'),
(1004, 'Sandeep', 'Hubli', '60%');
SELECT * FROM salesman;

INSERT INTO customer VALUES
(101, 'Keerthi', 'Bengaluru', 5, 1000),
(102, 'Kushi', 'Bengaluru', 6, 1001),
(103, 'Janvi', 'Mysuru', 6, 1002),
(104, 'Shreya', 'Mysuru', 7, 1003),
(105, 'Aditi', 'Hubli', 4, 1003);
SELECT * FROM customer;

INSERT INTO orders VALUES
(201, 2000, '2022-04-11', 101, 1000),
(202, 1000, '2022-05-12', 102, 1001),
(203, 500, '2023-10-12', 103, 1002),
(204, 1500, '2023-10-12', 104, 1003),
(205, 750, '2023-11-11', 105, 1003);
SELECT * FROM orders;

-- Queries

-- 1. 
SELECT COUNT(customer_id) AS no_of_customers
FROM customer
WHERE grade >
      (SELECT AVG(grade)
       FROM customer
       WHERE city = 'BENGALURU');

-- 2. 
SELECT s.salesman_id, s.name, COUNT(c.customer_id) AS total_customers
FROM salesman s 
JOIN customer c ON s.salesman_id = c.salesman_id
GROUP BY s.salesman_id, s.name
HAVING COUNT(c.customer_id) > 1;

-- 3. 
SELECT s.salesman_id, s.name, s.city, 'HAS CUSTOMER' AS status
FROM salesman s
WHERE s.salesman_id IN
      (SELECT salesman_id
       FROM customer
       WHERE city = s.city)
UNION
SELECT s.salesman_id, s.name, s.city, 'NO CUSTOMER' AS status
FROM salesman s
WHERE s.salesman_id NOT IN
      (SELECT salesman_id
       FROM customer
       WHERE city = s.city);

-- 4.
CREATE VIEW highest_order AS
SELECT ord_date, salesman_id, purchase_amt
FROM orders
WHERE purchase_amt IN
      (SELECT MAX(purchase_amt)
       FROM orders
       GROUP BY ord_date);

SELECT * FROM highest_order;

-- 5.
DELETE FROM salesman
WHERE salesman_id = 1000;

SELECT * FROM salesman;

-- 6.
CREATE INDEX index_customer_id
ON customer(customer_id);

SHOW INDEX FROM customer;
