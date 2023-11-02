-- TASK 01
CREATE DATABASE week12;

USE week12;

-- TASK 02
CREATE TABLE student(
	name CHAR(50) PRIMARY KEY,
    IQ INT,
    gender CHAR(1)
);

CREATE TABLE speak(
	name CHAR(50),
    language CHAR(50),
    PRIMARY KEY (name, language)
);

-- TASK 03
LOAD DATA LOCAL INFILE "/Users/dipanshugoyal8107/Downloads/Week12/student.csv" INTO TABLE student
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/Users/dipanshugoyal8107/Downloads/Week12/speaks.csv" INTO TABLE speak
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

-- TASK 04A
SELECT language
FROM speak
GROUP BY language
HAVING COUNT(name) = (SELECT MIN(cnt) FROM (SELECT language, COUNT(name) as cnt FROM speak GROUP BY language) X);

/*
+----------+
| language |
+----------+
| French   |
| Korean   |
+----------+
2 rows in set (0.00 sec)
*/

-- TASK 04B
SELECT language FROM (
SELECT language, RANK() OVER(ORDER BY COUNT(name)) r FROM speak GROUP BY language) X
WHERE X.r = 1;

/*
+----------+
| language |
+----------+
| French   |
| Korean   |
+----------+
2 rows in set (0.00 sec)
*/

-- TASK 05A
SELECT name
FROM speak
GROUP BY name
HAVING COUNT(language) = (SELECT MAX(cnt) FROM (SELECT name, COUNT(language) as cnt FROM speak GROUP BY name) X);

/*
+----------+
| name     |
+----------+
| Atul     |
| Bhaskar  |
| Dasgupta |
+----------+
3 rows in set (0.00 sec)
*/

-- TASK 05B
SELECT name FROM (
SELECT name, RANK() OVER(ORDER BY COUNT(language) DESC) r FROM speak GROUP BY name) X
WHERE X.r = 1;

/*
+----------+
| name     |
+----------+
| Atul     |
| Bhaskar  |
| Dasgupta |
+----------+
3 rows in set (0.00 sec)
*/

-- TASK 06A
SELECT gender 
FROM student
GROUP BY gender
HAVING AVG(IQ) = (SELECT MAX(av_iq) FROM (SELECT gender, AVG(IQ) AS av_iq FROM student GROUP BY gender) X);

/*
+--------+
| gender |
+--------+
| M      |
+--------+
1 row in set (0.00 sec)
*/

-- TASK 06B
SELECT gender FROM (
SELECT gender, RANK() OVER(ORDER BY AVG(IQ) DESC) iq_rank FROM student GROUP BY gender) X
WHERE X.iq_rank = 1;

/*
+--------+
| gender |
+--------+
| M      |
+--------+
1 row in set (0.00 sec)
*/

SELECT gender FROM (
SELECT gender, DENSE_RANK() OVER(ORDER BY AVG(IQ) DESC) iq_rank FROM student GROUP BY gender) X
WHERE X.iq_rank = 1;

/*
+--------+
| gender |
+--------+
| M      |
+--------+
1 row in set (0.00 sec)
*/

-- TASK 07
SELECT name FROM (
SELECT name, language, DENSE_RANK() OVER(ORDER BY IQ DESC) iq_rank FROM student NATURAL JOIN speak WHERE language = "Japanese") X
WHERE X.iq_rank<3;

/*
+----------+
| name     |
+----------+
| Bhaskar  |
| Dasgupta |
+----------+
2 rows in set (0.00 sec)
*/

-- TASK 08
SELECT name, gender FROM (
SELECT name, gender, RANK() OVER(PARTITION BY gender ORDER BY IQ DESC) iq_rank FROM student) X
WHERE X.iq_rank = 1;

/*
+---------+--------+
| name    | gender |
+---------+--------+
| Madhuri | F      |
| Bhaskar | M      |
+---------+--------+
2 rows in set (0.00 sec)
*/