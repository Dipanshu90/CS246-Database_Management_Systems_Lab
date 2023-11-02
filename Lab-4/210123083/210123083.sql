-- Task - 01

CREATE DATABASE week04;

USE week04;

-- Task - 02

CREATE TABLE hss_table01(
sno INT,
roll_number INT,
sname VARCHAR(50),
cid VARCHAR(10),
cname VARCHAR(60));

LOAD DATA LOCAL INFILE "/home/mathsuser/Week4_dbms/hss_electives.csv" INTO TABLE hss_table01
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

SELECT * FROM hss_table01;

-- Task - 03

CREATE TABLE hss_table02(
sno INT,
roll_number INT,
sname VARCHAR(50),
cid VARCHAR(10),
cname VARCHAR(60) PRIMARY KEY);

LOAD DATA LOCAL INFILE "/home/mathsuser/Week4_dbms/hss_electives.csv" INTO TABLE hss_table02
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

SELECT * FROM hss_table02;

-- We observe that data is not loading completely as the primary key has to be unique and here cname is the primary key.
-- So It is not a good idea to make cname the primary key

-- Task - 04

CREATE TABLE hss_table03(
sno INT,
roll_number INT,
sname VARCHAR(50),
cid VARCHAR(10),
cname VARCHAR(60),
PRIMARY KEY(roll_number, cid));

LOAD DATA LOCAL INFILE "/home/mathsuser/Week4_dbms/hss_electives.csv" INTO TABLE hss_table03
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/home/mathsuser/Week4_dbms/additional_hss_course.csv" INTO TABLE hss_table03
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

SELECT * FROM hss_table03;

-- We observe that both the csv files are inserted successfully in the table and the data is sorted first according to the roll_number(first primary key)
-- and in case of same roll number, it is sorted according to the second primary key i.e. cid.

-- Task - 05

CREATE TABLE hss_table04(
sno INT PRIMARY KEY,
roll_number INT PRIMARY KEY,
sname VARCHAR(50),
cid VARCHAR(10),
cname VARCHAR(60));

-- We observe that this task gives an error code 1068 saying multiple primary key defined. 

-- Task - 06

CREATE TABLE hss_course01(
cid VARCHAR(10) PRIMARY KEY,
cname VARCHAR(60)
);

CREATE TABLE hss_table05(
sno INT,
roll_number INT PRIMARY KEY,
sname VARCHAR(50),
cid VARCHAR(10),
cname VARCHAR(60),
FOREIGN KEY(cid) REFERENCES hss_course01(cid));

LOAD DATA LOCAL INFILE "/home/mathsuser/Week4_dbms/hss_courses.csv" INTO TABLE hss_course01
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/home/mathsuser/Week4_dbms/hss_electives.csv" INTO TABLE hss_table05
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/home/mathsuser/Week4_dbms/violate_fk.csv" INTO TABLE hss_table05
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

-- We observe that due to Foreign Key Constraint, the data from violate_fk.csv cannot be added to hss_table05 as the cid in violate_fk.csv
-- is not present in the hss_courses01 table, so first the HSS course with that cid must be added to table hss_course01 after that only the data 
-- can be inserted into hss_table05.

-- Task - 07

CREATE TABLE hss_course02(
cid VARCHAR(10),
cname VARCHAR(60) PRIMARY KEY
);

CREATE TABLE hss_table06(
sno INT,
roll_number INT PRIMARY KEY,
sname VARCHAR(50),
cid VARCHAR(10),
cname VARCHAR(60),
FOREIGN KEY(cid) REFERENCES hss_course02(cid));

-- We observe that hss_table06 can't be formed as cid is not the primary key in hss_course02, It gives an error saying cannot add foreign key constraint.

-- Task - 08

CREATE TABLE hss_course03(
cid VARCHAR(10),
cname VARCHAR(60)
);

CREATE TABLE hss_table07(
sno INT,
roll_number INT PRIMARY KEY,
sname VARCHAR(50),
cid VARCHAR(10),
cname VARCHAR(60),
FOREIGN KEY(cid) REFERENCES hss_course03(cid));

-- We observe that hss_table07 can't be formed as there is not primary key in hss_course03, It gives an error saying cannot add foreign key constraint.