CREATE DATABASE week13;

USE week13;

CREATE TABLE location(
	location_id INT PRIMARY KEY,
	city CHAR(10),
	state CHAR(2),
    country CHAR(20)
);

CREATE TABLE product(
	product_id INT PRIMARY KEY,
    product_name CHAR(10),
    category CHAR(10),
    price INT
);

CREATE TABLE sale(
	product_id INT,
    time_id INT,
    location_id INT,
    sales INT,
	PRIMARY KEY(product_id, time_id, location_id)
);

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week13/location.csv" INTO TABLE location
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week13/product.csv" INTO TABLE product
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week13/sale.csv" INTO TABLE sale
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE year_state_01(
	years CHAR(5),
    WI INT,
    CA INT,
    Total INT
);

SET @Q_wi = (SELECT SUM(sales)
		FROM sale NATURAL JOIN location
		WHERE time_id = 1995 AND state = "WI");
        
SET @Q_ca = (SELECT SUM(sales)
		FROM sale NATURAL JOIN location
		WHERE time_id = 1995 AND state = "CA");
        
INSERT INTO year_state_01 VALUES ('1995', @Q_wi, @Q_ca, @Q_wi+@Q_ca);

SET @Q_wi = (SELECT SUM(sales)
		FROM sale NATURAL JOIN location
		WHERE time_id = 1996 AND state = "WI");
        
SET @Q_ca = (SELECT SUM(sales)
		FROM sale NATURAL JOIN location
		WHERE time_id = 1996 AND state = "CA");
        
INSERT INTO year_state_01 VALUES ('1996', @Q_wi, @Q_ca, @Q_wi+@Q_ca);

SET @Q_wi = (SELECT SUM(sales)
		FROM sale NATURAL JOIN location
		WHERE time_id = 1997 AND state = "WI");
        
SET @Q_ca = (SELECT SUM(sales)
		FROM sale NATURAL JOIN location
		WHERE time_id = 1997 AND state = "CA");
        
INSERT INTO year_state_01 VALUES ('1997', @Q_wi, @Q_ca, @Q_wi+@Q_ca);

SET @Q_wi = (SELECT SUM(sales)
		FROM sale NATURAL JOIN location
		WHERE time_id IN (1995, 1996, 1997) AND state = "WI");
        
SET @Q_ca = (SELECT SUM(sales)
		FROM sale NATURAL JOIN location
		WHERE time_id IN (1995, 1996, 1997) AND state = "CA");
        
INSERT INTO year_state_01 VALUES ('Total', @Q_wi, @Q_ca, @Q_wi+@Q_ca);

CREATE TABLE year_state_02_01 AS
SELECT time_id, 
	   SUM(CASE
			WHEN state = "WI" THEN sales ELSE 0 END
		) AS WI,
       SUM(CASE
			WHEN state = "CA" THEN sales ELSE 0 END
		) AS CA
FROM sale NATURAL JOIN location
GROUP BY time_id;

CREATE TABLE year_state_02_02 AS
SELECT (WI + CA) AS Total
FROM year_state_02_01;

CREATE TABLE year_state_02_03 AS
SELECT SUM(WI) as WI, SUM(CA) as CA
FROM year_state_02_01;

CREATE TABLE year_state_02_04 AS
SELECT SUM(Total) AS Total
FROM year_state_02_02;

CREATE TABLE year_state_03 AS
(SELECT time_id, 
	   SUM(CASE
			WHEN state = "WI" THEN sales ELSE 0 END
		) AS WI,
       SUM(CASE
			WHEN state = "CA" THEN sales ELSE 0 END
		) AS CA,
        SUM(CASE
			WHEN state IN ("WI","CA") THEN sales ELSE 0 END
		) AS Total
FROM sale NATURAL JOIN location
GROUP BY time_id)
UNION
(SELECT "Total" AS time_id,
		SUM(CASE
			WHEN state = "WI" THEN sales ELSE 0 END
		) AS WI,
        SUM(CASE
			WHEN state = "CA" THEN sales ELSE 0 END
		) AS CA,
        SUM(CASE
			WHEN state IN ("WI","CA") THEN sales ELSE 0 END
		) AS Total
FROM sale NATURAL JOIN location);

CREATE TABLE year_state_04 (
    time_id CHAR(5),
    WI INT,
    CA INT,
    Total INT
);

INSERT INTO year_state_04
SELECT time_id, 
	   SUM(CASE
			WHEN state = "WI" THEN sales ELSE 0 END
		) AS WI,
       SUM(CASE
			WHEN state = "CA" THEN sales ELSE 0 END
		) AS CA,
        SUM(CASE
			WHEN state IN ("WI","CA") THEN sales ELSE 0 END
		) AS Total
FROM sale NATURAL JOIN location
GROUP BY time_id WITH ROLLUP;

UPDATE year_state_04 
SET time_id = "Total" WHERE time_id IS NULL;