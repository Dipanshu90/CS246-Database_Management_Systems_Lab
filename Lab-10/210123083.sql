CREATE DATABASE week10;

USE week10;

CREATE TABLE student18(
	name CHAR(100),
    roll_number CHAR(10) PRIMARY KEY,
    cpi FLOAT DEFAULT 0.0
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
	dept CHAR(4),
    number INT,
    cid CHAR(7)
);

CREATE TABLE grade_point(
	letter_grade CHAR(2) PRIMARY KEY,
    value INT
);

CREATE TABLE trigger_log(
	my_action CHAR(10),
    roll_number CHAR(10),
    semester INT,
    SPI FLOAT(2),
    CPI FLOAT(2),
    CHECK(my_action IN ('INSERT', 'UPDATE', 'DELETE'))
);

CREATE TABLE transcript(
	roll_number CHAR(10),
    semester INT,
    SPI FLOAT(2),
    CPI FLOAT(2)
);

CREATE TABLE u_grade18 LIKE grade18;

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week10/student18.csv" INTO TABLE student18
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week10/course18.csv" INTO TABLE course18
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week10/curriculum.csv" INTO TABLE curriculum
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week10/u_grade18.csv" INTO TABLE u_grade18
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week10/transcript.csv" INTO TABLE transcript
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

INSERT INTO grade_point(letter_grade, value) VALUES ('AS', 10), ('AA',10), ('AB',9),('BB',8), ('BC',7),('CC',6),('CD',5),('DD',4),('FA',0),('FP',0),('I',0),('X',0),('PP',0),('NP',0);

delimiter //
CREATE TRIGGER t4a_i BEFORE INSERT ON grade18
FOR EACH ROW
BEGIN
	if new.letter_grade NOT IN (SELECT letter_grade FROM grade_point) then 
    SIGNAL SQLSTATE '50001'
    SET MESSAGE_TEXT = "Invalid letter_grade";
    end if;
END;//
delimiter ;

delimiter //
CREATE TRIGGER t4a_ii AFTER INSERT ON grade18
FOR EACH ROW
BEGIN
	if (select sum(c) from course18 where cid in (select cid from grade18 where roll_number = new.roll_number and cid in (select cid from curriculum where number=(SELECT number FROM curriculum WHERE cid = new.cid)))) = 0 then update transcript set SPI = 0.0 where roll_number=new.roll_number and semester = (SELECT number FROM curriculum WHERE cid = new.cid);
	else UPDATE transcript SET SPI = (SPI*((select sum(c) from course18 where cid in 
(select cid from grade18 where roll_number = new.roll_number and cid in 
(select cid from curriculum where number=(SELECT number FROM curriculum WHERE cid = new.cid)))) - (select c from course18 where cid=new.cid)) + (select value from grade_point where letter_grade = new.letter_grade)*(select c from course18 where cid = new.cid))/((select sum(c) from course18 where cid in 
(select cid from grade18 where roll_number = new.roll_number and cid in 
(select cid from curriculum where number=(SELECT number FROM curriculum WHERE cid = new.cid))))) WHERE roll_number = new.roll_number AND semester = (SELECT number FROM curriculum WHERE cid = new.cid);
	end if;
    
	if (select sum(c) from course18 where cid in (select cid from grade18 where roll_number = new.roll_number)) = 0 then update transcript set CPI = 0.0 where roll_number=new.roll_number;
	else UPDATE transcript SET CPI = (CPI*((select sum(c) from course18 where cid in 
(select cid from grade18 where roll_number = new.roll_number)) - (select c from course18 where cid=new.cid)) + (select value from grade_point where letter_grade = new.letter_grade)*(select c from course18 where cid = new.cid))/((select sum(c) from course18 where cid in 
(select cid from grade18 where roll_number = new.roll_number))) WHERE roll_number = new.roll_number;
	end if;
	
	INSERT INTO trigger_log VALUES ('INSERT', new.roll_number, (SELECT number FROM curriculum where cid = new.cid), (select SPI from transcript where roll_number = new.roll_number and semester = (select number from curriculum where cid=new.cid)), (select CPI from transcript where roll_number=new.roll_number and semester = (select number from curriculum where cid=new.cid)));
END;//
delimiter ;

insert into grade18 values ('180101002', 'SA101', 'PP');
insert into grade18 values ('180101002', 'CS245', 'AB');
insert into grade18 values ('180101002', 'CS246', 'BB');
insert into grade18 values ('180101002', 'CS224', 'CC');
insert into grade18 values ('180101002', 'CH101', 'BC');

