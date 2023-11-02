-- TASK 01

CREATE DATABASE week14a;

USE week14a;

-- TASK 02

CREATE TABLE account(
	account_number CHAR(5),
    balance INT,
    original_balance INT
);

CREATE TABLE move_funds(
	from_acc CHAR(5),
    to_acc CHAR(5),
    transfer_amount INT
);

CREATE TABLE move_funds_log(
	account_number CHAR(5),
    move_fund_type CHAR(10),
	CHECK(move_fund_type IN ('deposit', 'withdraw')),
    amount INT,
    timestamp DATETIME,
    FOREIGN KEY(account_number) REFERENCES account(account_number)
);

ALTER TABLE account ADD PRIMARY KEY (account_number);

-- TASK 03

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week14/account.csv" INTO TABLE account
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week14/trnx.csv" INTO TABLE move_funds
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- TASK 04

CREATE USER 'saradhi' IDENTIFIED BY 'sr123';
CREATE USER 'pbhaduri' IDENTIFIED BY 'pb123';

-- TASK 05

GRANT select, insert, update, delete ON account TO saradhi;
GRANT select, insert, update, delete ON account TO pbhaduri;

GRANT select, insert, update, delete ON move_funds TO saradhi;
GRANT select, insert, update, delete ON move_funds TO pbhaduri;

GRANT select, insert, update, delete ON move_funds_log TO saradhi;
GRANT select, insert, update, delete ON move_funds_log TO pbhaduri;

GRANT ALL ON account TO saradhi;
GRANT ALL ON account TO pbhaduri;

GRANT LOCK TABLES ON week14a.* TO saradhi;
GRANT LOCK TABLES ON week14a.* TO pbhaduri;

-- TASK 06A

DELIMITER //
DROP PROCEDURE IF EXISTS transfer_funds_1//
CREATE PROCEDURE transfer_funds_1(IN from_acc CHAR(5), IN to_acc CHAR(5), IN transfer_amount INT)
BEGIN
	UPDATE account
    SET balance = balance + transfer_amount
    WHERE account_number = to_acc;
    UPDATE account
    SET balance = balance - transfer_amount
    WHERE account_number = from_acc;
END//
DELIMITER ;

GRANT EXECUTE ON PROCEDURE transfer_funds_1 TO saradhi;
GRANT EXECUTE ON PROCEDURE transfer_funds_1 TO pbhaduri;

-- TASK 06B IN SARADHI USER

USE week14a;

LOCK TABLES account WRITE;

CALL transfer_funds_1('52149', '15873', 250);

UNLOCK TABLES;

-- TASK 06C IN PBHADURI USER

USE week14a;

LOCK TABLES account WRITE;

CALL transfer_funds_1('52149', '15873', 250);

UNLOCK TABLES;

-- TASK 07

DELIMITER //
DROP PROCEDURE IF EXISTS transfer_funds_2//
CREATE PROCEDURE transfer_funds_2(IN from_acc CHAR(5), IN to_acc CHAR(5), IN transfer_amount INT)
BEGIN
	START TRANSACTION;
		SET @bal = (SELECT balance FROM account WHERE account_number = from_acc);
		IF @bal < 100 THEN ROLLBACK;
		ELSE 
			UPDATE account
			SET balance = balance + transfer_amount
			WHERE account_number = to_acc;
			UPDATE account
			SET balance = balance - transfer_amount
			WHERE account_number = from_acc;
            INSERT INTO move_funds_log VALUES (from_acc, 'withdraw', transfer_amount, now());
            INSERT INTO move_funds_log VALUES (to_acc, 'deposit', transfer_amount, now());
            COMMIT;
		END IF;
END//
DELIMITER ;

GRANT EXECUTE ON PROCEDURE transfer_funds_2 TO saradhi;
GRANT EXECUTE ON PROCEDURE transfer_funds_2 TO pbhaduri;

-- TASK 08

DELIMITER //
DROP PROCEDURE IF EXISTS main_transfer_2//
CREATE PROCEDURE main_transfer_2()
BEGIN
	DECLARE done INT DEFAULT FALSE;
	DECLARE from_acc CHAR(5);
    DECLARE to_acc CHAR(5);
    DECLARE amt INT;
	DECLARE cur1 CURSOR FOR SELECT * FROM move_funds;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur1;
    read_loop: LOOP
		FETCH cur1 INTO from_acc, to_acc, amt;
        IF done THEN
		LEAVE read_loop;
		END IF;
        CALL transfer_funds_2(from_acc, to_acc, amt);
	END LOOP;
END//
DELIMITER ;


GRANT EXECUTE ON PROCEDURE main_transfer_2 TO saradhi;
GRANT EXECUTE ON PROCEDURE main_transfer_2 TO pbhaduri;

-- TASK 09A IN SARADHI USER

CALL main_transfer_2();

-- TASK 09B IN PBHADURI USER

CALL main_transfer_2();

-- TASK 10

CREATE TABLE deposits AS
SELECT account_number, SUM(amount) as deposits
FROM move_funds_log
WHERE move_fund_type = 'deposit'
GROUP BY account_number;

CREATE TABLE withdrawals AS
SELECT account_number, SUM(amount) as withdrawals
FROM move_funds_log
WHERE move_fund_type = 'withdraw'
GROUP BY account_number;

SELECT *, balance - deposits + withdrawals
FROM account LEFT JOIN (deposits NATURAL JOIN withdrawals) USING (account_number);
