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
    act_id INT PRIMARY KEY,
    act_name VARCHAR(20),
    act_gender CHAR
);

CREATE TABLE director (
    dir_id INT PRIMARY KEY,
    dir_name VARCHAR(20),
    dir_phone VARCHAR(10)
);

CREATE TABLE movies (
    mov_id INT PRIMARY KEY,
    mov_title VARCHAR(20),
    mov_year YEAR,
    mov_lang VARCHAR(10),
    dir_id INT,
    FOREIGN KEY (dir_id) REFERENCES director(dir_id) ON DELETE CASCADE
);

CREATE TABLE movie_cast (
    act_id INT,
    mov_id INT,
    role VARCHAR(10),
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
(101, 'Rahul', 'M'),
(102, 'Ankitha', 'F'),
(103, 'Radhika', 'F'),
(104, 'Chethan', 'M'),
(105, 'Vivan', 'M');
SELECT * FROM actor;

INSERT INTO director VALUES
(201, 'Chris', '918181818'),
(202, 'Hitchcock', '918181812'),
(203, 'James', '918181813'),
(204, 'Steven Spielberg', '918181814'),
(205, 'Martin', '918181815');
SELECT * FROM director;

INSERT INTO movies VALUES
(301, 'Intersteller', 2017, 'English', 201),
(302, 'Secret Agent', 2015, 'English', 204),
(303, 'Inception', 2008, 'English', 201),
(304, 'Jurassic Park', 1998, 'English', 202),
(305, 'Silence', 2012, 'English', 205);
SELECT * FROM movies;

INSERT INTO movie_cast VALUES
(101, 302, 'Hero'),
(101, 301, 'Hero'),
(103, 303, 'Heroine'),
(103, 302, 'Guest'),
(104, 304, 'Hero');
SELECT * FROM movie_cast;

INSERT INTO rating VALUES
(301, 4),
(302, 2),
(303, 5),
(304, 4),
(305, 3);
SELECT * FROM rating;

-- Queries

-- 1.
SELECT mov_title
FROM movies
WHERE dir_id = (
    SELECT dir_id
    FROM director
    WHERE dir_name = 'Hitchcock'
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
)
GROUP BY m.mov_title;

-- 3. 
SELECT a.act_id, a.act_name
FROM actor a
JOIN movie_cast mc ON a.act_id = mc.act_id
JOIN movies m ON mc.Mov_id = m.mov_id
WHERE mov_year NOT BETWEEN 2000 AND 2020
GROUP BY a.act_id, a.act_name;

-- 4.
SELECT m.mov_title, MAX(r.rev_stars) AS max_rating
FROM movies m
JOIN rating r ON m.mov_id = r.mov_id
GROUP BY mov_title
ORDER BY mov_title;

-- 5.
UPDATE rating
SET rev_stars = 5
WHERE mov_id IN (
    SELECT mov_id
    FROM director NATURAL JOIN movies
    WHERE dir_name = 'Steven Spielberg'
);

SELECT * FROM rating;