insert into grade18 values ('180101003', 'MA101', 'AA');
insert into grade18 values ('180101003', 'CS245', 'AB');
insert into grade18 values ('180101003', 'CS246', 'BB');
insert into grade18 values ('180101003', 'CS224', 'CC');
insert into grade18 values ('180101003', 'CH101', 'BC');
drop trigger t4a_ii;
delimiter //
CREATE TRIGGER t4b_i BEFORE UPDATE ON grade18
FOR EACH ROW
BEGIN
	if new.letter_grade NOT IN (SELECT letter_grade FROM grade_point) then 
    SIGNAL SQLSTATE '50001'
    SET MESSAGE_TEXT = "Invalid letter_grade";
    end if;
END;//
delimiter ;

delimiter //
CREATE TRIGGER t4b_ii AFTER UPDATE ON grade18
FOR EACH ROW
BEGIN
	UPDATE transcript SET SPI = (SPI*(select sum(c) from course18 where cid in 
(select cid from grade18 where roll_number = new.roll_number and cid in 
(select cid from curriculum where number=(SELECT number FROM curriculum WHERE cid = new.cid)))) - ((select value from grade_point where letter_grade = old.letter_grade) - (select value from grade_point where letter_grade=new.letter_grade))*(select c from course18 where cid = new.cid))/((select sum(c) from course18 where cid in 
(select cid from grade18 where roll_number = new.roll_number and cid in 
(select cid from curriculum where number=(SELECT number FROM curriculum WHERE cid = new.cid))))) WHERE roll_number = new.roll_number AND semester = (SELECT number FROM curriculum WHERE cid = new.cid);

	UPDATE transcript SET CPI = (CPI*(select sum(c) from course18 where cid in 
(select cid from grade18 where roll_number = new.roll_number)) - ((select value from grade_point where letter_grade = old.letter_grade) - (select value from grade_point where letter_grade = new.letter_grade))*(select c from course18 where cid = new.cid))/((select sum(c) from course18 where cid in 
(select cid from grade18 where roll_number = new.roll_number))) WHERE roll_number = new.roll_number;

	INSERT INTO trigger_log VALUES ('UPDATE', new.roll_number, (SELECT number FROM curriculum where cid = new.cid), (select SPI from transcript where roll_number = new.roll_number and semester = (select number from curriculum where cid=new.cid)), (select CPI from transcript where roll_number=new.roll_number and semester = (select number from curriculum where cid=new.cid)));
END;//
delimiter ;

update grade18 set letter_grade = 'AB' where roll_number = '180101002' and cid = 'MA101';
update grade18 set letter_grade = 'AB' where roll_number = '180101002' and cid = 'CS224';

delimiter //
CREATE TRIGGER t4c AFTER DELETE ON grade18
FOR EACH ROW
BEGIN
	UPDATE transcript SET SPI = (SPI*((select sum(c) from course18 where cid in 
(select cid from grade18 where roll_number = old.roll_number and cid in 
(select cid from curriculum where number=(SELECT number FROM curriculum WHERE cid = old.cid)))) + (select c from course18 where cid=old.cid)) - (select value from grade_point where letter_grade = old.letter_grade)*(select c from course18 where cid = old.cid))/((select sum(c) from course18 where cid in 
(select cid from grade18 where roll_number = old.roll_number and cid in 
(select cid from curriculum where number=(SELECT number FROM curriculum WHERE cid = old.cid))))) WHERE roll_number = old.roll_number AND semester = (SELECT number FROM curriculum WHERE cid = old.cid);

	UPDATE transcript SET CPI = (CPI*((select sum(c) from course18 where cid in 
(select cid from grade18 where roll_number = old.roll_number)) + (select c from course18 where cid=old.cid)) - (select value from grade_point where letter_grade = old.letter_grade)*(select c from course18 where cid = old.cid))/((select sum(c) from course18 where cid in 
(select cid from grade18 where roll_number = old.roll_number))) WHERE roll_number = old.roll_number;

	INSERT INTO trigger_log VALUES ('DELETE', old.roll_number, (SELECT number FROM curriculum where cid = old.cid), (select SPI from transcript where roll_number = old.roll_number and semester = (select number from curriculum where cid=old.cid)), (select CPI from transcript where roll_number=old.roll_number and semester = (select number from curriculum where cid=old.cid)));
END;//
delimiter ;

delete from grade18 where roll_number = '180101002' and cid = 'MA101';
delete from grade18 where roll_number = '180101003' and cid = 'CS224';

DELETE FROM grade18;

select * from course18 where c=0;

SHOW TRIGGERS;

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week10/grade18.csv" INTO TABLE grade18
fields terminated by ','
LINES TERMINATED BY '\n';