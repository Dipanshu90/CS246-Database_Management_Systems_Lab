CREATE DATABASE week11;

USE week11;

CREATE TABLE emp_boss_small(
	ename CHAR(50),
    bname CHAR(50),
    PRIMARY KEY(ename, bname)
);

CREATE TABLE emp_boss_large LIKE emp_boss_small;

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week11/week-11-emp_small.csv" INTO TABLE emp_boss_small
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week11/week-11-emp_large.csv" INTO TABLE emp_boss_large
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



DELIMITER //
DROP PROCEDURE IF EXISTS sp2//
CREATE PROCEDURE sp2(IN ename CHAR(50), IN data_size CHAR(20))
BEGIN
	DECLARE rows SMALLINT DEFAULT 0;
	IF data_size = "emp_boss_large" THEN 
		CREATE TABLE IF NOT EXISTS output_large(
			ename CHAR(50),
			bname CHAR(50),
			PRIMARY KEY(ename, bname)
		);
        DROP TABLE IF EXISTS temp;
		CREATE TABLE temp
		(
			ename VARCHAR(50) PRIMARY KEY
		);
		INSERT INTO temp VALUES (ename);
		SET rows = ROW_COUNT();
		WHILE rows > 0 DO
			INSERT IGNORE INTO temp
				SELECT DISTINCT ename
				FROM emp_boss_large AS e
				INNER JOIN temp AS p ON e.bname = p.ename;
			SET rows = ROW_COUNT();
			INSERT IGNORE INTO temp
				SELECT DISTINCT bname
				FROM emp_boss_large AS e
				INNER JOIN temp AS p ON e.ename = p.ename;
			SET rows = rows + ROW_COUNT();
		END WHILE;
        DELETE FROM temp where temp.ename IN (ename, "NA");
		insert into output_large select ename, temp.ename from temp;
		DROP TABLE temp;
	ELSEIF data_size = "emp_boss_small" THEN
		CREATE TABLE IF NOT EXISTS output_small(
			ename CHAR(50),
			bname CHAR(50),
			PRIMARY KEY(ename, bname)
        );
        DROP TABLE IF EXISTS temp;
		CREATE TABLE temp
		(
			ename VARCHAR(50) PRIMARY KEY
		);
		INSERT INTO temp VALUES (ename);
		SET rows = ROW_COUNT();
		WHILE rows > 0 DO
			INSERT IGNORE INTO temp
				SELECT DISTINCT ename
				FROM emp_boss_small AS e
				INNER JOIN temp AS p ON e.bname = p.ename;
			SET rows = ROW_COUNT();
			INSERT IGNORE INTO temp
				SELECT DISTINCT bname
				FROM emp_boss_small AS e
				INNER JOIN temp AS p ON e.ename = p.ename;
			SET rows = rows + ROW_COUNT();
		END WHILE;
        DELETE FROM temp where temp.ename IN (ename, "NA");
		insert into output_small select ename, temp.ename from temp;
		DROP TABLE temp;
	END IF;
END//
DELIMITER ;

CALL sp2("Employee 01", "emp_boss_small");
CALL sp2("Employee 02", "emp_boss_small");
CALL sp2("Employee 03", "emp_boss_small");
CALL sp2("Employee 04", "emp_boss_small");
CALL sp2("Employee 05", "emp_boss_small");
CALL sp2("Employee 06", "emp_boss_small");
CALL sp2("Employee 07", "emp_boss_small");
CALL sp2("Employee 08", "emp_boss_small");
CALL sp2("Employee 09", "emp_boss_small");
CALL sp2("Employee 10", "emp_boss_small");
CALL sp2("Employee 11", "emp_boss_small");
CALL sp2("Employee 12", "emp_boss_small");
CALL sp2("Employee 13", "emp_boss_small");

CALL sp2("Employee 01", "emp_boss_large");
CALL sp2("Employee 02", "emp_boss_large");
CALL sp2("Employee 03", "emp_boss_large");
CALL sp2("Employee 04", "emp_boss_large");
CALL sp2("Employee 05", "emp_boss_large");
CALL sp2("Employee 06", "emp_boss_large");
CALL sp2("Employee 07", "emp_boss_large");
CALL sp2("Employee 08", "emp_boss_large");
CALL sp2("Employee 09", "emp_boss_large");
CALL sp2("Employee 10", "emp_boss_large");
CALL sp2("Employee 11", "emp_boss_large");
CALL sp2("Employee 12", "emp_boss_large");
CALL sp2("Employee 13", "emp_boss_large");
CALL sp2("Employee 14", "emp_boss_large");
CALL sp2("Employee 15", "emp_boss_large");
CALL sp2("Employee 16", "emp_boss_large");
CALL sp2("Employee 17", "emp_boss_large");
CALL sp2("Employee 18", "emp_boss_large");
CALL sp2("Employee 19", "emp_boss_large");
CALL sp2("Employee 20", "emp_boss_large");
CALL sp2("Employee 21", "emp_boss_large");
CALL sp2("Employee 22", "emp_boss_large");
CALL sp2("Employee 23", "emp_boss_large");
CALL sp2("Employee 24", "emp_boss_large");
CALL sp2("Employee 25", "emp_boss_large");
CALL sp2("Employee 26", "emp_boss_large");
CALL sp2("Employee 27", "emp_boss_large");
CALL sp2("Employee 28", "emp_boss_large");
CALL sp2("Employee 29", "emp_boss_large");
CALL sp2("Employee 30", "emp_boss_large");
CALL sp2("Employee 31", "emp_boss_large");
CALL sp2("Employee 32", "emp_boss_large");
CALL sp2("Employee 33", "emp_boss_large");
CALL sp2("Employee 34", "emp_boss_large");
CALL sp2("Employee 35", "emp_boss_large");
CALL sp2("Employee 36", "emp_boss_large");
CALL sp2("Employee 37", "emp_boss_large");
CALL sp2("Employee 38", "emp_boss_large");
CALL sp2("Employee 39", "emp_boss_large");
CALL sp2("Employee 40", "emp_boss_large");
CALL sp2("Employee 41", "emp_boss_large");
CALL sp2("Employee 42", "emp_boss_large");
CALL sp2("Employee 43", "emp_boss_large");
CALL sp2("Employee 44", "emp_boss_large");
CALL sp2("Employee 45", "emp_boss_large");
CALL sp2("Employee 46", "emp_boss_large");
CALL sp2("Employee 47", "emp_boss_large");
CALL sp2("Employee 48", "emp_boss_large");
CALL sp2("Employee 49", "emp_boss_large");