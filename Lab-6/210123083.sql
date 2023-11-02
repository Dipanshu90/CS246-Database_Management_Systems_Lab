-- Task - 01

CREATE DATABASE week06;

USE week06;

-- Task - 02

CREATE TABLE student(
	cid CHAR(7),
    roll_number CHAR(10),
    name CHAR(100) NOT NULL,
    approval_status CHAR(20),
    credit_status CHAR(10),
    PRIMARY KEY (roll_number, cid),
    CHECK(credit_status in ('Credit','Audit')),
    CHECK(approval_status in ('Approved','Pending'))
);

CREATE TABLE course (
	cid CHAR(7) PRIMARY KEY,
    name CHAR(100) NOT NULL
);

CREATE TABLE credit (
	cid CHAR(7) PRIMARY KEY,
    l INT NOT NULL,
    t INT NOT NULL,
    p INT NOT NULL,
    c FLOAT NOT NULL
);

CREATE TABLE faculty(
	cid CHAR(7),
    name CHAR(50)
);

CREATE TABLE semester(
	dept CHAR(4),
    number CHAR(4),
    cid CHAR(7)
);

-- Task - 03

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week06/students-credits.csv" INTO TABLE student
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week06/courses.csv" INTO TABLE course
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week06/credits.csv" INTO TABLE credit
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week06/faculty-course.csv" INTO TABLE faculty
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week06/semester.csv" INTO TABLE semester
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

-- Task - 04a

SELECT SUM(l)
FROM credit;

-- Task - 04b

SELECT SUM(c)
FROM credit
WHERE cid LIKE "EE%";

-- Task - 04c

SELECT SUM(p)
FROM credit
WHERE cid LIKE "DD%";

-- Task - 05a

SELECT cid, COUNT(roll_number)
FROM student
WHERE cid LIKE "%M" AND credit_status = 'Audit'
GROUP BY cid;

-- Task - 05b

SELECT SUBSTRING(cid, 1,2) AS dept_name, SUM(c)
FROM credit
GROUP BY dept_name;

-- Task - 06a

SELECT cid, COUNT(roll_number) as cnt
FROM student
WHERE credit_status = 'Audit'
GROUP BY cid
HAVING cnt > 3;

-- Task - 06b

SELECT c.cid, c.name, COUNT(f.name) AS num_of_fac
FROM course AS c, faculty AS f
WHERE c.cid = f.cid
GROUP BY cid
HAVING num_of_fac > 1; 

-- Task - 06c

SELECT name, COUNT(cid) AS cnt
FROM faculty
GROUP BY name
HAVING cnt>1;

-- Task - 07a

SELECT cid, name
FROM course NATURAL JOIN credit
WHERE c = (
SELECT MIN(c)
FROM credit
);

-- Task - 07b

SELECT c.cid, f.name
FROM faculty AS f, credit AS c
WHERE f.cid = c.cid AND c = (
SELECT MIN(c)
FROM credit
WHERE cid LIKE "CS%"
);

-- Task - 08a

CREATE TABLE temp AS SELECT S.dept, S.number, SUM(C.c) AS tot_cred
FROM semester AS S, credit AS C
WHERE S.cid = C.cid AND dept = 'DD'
GROUP BY number;

SELECT S.number
FROM semester AS S, credit AS C
WHERE S.cid = C.cid AND S.dept = 'BSBE'
GROUP BY S.number
HAVING SUM(C.c) < ANY(SELECT tot_cred FROM temp);

-- Task - 08b

SELECT S.number
FROM semester AS S, credit AS C
WHERE S.cid = C.cid AND S.dept = 'BSBE'
GROUP BY S.number
HAVING SUM(C.c) > ALL(SELECT tot_cred FROM temp);