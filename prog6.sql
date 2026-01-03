-- Consider the schema of the call detail table to partitioned primary index:
-- CREATE TABLE calldetail (
--    phone_number DECIMAL(10) NOT NULL,
--    call_start TIMESTAMP,
--    call_duration INTEGER,
--    call_description VARCHAR(30),
--    PRIMARY INDEX (phone_number, call_start);
-- Demonstrate the query against this table be optimized by partitioning its primary index using partitioning techniques.

-- Create Database
CREATE DATABASE call;
USE call;

-- Create Table
CREATE TABLE call_detail (
    phone_number BIGINT NOT NULL,
    call_start TIMESTAMP,
    call_duration INT,
    call_description VARCHAR(30),
    PRIMARY KEY (phone_number, call_start)
)
PARTITION BY RANGE (UNIX_TIMESTAMP(call_start)) (
    PARTITION p0 VALUES LESS THAN (UNIX_TIMESTAMP('2025-01-22 00:00:00')),
    PARTITION p1 VALUES LESS THAN (UNIX_TIMESTAMP('2025-01-23 00:00:00'))
);

CREATE INDEX idx
ON call_detail (phone_number, call_start);

SHOW INDEX FROM call_detail;

-- Insert Values
INSERT INTO call_detail VALUES
(122434231, '2025-01-20 00:00:00', 50, 'FDF'),
(122343243, '2025-01-22 10:00:00', 40, 'FFR'),
(122434230, '2025-01-11 00:00:00', 50, 'FDF'),
(122343242, '2025-01-10 10:00:00', 40, 'FFR'),
(123232323, '2025-01-11 10:00:00', 30, 'EED');

SELECT * FROM call_detail;

SELECT * FROM call_detail PARTITION (p0);

SELECT * FROM call_detail PARTITION (p1);
