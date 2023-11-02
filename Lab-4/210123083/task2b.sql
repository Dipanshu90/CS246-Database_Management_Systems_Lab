CREATE DATABASE week04;

USE week04;

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