-- Task 01

CREATE DATABASE week07;

USE week07;

-- Task 02

CREATE TABLE student18a(
	name CHAR(100),
    roll_number CHAR(10) PRIMARY KEY
);

CREATE TABLE course18a(
	semester INT,
    cid CHAR(7) PRIMARY KEY,
    name CHAR(100),
    l INT,
    t INT,
    p INT,
    c INT
);

CREATE TABLE grade18a(
	roll_number CHAR(10),
    cid CHAR(7),
    letter_grade CHAR(2),
    PRIMARY KEY(roll_number, cid)
);

-- Task 03

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week07/student18.csv" INTO TABLE student18a
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week07/course18.csv" INTO TABLE course18a
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week07/grade18.csv" INTO TABLE grade18a
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

-- Task 04a

CREATE VIEW v1 AS
SELECT *
FROM grade18a
WHERE cid LIKE "XX%";

INSERT INTO grade18a VALUES('180101000', 'CS 101', 'AB');

SELECT *
FROM v1
WHERE roll_number = '180101000';

/*
We cannot say that the view is materialized or not because the record which is inserted doesn't satisfy the condition of where clause of the
query involved in the creation of view v1.
*/

-- Task 04b

CREATE VIEW v2 AS
SELECT DISTINCT cid, letter_grade
FROM grade18a;

INSERT INTO v2 VALUES('CS101','PM');

-- The view v2 is not updatable because the query involved in its creation includes a distinct specification in select statement.

-- Task 04c

CREATE VIEW v3 AS
SELECT cid, letter_grade, COUNT(roll_number) AS number_of_students
FROM grade18a
GROUP BY letter_grade, cid;

INSERT INTO v3 VALUES('CS 101','NP', 17);

-- The view v3 is not updatable because the query involved in its creation includes COUNT(an aggregate) and GROUP BY clause.

-- Task 05a

CREATE TABLE course18b(
	semester INT,
    CHECK(semester IN (1,2,3,4,5,6,7,8)),
    cid CHAR(7) PRIMARY KEY,
    name CHAR(100),
    l INT,
    t INT,
    p INT,
    c INT
);

INSERT INTO course18b VALUES (10, 'CS 777', 'Introduction to Chat GPT', 3, 0, 0, 6);

-- The check statement is not working properly in this system, this insert query should return an error due to check statement.

-- Task 05b

CREATE TABLE allowable_letter_grade(
	grade CHAR(2),
    value INT
);

INSERT INTO allowable_letter_grade VALUES('AS', 10);
INSERT INTO allowable_letter_grade VALUES('AA', 10);
INSERT INTO allowable_letter_grade VALUES('AB', 9);
INSERT INTO allowable_letter_grade VALUES('BB', 8);
INSERT INTO allowable_letter_grade VALUES('BC', 7);
INSERT INTO allowable_letter_grade VALUES('CC', 6);
INSERT INTO allowable_letter_grade VALUES('CD', 5);
INSERT INTO allowable_letter_grade VALUES('DD', 4);
INSERT INTO allowable_letter_grade VALUES('FP', 0);
INSERT INTO allowable_letter_grade VALUES('FA', 0);
INSERT INTO allowable_letter_grade VALUES('NP', 0);
INSERT INTO allowable_letter_grade VALUES('PP', 0);
INSERT INTO allowable_letter_grade VALUES('I', 0);
INSERT INTO allowable_letter_grade VALUES('X', 0);

-- Task 05c

CREATE TABLE grade18b(
	roll_number CHAR(10),
    cid CHAR(7),
    letter_grade CHAR(2),
    PRIMARY KEY(roll_number, cid),
    CHECK(letter_grade IN (SELECT grade FROM allowable_letter_grade))
);

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week07/grade18.csv" INTO TABLE grade18b
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

UPDATE grade18b
SET letter_grade = 'MP'
WHERE cid = 'XX102M' AND letter_grade = 'DD';

-- The check statement is not working properly in this system, this update query should return an error due to check statement.

-- Task 06a

CREATE TABLE student18c(
	name CHAR(100),
    roll_number CHAR(10),
    CONSTRAINT P_Key PRIMARY KEY(roll_number)
);

-- Task 06b

CREATE TABLE grade18c(
	roll_number CHAR(10),
    cid CHAR(7),
    letter_grade CHAR(2),
    CONSTRAINT grade_P_Key PRIMARY KEY(roll_number, cid),
    CONSTRAINT grade_F_Key FOREIGN KEY(roll_number) REFERENCES student18c(roll_number) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Task 06c

ALTER TABLE grade18c DROP FOREIGN KEY grade_F_Key;

-- Task 07a

CREATE TABLE student18d(
	name CHAR(100),
    roll_number CHAR(10) PRIMARY KEY
);

-- Task 07b

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week07/student18.csv" INTO TABLE student18d
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

-- Task 07c

SELECT SUM(CAST(roll_number AS UNSIGNED)) AS SUM, MIN(CAST(roll_number AS UNSIGNED)) AS MIN, MAX(CAST(roll_number AS UNSIGNED)) AS MAX, AVG(CAST(roll_number AS UNSIGNED)) AS AVG
FROM student18d;

-- Task 07d

SELECT CAST(roll_number AS DATETIME)
FROM student18d;

-- Task 08a

CREATE TABLE course18e LIKE course18a;

-- Task 08b

INSERT INTO course18e
SELECT *
FROM course18a;

-- Task 09a

CREATE TABLE student18f(
	roll_number CHAR(10) PRIMARY KEY,
    name CHAR(100),
    redundant01 INT DEFAULT 10
);

CREATE TABLE course18f(
	semester INT,
    cid CHAR(7) PRIMARY KEY,
    name CHAR(100),
    l INT,
    t INT,
    p INT,
    c INT,
    redundant01 INT DEFAULT 10
);

CREATE TABLE grade18f(
	roll_number CHAR(10),
    cid CHAR(7),
    letter_grade CHAR(2),
    redundant01 INT DEFAULT 10,
    PRIMARY KEY(roll_number, cid)
);

-- Task 09b

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week07/student18.csv" INTO TABLE student18f
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n' (name, roll_number);

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week07/course18.csv" INTO TABLE course18f
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'(semester, cid, name, l,t,p,c);

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week07/grade18.csv" INTO TABLE grade18f
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'(roll_number, cid, letter_grade);

-- Task 09c

SELECT grade18f.roll_number, course18f.name, grade18f.letter_grade
FROM grade18f JOIN course18f ON grade18f.cid = course18f.cid
WHERE (l,t,p,c) = (3,1,0,8);

-- Task 09d

TRUNCATE TABLE grade18f;

-- Task 09e

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week07/cs570.csv" INTO TABLE grade18f
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'(roll_number, cid, letter_grade);

-- Task 09f

SELECT roll_number, name, letter_grade
FROM grade18f JOIN student18f USING(roll_number);