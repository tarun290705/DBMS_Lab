-- Consider the schema for Movie Database:
-- ACTOR (Act_id, Act_Name, Act_Gender)
-- DIRECTOR (Dir_id, Dir_Name, Dir_Phone)
-- MOVIES (Mov_id, Mov_Title, Mov_Year, Mov_Lang, Dir_id)
-- MOVIE_CAST (Act_id, Mov_id, Role)
-- RATING (Mov_id, Rev_Stars)
-- Write SQL queries to
-- 1. List the titles of all movies directed by ‘Hitchcock’.
-- 2. Find the movie names where one or more actors acted in two or more movies.
-- 3. List all actors who acted in a movie before 2000 and also in a movie after 2020 (use JOIN operation).
-- 4. Find the title of movies and number of stars for each movie that has at least one rating and find the highest number of stars that movie received. Sort the result by movie title.
-- 5. Update rating of all movies directed by ‘Steven Spielberg’ to 5.

-- Crate Database
CREATE DATABASE movie;
USE movie;

-- Create Tables

CREATE TABLE actor (
    act_id INT NOT NULL PRIMARY KEY,
    act_name VARCHAR(20),
    act_gender CHAR(1)
);

CREATE TABLE director (
    dir_id INT NOT NULL PRIMARY KEY,
    dir_name VARCHAR(20),
    dir_phone VARCHAR(20)
);

CREATE TABLE movies (
    mov_id INT NOT NULL PRIMARY KEY,
    mov_title VARCHAR(20),
    mov_year YEAR,
    mov_lang VARCHAR(20),
    FOREIGN KEY INT REFERENCES director(dir_id) ON DELETE CASCADE
);

CREATE TABLE movie_cast (
    act_id INT,
    mov_id INT,
    role VARCHAR(20),
    FOREIGN KEY (act_id) REFERENCES actor(act_id) ON DELETE CASCADE,
    FOREIGN KEY (mov_id) REFERENCES movies(mov_id) ON DELETE CASCADE
);

CREATE TABLE rating (
    mov_id INT,
    rev_stars INT,
    FOREIGN KEY (mov_id) REFERENCES movies(mov_id) ON DELETE CASCADE
);

-- Insert Values

INSERT INTO actor VALUES
(101, 'RAHUL', 'M'),
(102, 'ANKITHA', 'F'),
(103, 'RADHIKA', 'F'),
(104, 'CHETHAN', 'M'),
(105, 'VIVAN', 'M');
SELECT * FROM actor;

INSERT INTO director VALUES
(201, 'CHRISTOPHER NOLAN', '918181818'),
(202, 'HITCHCOCK', '918181812'),
(203, 'JAMES CAMERON', '918181813'),
(204, 'STEVEN SPIELBERG', '918181814'),
(205, 'MARTIN SEORSESE', '918181815');
SELECT * FROM director;

INSERT INTO movies VALUES
(1001, 'INTERSTELLAR', 2017, 'ENGLISH', 201),
(1002, 'SECRET AGENT', 2015, 'ENGLISH', 204),
(1003, 'INCEPTION', 2008, 'ENGLISH', 201),
(1004, 'JURASSIC PARK', 1998, 'ENGLISH', 202),
(1005, 'SILENCE', 2012, 'ENGLISH', 205);
SELECT * FROM movies;

INSERT INTO movie_cast VALUES
(101, 1002, 'HERO'),
(101, 1001, 'HERO'),
(103, 1003, 'HEROINE'),
(103, 1002, 'GUEST'),
(104, 1004, 'HERO');
SELECT * FROM movie_cast;

INSERT INTO rating VALUES
(1001, 4),
(1002, 2),
(1003, 5),
(1004, 4),
(1005, 3);
SELECT * FROM rating;

-- Queries

-- 1.
SELECT mov_title
FROM movies
WHERE dir_id = (
    SELECT dir_id
    FROM director
    WHERE dir_name = 'HITCHCOCK'
);

-- 2. 
SELECT m.mov_title
FROM movies m
JOIN movie_cast mc ON m.mov_id = mc.mov_id
WHERE mc.act_id IN (
    SELECT act_id
    FROM movie_cast
    GROUP BY act_id
    HAVING COUNT(mov_id) >= 2
);

-- 3. 
SELECT DISTINCT a.act_name
FROM actor 
JOIN movie_cast mc ON a.act_id = mc.act_id
JOIN movies m ON mc.Mov_id = m.mov_id
WHERE mov_year NOT BETWEEN 2000 AND 2020;

-- 4.
SELECT mov_title, MAX(rev_stars)
FROM movies NATURAL JOIN rating
GROUP BY mov_title
ORDER BY mov_title;

-- 5.
UPDATE rating
SET rev_stars = 5
WHERE mov_id IN (
    SELECT mov_id
    FROM director NATURAL JOIN movies
    WHERE dir_name = 'STEVEN SPIELBERG'
);

SELECT * FROM rating
ORDER BY mov_id;
