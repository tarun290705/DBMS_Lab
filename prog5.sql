-- Consider the schema for Company Database:
-- EMPLOYEE (SSN, Name, Address, Sex, Salary, SuperSSN, DNo)
-- DEPARTMENT (DNo, DName, MgrSSN, MgrStartDate)
-- DLOCATION (DNo,DLoc)
-- PROJECT (PNo, PName, PLocation, DNo)
-- WORKS_ON (SSN, PNo, Hours)
-- Write SQL queries to
-- 1. Make a list of all project numbers for projects that involve an employee whose last name is ‘Scott’, either as a worker or as a manager of the department that controls the project.
-- 2. Show the resulting salaries if every employee working on the ‘IoT’ project is given a 10 percent raise.
-- 3. Find the sum of the salaries of all employees of the ‘Accounts’ department, as well as the maximum salary, the minimum salary, and the average salary in this department
-- 4. Retrieve the name of each employee who works on all the projects controlled by department number.(use NOT EXISTS operator). 
-- 5. For each department that has more than five employees, retrieve the department number and the number of its employees who are making more than Rs.6, 00,000.

-- Create Database
CREATE DATABASE company;
USE company;

-- Create Tables

CREATE TABLE department (
    dno VARCHAR(20) PRIMARY KEY,
    dname VARCHAR(20),
    mgrssn VARCHAR(20),
    mgrstartdate DATE
);


CREATE TABLE employee (
    ssn VARCHAR(20) PRIMARY KEY,
    name VARCHAR(20),
    address VARCHAR(30),
    sex CHAR(1),
    salary INT,
    superssn VARCHAR(20),
    dno VARCHAR(20),
    FOREIGN KEY (superssn) REFERENCES employee(ssn),
    FOREIGN KEY (dno) REFERENCES department(dno)
);

ALTER TABLE department
ADD FOREIGN KEY (mgrssn) REFERENCES employee(ssn);

CREATE TABLE dlocation (
    dno VARCHAR(20),
    dloc VARCHAR(20),
    FOREIGN KEY (dno) REFERENCES department(dno)
);

CREATE TABLE project (
    pno INT PRIMARY KEY,
    pname VARCHAR(20),
    plocation VARCHAR(20),
    dno VARCHAR(20),
    FOREIGN KEY (dno) REFERENCES department(dno)
);

CREATE TABLE works_on (
    ssn VARCHAR(20),
    pno INT,
    hours INT,
    FOREIGN KEY (ssn) REFERENCES employee(ssn),
    FOREIGN KEY (pno) REFERENCES project(pno)
);

-- Insert Values

INSERT INTO employee (ssn, name, address, sex, salary) VALUES
('ABC01','Ben Scott','Bengaluru','M',450000),
('ABC02','Harry Smith','Bengaluru','M',500000),
('ABC03','Lean Baker','Bengaluru','M',700000),
('ABC04','Martin scott','Mysuru','M',500000),
('ABC05','Ravan Hegde','Manglore','M',650000),
('ABC06','Girish Hosur','Mysuru','M',450000),
('ABC07','Neela Sharma','Bengaluru','F',800000),
('ABC08','Adya Kolar','Manglore','F',350000),
('ABC09','Prasanna Kumar','Manglore','M',300000),
('ABC10','Veena Kumari','Mysuru','F',600000),
('ABC11','Deepak Raj','Bengaluru','M',500000);

INSERT INTO department VALUES
('1','Accounts','ABC09','2016-01-03'),
('2','IT','ABC11','2017-02-04'),
('3','HR','ABC01','2016-04-05'),
('4','Helpdesk','ABC10','2017-06-03'),
('5','Sales','ABC06','2017-01-08');
SELECT * FROM department;

-- Update employee table
UPDATE employee SET superssn = NULL, dno = '3' WHERE ssn = 'ABC01';
UPDATE employee SET superssn = 'ABC03', dno = '5' WHERE ssn = 'ABC02';
UPDATE employee SET superssn = 'ABC04', dno = '5' WHERE ssn = 'ABC03';
UPDATE employee SET superssn = 'ABC06', dno = '5' WHERE ssn = 'ABC04';
UPDATE employee SET superssn = 'ABC06', dno = '5' WHERE ssn = 'ABC05';
UPDATE employee SET superssn = 'ABC07', dno = '5' WHERE ssn = 'ABC06';
UPDATE employee SET superssn = NULL, dno = '5' WHERE ssn = 'ABC07';
UPDATE employee SET superssn = 'ABC09', dno = '1' WHERE ssn = 'ABC08';
UPDATE employee SET superssn = NULL, dno = '1' WHERE ssn = 'ABC09';
UPDATE employee SET superssn = NULL, dno = '4' WHERE ssn = 'ABC10';
UPDATE employee SET superssn = NULL, dno = '2' WHERE ssn = 'ABC11';

SELECT * FROM employee;

INSERT INTO dlocation VALUES
('1','Bengaluru'),
('2','Bengaluru'),
('3','Bengaluru'),
('4','Mysuru'),
('5','Mysuru');
SELECT * FROM dlocation;

INSERT INTO project VALUES
(1000,'IoT','Bengaluru','5'),
(1001,'Cloud','Bengaluru','5'),
(1002,'Bigdata','Bengaluru','5'),
(1003,'Sensors','Bengaluru','3'),
(1004,'Bank Management','Bengaluru','1'),
(1005,'Salary Management','Bengaluru','1'),
(1006,'Openstack','Bengaluru','4'),
(1007,'Smart City','Bengaluru','2');
SELECT * FROM project;

INSERT INTO works_on VALUES
('ABC02',1000,4),
('ABC02',1001,6),
('ABC02',1002,8),
('ABC03',1000,10),
('ABC05',1000,3),
('ABC06',1001,4),
('ABC07',1002,5),
('ABC04',1002,6),
('ABC01',1003,7),
('ABC08',1004,5),
('ABC09',1005,6),
('ABC10',1006,4),
('ABC11',1007,10);
SELECT * FROM works_on;

-- Queries

-- 1.
SELECT DISTINCT p.pno
FROM project p, department d, employee e
WHERE p.dno = d.dno
AND d.mgrssn = e.ssn
AND e.name LIKE '%scott'

UNION

SELECT DISTINCT p1.pno
FROM project p1, works_on w, employee e1
WHERE p1.pno = w.pno
AND e1.ssn = w.ssn
AND e1.name LIKE '%scott';

-- 2. 
SELECT e.name, 1.1 * e.salary AS incr_sal
FROM employee e, works_on w, project p
WHERE e.ssn = w.ssn
AND w.pno = p.pno
AND p.pname = 'iot';

-- 3.
SELECT SUM(e.salary), MAX(e.salary), MIN(e.salary), AVG(e.salary)
FROM employee e, department d
WHERE e.dno = d.dno
AND d.dname = 'accounts';

-- 4.
SELECT e.name
FROM employee e
WHERE NOT EXISTS (
    SELECT pno
    FROM project
    WHERE dno = '5'
    AND pno NOT IN (
        SELECT pno
        FROM works_on
        WHERE e.ssn = ssn
    )
);

-- 5.
SELECT d.dno, COUNT(*)
FROM department d, employee e
WHERE d.dno = e.dno
AND e.salary > 600000
AND d.dno IN (
    SELECT e1.dno
    FROM employee e1
    GROUP BY e1.dno
    HAVING COUNT(*) > 5
)
GROUP BY d.dno;
