USE week09;

CREATE TABLE student18(
	name CHAR(100),
    roll_number CHAR(10) PRIMARY KEY
);

CREATE TABLE course18(
	semester INT,
	cid CHAR(7) PRIMARY KEY,
    name CHAR(100),
    l INT,
    t INT,
    p INT,
    c INT
);

CREATE TABLE grade18(
	roll_number CHAR(10),
    cid CHAR(7),
    letter_grade CHAR(2),
    PRIMARY KEY(roll_number, cid)
);

CREATE TABLE curriculum(
	dept CHAR(3),
    number INT,
    cid CHAR(7)
);

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week09/student18.csv" INTO TABLE student18
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week09/course18.csv" INTO TABLE course18
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week09/grade18.csv" INTO TABLE grade18
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week09/curriculum.csv" INTO TABLE curriculum
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

CREATE TABLE t1 AS	
SELECT cid FROM curriculum WHERE number=1 AND cid != "HS101";

CREATE TABLE t2 AS
SELECT cid FROM curriculum WHERE number=2 AND cid != "SA1xx";

CREATE TABLE t3 AS
SELECT cid FROM curriculum WHERE number=3 AND cid NOT IN ("SA2xx", "HS200");

CREATE TABLE t4 AS 
SELECT cid FROM curriculum WHERE number=4 AND cid NOT IN ("HS1xx", "SA3xx") AND cid NOT LIKE "%M";

CREATE TABLE t5 AS
SELECT cid FROM curriculum WHERE number=5 AND cid NOT IN ("SA4xx") AND cid NOT LIKE "%M";

CREATE TABLE t6 AS
SELECT cid FROM curriculum WHERE number=6 AND cid NOT LIKE "%M";

CREATE TABLE t7 AS
SELECT cid FROM curriculum WHERE number=7 AND cid = "CS498";

CREATE TABLE t8 AS
SELECT cid FROM curriculum WHERE number=8 AND cid = "CS499";

CREATE TABLE tSA AS
SELECT cid, number
FROM curriculum 
WHERE cid LIKE "SA%";
