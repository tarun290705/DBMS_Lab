-- Consider the schema for College Database:
-- STUDENT (USN, SName, Address, Phone, Gender)
-- SEMSEC (SSID, Sem, Sec)
-- CLASS (USN, SSID)
-- SUBJECT (Subcode, Title, Sem, Credits)
-- IAMARKS (USN, Subcode, SSID, Test1, Test2, Test3, FinalIA)
-- Write SQL queries to
-- 1. List all the student details studying in fifth semester ‘B’ section.
-- 2. Compute the total number of male and female students in each semester and in each section.
-- 3. Create a view of Event 1 marks of student USN ‘01JST_IS_’ in all subjects.
-- 4. Calculate the Final IA (average of best two test marks) and update the corresponding table for all students.
-- 5. Categorize students based on the following criterion:
--    If Final IA = 17 to 20 then CAT = ‘Outstanding’
--    If Final IA = 12 to 16 then CAT = ‘Average’
--    If Final IA < 12 then CAT = ‘Weak’
--    Give these details only for 8th semester A, B, and C section students.

-- Create Database
CREATE DATABASE college;
USE college;

-- Create Tables

CREATE TABLE student (
    usn VARCHAR(13) PRIMARY KEY,
    sname VARCHAR(20),
    address VARCHAR(10),
    phone VARCHAR(10),
    gender CHAR
);

CREATE TABLE semsec (
    ssid VARCHAR(2) PRIMARY KEY,
    sem INT,
    sec CHAR
);

CREATE TABLE class (
    usn VARCHAR(13),
    ssid VARCHAR(2),
    FOREIGN KEY (usn) REFERENCES student(usn) ON DELETE CASCADE,
    FOREIGN KEY (ssid) REFERENCES semsec(ssid) ON DELETE CASCADE
);

CREATE TABLE subject (
    subcode VARCHAR(5) PRIMARY KEY,
    title VARCHAR(10),
    sem INT,
    credits INT
);

CREATE TABLE iamarks (
    usn VARCHAR(13),
    subcode VARCHAR(5),
    ssid VARCHAR(2),
    test1 INT,
    test2 INT,
    test3 INT,
    finalia INT,
    FOREIGN KEY (usn) REFERENCES student(usn) ON DELETE CASCADE,
    FOREIGN KEY (ssid) REFERENCES semsec(ssid) ON DELETE CASCADE,
    FOREIGN KEY (subcode) REFERENCES subject(subcode) ON DELETE CASCADE
);

-- Insert Values

INSERT INTO student VALUES
('01JST23UIS001', 'Abhibhava', 'Belgam', '9876543210', 'M'),
('01JST23UIS002', 'Abhilash', 'Mysuru', '8967452301', 'M'),
('01JST23UIS003', 'Adithya', 'Bengaluru', '8310292822', 'M'),
('01JST23UIS004', 'Ajith', 'Mysuru', '7353228021', 'M'),
('01JST23UIS005', 'Raghav', 'Bengaluru', '9866545493', 'M'),
('01JST23UIS006', 'Shruthi', 'Hubli', '9978321260', 'F');
SELECT * FROM student;

INSERT INTO semsec VALUES
('1B', 1, 'B'),
('2A', 2, 'A'),
('5A', 5, 'A');
('5B', 5, 'B'),
('8B', 8, 'B'),
SELECT * FROM semsec;

INSERT INTO class VALUES
('01JST23UIS001', '1B'),
('01JST23UIS002', '2A'),
('01JST23UIS003', '5A'),
('01JST23UIS004', '5B'),
('01JST23UIS005', '5B'),
('01JST23UIS006', '8B');
SELECT * FROM class;

INSERT INTO subject VALUES
('IS101', 'JAVA', 1, 4),
('IS202', 'DSA', 2, 4),
('IS504', 'DBMS', 5, 4),
('IS506', 'ML', 5, 3),
('IS803', 'SSC', 8, 4);
SELECT * FROM subject;

INSERT INTO iamarks VALUES
('01JST23UIS001', 'IS101', '1B', 19, 19, 19, 19),
('01JST23UIS002', 'IS504', '5B', 18, 18, 17, 18),
('01JST23UIS002', 'IS506', '5B', 16, 15, 17, 15),
('01JST23UIS006', 'IS803', '8B', 13, 11, 9, 10);
SELECT * FROM iamarks;

-- Queries

-- 1.
SELECT s.*, ss.sem, ss.sec
FROM student s
JOIN class c ON s.usn = c.usn
JOIN semsec ss ON c.ssid = ss.ssid
WHERE ss.sem = 5 AND ss.sec = 'B';

-- 2.
SELECT ss.sem, ss.sec, s.gender, count(s.gender) AS total_students
FROM semsec ss
JOIN class c ON ss.ssid = c.ssid
JOIN student s ON c.usn = s.usn
GROUP BY ss.sem, ss.sec, s.gender
ORDER BY ss.sem;

-- 3.
CREATE VIEW test1_marks AS
SELECT usn, test1, subcode
FROM iamarks;

SELECT * FROM test1_marks;


-- 4.
UPDATE iamarks
SET finalia = (test1 + test2 + test3 - LEAST(test1, test2, test3)) / 2;

SELECT * FROM iamarks;

-- 5.
SELECT s.usn, s.sname, ss.sem, ss.sec,
    CASE
        WHEN i.finalia BETWEEN 17 AND 20 THEN 'Outstanding'
        WHEN i.finalia BETWEEN 12 AND 16 THEN 'Average'
        WHEN i.finalia < 12 THEN 'Weak'
    END AS category
FROM student s
JOIN class c ON s.usn = c.usn
JOIN semsec ss ON c.ssid = ss.ssid
JOIN iamarks i ON s.usn = i.usn AND ss.ssid = i.ssid
WHERE ss.sem = 8 AND ss.sec IN ('A', 'B', 'C');
