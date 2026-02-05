-- Consider the following schema for a Library Database:
-- BOOK (Book_id, Title, Publisher_Name, Pub_Year)
-- BOOK_AUTHORS (Book_id, Author_Name)
-- PUBLISHER (Name, Address, Phone)
-- BOOK_COPIES (Book_id, Branch_id, No_of_Copies)
-- BOOK_LENDING (Book_id, Branch_id, Card_No, Date_Out, Due_Date)
-- LIBRARY_BRANCH (Branch_id, Branch_Name, Address)
-- Write SQL queries to:
-- 1. Retrieve the details of all books in the library – id, title, name of publisher, authors, number of copies in each branch, etc.
-- 2. Get the particular borrowers who have borrowed more than 3 books from Jan 2020 to Jun 2022.
-- 3. Delete a book in BOOK table and Update the contents of other tables using DML statements.
-- 4. Create the view for BOOK table based on year of publication and demonstrate its working with a simple query.
-- 5. Create a view of all books and its number of copies which are currently available in the Library.
-- 6. Demonstrate the usage of view creation

-- Create Database
CREATE DATABASE library;
USE library;

-- Create Tables

CREATE TABLE publisher (
    name VARCHAR(20) PRIMARY KEY,
    address VARCHAR(20),
    phone VARCHAR(10)
);

CREATE TABLE book (
    book_id INT PRIMARY KEY,
    title VARCHAR(10),
    publisher_name VARCHAR(20),
    pub_year YEAR,
    FOREIGN KEY (publisher_name) REFERENCES publisher(name) ON DELETE CASCADE
);

CREATE TABLE book_authors (
    book_id INT,
    author_name VARCHAR(10),
    FOREIGN KEY (book_id) REFERENCES book(book_id) ON DELETE CASCADE
);

CREATE TABLE library_branch (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(20),
    address VARCHAR(20)
);

CREATE TABLE book_copies (
    book_id INT,
    branch_id INT,
    no_of_copies INT,
    FOREIGN KEY (book_id) REFERENCES book(book_id) ON DELETE CASCADE,
    FOREIGN KEY (branch_id) REFERENCES library_branch(branch_id) ON DELETE CASCADE
);

CREATE TABLE book_lending (
    book_id INT,
    branch_id INT,
    card_no INT,
    date_out DATE,
    due_date DATE,
    FOREIGN KEY (book_id) REFERENCES book(book_id) ON DELETE CASCADE,
    FOREIGN KEY (branch_id) REFERENCES library_branch(branch_id) ON DELETE CASCADE
);

-- Insert Values

INSERT INTO publisher VALUES
('Rahul', 'Bengaluru', '9879879879'),
('Rohan', 'Bengaluru', '8798798791'),
('Rishi', 'Mysuru', '7897897892');
SELECT * FROM publisher;

INSERT INTO book VALUES
(101, 'DSA', 'Rahul', 1998),
(102, 'ADA', 'Rahul', 2000),
(103, 'DBMS', 'Rohan', 2005),
(104, 'SE', 'Rishi', 2005);
SELECT * FROM book;

INSERT INTO book_authors VALUES
(101, 'Neha'),
(102, 'Adya'),
(103, 'Abhilash'),
(104, 'Harsh');
SELECT * FROM book_authors;

INSERT INTO library_branch VALUES
(201, 'LIB1', 'MYSURU'),
(202, 'LIB2', 'MYSURU'),
(203, 'LIB3', 'BENGALURU'),
(204, 'LIB4', 'MANGALURU');
SELECT * FROM library_branch;

INSERT INTO book_copies VALUES
(101, 201, 10),
(101, 202, 20),
(102, 202, 30),
(103, 203, 40),
(104, 204, 25),
(104, 103, 15);
SELECT * FROM book_copies;

INSERT INTO book_lending VALUES
(101, 201, 1010, '2020-01-02', '2020-02-01'),
(102, 202, 1010, '2020-03-01', '2020-04-01'),
(103, 203, 1010, '2021-02-02', '2021-03-02'),
(104, 204, 1010, '2022-01-02', '2022-02-01'),
(101, 202, 1012, '2020-01-02', '2020-02-01');
SELECT * FROM book_lending;

-- Queries

-- 1.
SELECT b.book_id, b.title, b.publisher_name, ba.author_name, bc.branch_id, bc.no_of_copies
FROM book b
JOIN book_authors ba ON b.book_id = ba.book_id
JOIN book_copies bc ON b.book_id = bc.book_id;

-- 2. 
SELECT card_no
FROM book_lending
WHERE date_out BETWEEN '2020-01-01' AND '2022-06-30'
GROUP BY card_no
HAVING COUNT(*) > 3;

-- 3. 
DELETE FROM book
WHERE book_id = 101;
SELECT * FROM book;

UPDATE book_authors
SET author_name = 'Samarth'
WHERE book_id = 102;
SELECT * FROM book_authors;

-- 4. 
CREATE VIEW publication_year AS
SELECT book_id, title, publisher_name, pub_year
FROM book
ORDER BY pub_year;

SELECT * FROM publication_year;

-- 5. 
CREATE VIEW available_books AS
SELECT b.book_id, b.title, bc.branch_id, bc.no_of_copies
FROM book b
JOIN book_copies bc ON b.book_id = bc.book_id;

SELECT * FROM available_books;

-- 6.
CREATE VIEW branch_details AS
SELECT branch_id, branch_name, address
FROM library_branch
WHERE address = 'Mysuru';

SELECT * FROM branch_details;
