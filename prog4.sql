-- Consider the schema for College Database:
-- STUDENT (USN, SName, Address, Phone, Gender)
-- SEMSEC (SSID, Sem, Sec)
-- CLASS (USN, SSID)
-- SUBJECT (Subcode, Title, Sem, Credits)
-- IAMARKS (USN, Subcode, SSID, Test1, Test2, Test3, FinalIA)
-- Write SQL queries to
-- 1. List all the student details studying in fifth semester ‘B’ section.
-- 2. Compute the total number of male and female students in each semester and in each section.
-- 3. Create a view of Event 1 marks of student USN ‘01JST IS ’ in all subjects.
-- 4. Calculate the Final IA (average of best two test marks) and update the corresponding table for all students.
-- 5. Categorize students based on the following criterion:
--    If Final IA = 17 to 20 then CAT =‘Outstanding’
--    If Final IA = 12 to 16 then CAT = ‘Average’
--    If Final IA< 12 then CAT = ‘Weak’
--    Give these details only for 8th semester A, B, and C section students.

-- Create Database
CREATE DATABASE college;
USE college;

-- Create Tables

CREATE TABLE student (
    usn VARCHAR(20) PRIMARY KEY,
    sname VARCHAR(20),
    address VARCHAR(40),
    phone VARCHAR(10),
    gender CHAR
);

CREATE TABLE semsec (
    ssid VARCHAR(20) PRIMARY KEY,
    sem INT,
    sec CHAR
);

CREATE TABLE class (
    usn VARCHAR(20),
    ssid VARCHAR(20),
    FOREIGN KEY (usn) REFERENCES student(usn) ON DELETE CASCADE,
    FOREIGN KEY (ssid) REFERENCES semsec(ssid) ON DELETE CASCADE
);

CREATE TABLE subject (
    subcode VARCHAR(10) PRIMARY KEY,
    title VARCHAR(10),
    sem INT,
    credits INT
);

CREATE TABLE iamarks (
    usn VARCHAR(20),
    subcode VARCHAR(10),
    ssid VARCHAR(20),
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
('01JST21IS001', 'ABHIBHAVA', 'BELGAM', '1111111111', 'M'),
('01JST21IS002', 'ABHILASH', 'MYSURU', '2222222222', 'M'),
('01JST21IS003', 'ADITHYA', 'BENGALURU', '4545454545', 'M'),
('01JST21CS001', 'AJITH', 'DAVANGERE', '5656565656', 'M'),
('01JST21EC001', 'RAGHAV', 'KOPPAL', '9898989898', 'M'),
('01JST21IS005', 'SHRUTI', 'HUBLI', '6565676767', 'F');
SELECT * FROM student;

INSERT INTO semsec VALUES
('5B', 5, 'B'),
('3A', 3, 'A'),
('8B', 8, 'B'),
('2A', 2, 'A'),
('1D', 1, 'D'),
('5A', 5, 'A');
SELECT * FROM semsec;

INSERT INTO class VALUES
('01JST21IS001', '5B'),
('01JST21IS002', '5B'),
('01JST21IS003', '5A'),
('01JST21CS001', '1D'),
('01JST21EC001', '8B'),
('01JST21IS005', '5B');
SELECT * FROM class;

INSERT INTO subject VALUES
('15IS411', 'DBMS', 5, 4),
('15IS34', 'CN', 5, 4),
('15IS456', 'SSC', 3, 4),
('15IS23', 'JAVA', 8, 3),
('15IS89', 'ML', 1, 1.5);
SELECT * FROM subject;

INSERT INTO iamarks VALUES
('01JST21IS001', '15IS411', '5B', 19, 19, 19, 19),
('01JST21IS002', '15IS34', '5B', 18, 18, 17, 18),
('01JST21IS002', '15IS411', '5B', 16, 15, 17, 15),
('01JST21EC001', '15IS23', '8B', 13, 11, 9, 10);
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
CREATE VIEW student_test1_marks_view AS
SELECT test1, subcode
FROM iamarks
WHERE usn = '01JST21IS002';

SELECT * FROM student_test1_marks_view;


-- 4.
UPDATE iamarks i
SET i.finalia = (i.test1 + i.test2 + i.test3 - LEAST(i.test1, i.test2, i.test3)) / 2;

SELECT * FROM iamarks;


-- 5.
SELECT s.usn, s.sname, s.gender, ss.sem, ss.sec,
    CASE
        WHEN i.finalia BETWEEN 17 AND 20 THEN 'Outstanding'
        WHEN i.finalia BETWEEN 12 AND 16 THEN 'Average'
        WHEN i.finalia < 12 THEN 'Weak'
    END AS cat
FROM student s
JOIN class c ON s.usn = c.usn
JOIN semsec ss ON c.ssid = ss.ssid
JOIN iamarks i ON s.usn = i.usn AND ss.ssid = i.ssid
WHERE ss.sem = 8 AND ss.sec IN ('A', 'B', 'C');
