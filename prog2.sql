-- Consider the following schema for Order Database:
-- SALESMAN (Salesman_id, Name, City, Commission)
-- CUSTOMER (Customer_id, Cust_Name, City, Grade,Salesman_id)
-- ORDERS (Ord_No, Purchase_Amt, Ord_Date, Customer_id, Salesman_id)
-- Write SQL queries to:
-- 1. Count the customers with grades above Bangalor’s average.
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
    city VARCHAR(20),
    commission VARCHAR(20)
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
(1000, 'A', 'BENGALURU', '20%'),
(1001, 'B', 'BENGALURU', '30%'),
(1002, 'C', 'MYSURU', '10%'),
(1003, 'D', 'MANGALURU', '50%'),
(1004, 'E', 'HUBLI', '60%');
SELECT * FROM salesman;

INSERT INTO customer VALUES
(100, 'AB', 'BENGALURU', 5, 1000),
(101, 'BC', 'BENGALURU', 6, 1001),
(102, 'CD', 'MYSURU', 6, 1002),
(103, 'DE', 'MYSURU', 7, 1003),
(104, 'EF', 'HUBLI', 4, 1003);
SELECT * FROM customer;

INSERT INTO orders VALUES
(1, 2000, '2022-04-11', 100, 1000),
(2, 1000, '2022-05-12', 101, 1001),
(3, 500, '2023-10-12', 102, 1002),
(4, 1500, '2023-10-12', 103, 1003),
(5, 750, '2023-11-11', 104, 1003);
SELECT * FROM orders;

-- Queries

-- 1. 
SELECT COUNT(customer_id)
FROM customer
WHERE grade >
      (SELECT AVG(grade)
       FROM customer
       WHERE city = 'BENGALURU');

-- 2. 
SELECT s.salesman_id, s.name, COUNT(c.customer_id)
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
