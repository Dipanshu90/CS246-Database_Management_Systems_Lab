-- Task - 01

CREATE DATABASE week05;

use week05;

-- Task - 02 a

CREATE TABLE student (
	cid CHAR(7),
    roll_number CHAR(10),
    name CHAR(100) NOT NULL,
    approval_status CHAR(20),
    credit_status CHAR(10),
	PRIMARY KEY(roll_number, cid),
    CHECK (credit_status in ('Credit', 'Audit')),
    CHECK (approval_status in ('Approved','Pending'))
);

-- Task - 02 b

CREATE TABLE course (
	cid CHAR(7) PRIMARY KEY,
    name CHAR(100) NOT NULL
);

-- Task - 02 c

CREATE TABLE credit (
	cid CHAR(7) PRIMARY KEY,
    l INT NOT NULL,
    t INT NOT NULL,
    p INT NOT NULL,
    c FLOAT NOT NULL
);

-- Task - 03

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week05/students-credits.csv" INTO TABLE student
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week05/courses.csv" INTO TABLE course
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week05/credits.csv" INTO TABLE credit
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

-- Task - 04 a

SELECT * 
FROM student 
WHERE name = 'Adarsh Kumar Udai';

-- Task - 04 b

SELECT cid, name, credit_status
FROM student
WHERE cid = 'EE 390' and credit_status = 'Credit';

-- Task - 04 c

SELECT cid, roll_number, credit_status, approval_status
FROM student 
WHERE approval_status = 'Pending' AND credit_status = 'Credit';

-- Task - 04 d

SELECT cid, l, t, p, c
FROM credit 
WHERE c != 6;

-- Task - 04 e

SELECT roll_number, name, cid, credit_status, approval_status
FROM student
WHERE credit_status = 'Audit' AND approval_status = 'Approved';

-- Task - 05 a

SELECT name, l, t, p, c
FROM credit NATURAL JOIN course
WHERE c = 8;

-- Task - 05 b

SELECT name, l, t, p, c
FROM credit NATURAL JOIN course
WHERE t != 0;

-- Task - 05 c

SELECT cid, name, l, t, p, c
FROM credit NATURAL JOIN course
WHERE NOT (l=3 AND t=0 AND p=0) AND c = 6;

-- Task - 05 d

SELECT credit.cid, course.name, student.name, l, t, p, c
FROM credit, student, course
WHERE credit.cid = student.cid AND credit.cid = course.cid AND course.cid = student.cid AND student.name = 'Pasch Paul Ole';

-- Task - 05 e

SELECT roll_number, student.name, credit.cid, course.name, l, t, p, c
FROM credit, student, course
WHERE credit.cid = student.cid AND credit.cid = course.cid AND course.cid = student.cid AND
	  l = 3 AND t = 1 AND p = 0 AND c = 8 AND credit.cid LIKE 'EE%' AND credit_status = 'Credit';

-- Task - 06 a

SELECT cid, name
FROM student
WHERE UPPER(name) LIKE '%ATUL%';

-- Task - 06 b

SELECT roll_number, credit_status, course.name
FROM student, course
WHERE student.cid = course.cid AND LOWER(course.name) LIKE 'introduction to%';

-- Task - 06 c

SELECT COUNT(distinct roll_number)
FROM student
WHERE cid LIKE 'EE 3%';

-- Task - 06 d

SELECT cid, name
FROM course
WHERE cid LIKE '____2_M';

-- Task - 06 e

SELECT student.name, course.cid, course.name, credit_status
FROM student, course
WHERE student.cid = course.cid AND credit_status = 'Credit' AND UPPER(student.name) LIKE 'A%TA';