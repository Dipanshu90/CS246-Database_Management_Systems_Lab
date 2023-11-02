-- TASK - 01

CREATE DATABASE week08;

USE week08;

-- TASK - 02

CREATE TABLE cs245_student(
	roll_number CHAR(9) PRIMARY KEY,
    name CHAR(100),
    reg_status CHAR(20),
    audit_credit CHAR(10),
    email CHAR(50),
    phone CHAR(8)
);

CREATE TABLE cs245_marks(
	roll_number CHAR(9) PRIMARY KEY, 
    marks INT,
    FOREIGN KEY(roll_number) REFERENCES cs245_student(roll_number)
);

CREATE TABLE cs245_grade(
	roll_number CHAR(9) PRIMARY KEY,
    letter_grade CHAR(2),
    FOREIGN KEY(roll_number) REFERENCES cs245_student(roll_number)
);

CREATE TABLE cs246_student(
	roll_number CHAR(9) PRIMARY KEY,
    name CHAR(100),
    reg_status CHAR(20),
    audit_credit CHAR(10),
    email CHAR(50),
    phone CHAR(8)
);

CREATE TABLE cs246_marks(
	roll_number CHAR(9) PRIMARY KEY, 
    marks INT,
    FOREIGN KEY(roll_number) REFERENCES cs246_student(roll_number)
);

CREATE TABLE cs246_grade(
	roll_number CHAR(9) PRIMARY KEY,
    letter_grade CHAR(2),
    FOREIGN KEY(roll_number) REFERENCES cs246_student(roll_number)
);

-- TASK - 03

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week08/cs245_student.csv" INTO TABLE cs245_student
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week08/cs245_marks.csv" INTO TABLE cs245_marks
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week08/cs245_grade.csv" INTO TABLE cs245_grade
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week08/cs246_student.csv" INTO TABLE cs246_student
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week08/cs246_marks.csv" INTO TABLE cs246_marks
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "/home/mathsuser/Documents/Week08/cs246_grade.csv" INTO TABLE cs246_grade
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- TASK - 04

CREATE USER 'headTA' IDENTIFIED BY 'hdTA123';
CREATE USER 'saradhi' IDENTIFIED BY 'sri123';
CREATE USER 'pbhaduri' IDENTIFIED BY 'pbi123';
CREATE USER 'doaa' IDENTIFIED BY 'doaa123';

-- TASK - 05a

GRANT select, insert, update ON cs245_marks TO headTA;
GRANT select, insert, update ON cs246_marks TO headTA;
GRANT select, update ON cs246_grade TO saradhi;
GRANT select, update ON cs245_grade TO pbhaduri;
GRANT select, insert, update, delete ON cs245_student TO doaa;
GRANT select, insert, update, delete ON cs246_student TO doaa;

-- TASK - 05b- i, ii

-- // AS Head TA
USE week08;

SELECT *
FROM cs246_marks
WHERE roll_number = '270123065';

/*
+-------------+-------+
| roll_number | marks |
+-------------+-------+
| 270123065   |    68 |
+-------------+-------+
*/

DELETE FROM cs245_marks
WHERE roll_number = '210123065';

-- ERROR 1142 (42000): DELETE command denied to user 'headTA'@'localhost' for table 'cs245_marks'

-- TASK - 05b - iii, iv

-- // AS Saradhi

USE week08;

DELETE FROM cs246_grade WHERE roll_number = '270101005';

-- ERROR 1142 (42000): DELETE command denied to user 'saradhi'@'localhost' for table 'cs246_grade'

UPDATE cs246_grade SET letter_grade = 'BC' WHERE roll_number = '270101005';

-- query ok

-- TASK - 05b - v, vi

-- // AS Pbhaduri

USE week08;

UPDATE cs245_marks SET marks = 95 WHERE roll_number = '270101064';

-- ERROR 1142 (42000): UPDATE command denied to user 'pbhaduri'@'localhost' for table 'cs245_marks'

SELECT letter_grade 
FROM cs245_grade 
WHERE roll_number = '270101064';

/*
+--------------+
| letter_grade |
+--------------+
| FP           |
+--------------+
*/

-- TASK - 05b - vii, viii

-- // AS DOAA

USE week08;

INSERT INTO cs245_student VALUES ('270123089', 'Alex', 'Approved', 'Credit', 'alex@protonmail.edu', '960-7830');

-- query ok

INSERT INTO cs245_marks VALUES ('270123089', 67);

-- ERROR 1142 (42000): INSERT command denied to user 'doaa'@'localhost' for table 'cs245_marks'

-- TASK - 05b - ix

-- // AS saradhi

USE week08;

UPDATE cs245_grade SET letter_grade = 'DD' WHERE roll_number = '270101053';

-- ERROR 1142 (42000): UPDATE command denied to user 'saradhi'@'localhost' for table 'cs245_grade'

-- TASK - 05b - x

-- // AS Pbhaduri

USE week08;

DELETE FROM cs246_grade WHERE roll_number IN ('270101004', '270101019', '270101029', '270101039', '270101049', '270101059');

-- ERROR 1142 (42000): DELETE command denied to user 'pbhaduri'@'localhost' for table 'cs246_grade'

-- TASK - 06a

GRANT select(roll_number, name, email) ON  cs245_student TO headTA;
GRANT select(roll_number, name, email) ON  cs246_student TO headTA;
GRANT select(roll_number, name, email) ON  cs245_student TO pbhaduri;
GRANT select(roll_number, name, email) ON  cs246_student TO saradhi;
GRANT select(roll_number, name, reg_status, audit_credit), 
      insert(roll_number, name, reg_status, audit_credit), 
      update(roll_number, name, reg_status, audit_credit) ON  cs246_student TO doaa;

-- TASK - 06b - i, ii, iii, iv

-- // AS headTA

USE week08;

SELECT email, phone
FROM cs245_student
WHERE name = 'Craig Salazar';

-- Error Code: 1143. SELECT command denied to user 'headTA'@'localhost' for column 'phone' in table 'cs245_student'

SELECT roll_number, email
FROM cs245_student
WHERE name = 'Lionel Battle';

/*
+-------------+--------------+
| roll_number | email        |
+-------------+--------------+
| 270101015   | quis@aol.edu |
+-------------+--------------+
*/

DELETE FROM cs246_student WHERE name = 'Jenette Parks';

-- Error Code: 1142. DELETE command denied to user 'headTA'@'localhost' for table 'cs246_student'

UPDATE cs246_student SET email = 'jparks@aol.ca' WHERE name = 'Jenette Parks';

-- Error Code: 1142. UPDATE command denied to user 'headTA'@'localhost' for table 'cs246_student'

-- TASK - 06b - v, vi

-- // AS saradhi

USE week08;

UPDATE cs246_student SET roll_number = '290101051' WHERE roll_number = '270101051';

-- Error Code: 1142. UPDATE command denied to user 'saradhi'@'localhost' for table 'cs246_student'

SELECT email, marks
FROM cs246_student
WHERE name = 'Garrison Donovan';

-- Error Code: 1143. SELECT command denied to user 'saradhi'@'localhost' for column 'marks' in table 'cs246_student'

-- TASK - 06b - vii, viii

-- // AS pbhaduri

USE week08;

UPDATE cs245_student
SET reg_status = 'Approved' AND audit_credit = 'Audit'
WHERE email LIKE '%icloud.couk';

-- Error Code: 1142. UPDATE command denied to user 'pbhaduri'@'localhost' for table 'cs245_student'

SELECT email, letter_grade
FROM cs245_student NATURAL JOIN cs245_grade
WHERE name = 'Benedict Warren';

/*
+--------------------------+--------------+
| email                    | letter_grade |
+--------------------------+--------------+
| posuere.cubilia@yahoo.ca | CD           |
+--------------------------+--------------+
*/

-- TASK - 06b - ix, x

-- // AS doaa

USE week08;

INSERT INTO cs246_student(roll_number, name, reg_status, phone) VALUES ('270123436','Anjali','Pending','844-5838');

-- query ok

UPDATE cs245_student SET audit_credit = 'Audit' WHERE email = 'semper.tellus.id@google.net';

-- query ok

-- TASK - 07a

-- // AS saradhi

USE week08;

CREATE VIEW v7a AS
SELECT roll_number, name, email, letter_grade
FROM cs246_student NATURAL JOIN cs246_grade;

-- Error Code: 1142. CREATE VIEW command denied to user 'saradhi'@'localhost' for table 'v7a'

-- TASK - 07b, 07c

-- // AS headTA 

USE week08;

CREATE VIEW v7b AS
SELECT roll_number, name, email, marks
FROM cs245_student NATURAL JOIN cs245_marks;

-- Error Code: 1142. CREATE VIEW command denied to user 'headTA'@'localhost' for table 'v7b'

CREATE VIEW v7c AS
SELECT roll_number, name, email, letter_grade
FROM cs245_student NATURAL JOIN cs245_grade;

-- Error Code: 1142. CREATE VIEW command denied to user 'headTA'@'localhost' for table 'v7c'

-- TASK - 07d = The given two queries can't be written as the views do not exist.

-- TASK - 08

-- // AS root

USE week08;

GRANT GRANT OPTION ON cs246_grade TO saradhi;

-- // AS saradhi

USE week08;

GRANT SELECT ON cs246_grade TO headTA;

-- // AS headTA

USE week08;

SELECT roll_number, name, email, marks, letter_grade
FROM cs246_student NATURAL JOIN cs246_marks NATURAL JOIN cs246_grade;

/*
+-------------+--------------------+-----------------------------------------+-------+--------------+
| roll_number | name               | email                                   | marks | letter_grade |
+-------------+--------------------+-----------------------------------------+-------+--------------+
| 220101091   | Frances Barnes     | orci@icloud.ca                          |    32 | DD           |
| 220101123   | Kelly Rivas        | curabitur.sed@google.couk               |    67 | BC           |
| 270101001   | Charde Sosa        | eget.massa.suspendisse@aol.couk         |   100 | AS           |
| 270101002   | Sierra Durham      | mauris.suspendisse.aliquet@icloud.edu   |    49 | CD           |
| 270101003   | Benjamin Simpson   | eget.nisi@yahoo.com                     |    52 | CC           |
| 270101004   | Malik Underwood    | ac.arcu@icloud.couk                     |    68 | BC           |
| 270101005   | Willa Carter       | quisque.porttitor@google.couk           |    19 | BC           |
| 270101006   | Tanya Madden       | vulputate@google.couk                   |    38 | DD           |
| 270101007   | Susan Rowe         | venenatis.vel@aol.couk                  |    88 | AB           |
| 270101008   | MacKenzie Meadows  | odio.aliquam@protonmail.com             |    46 | CD           |
| 270101009   | Ashely Holder      | mollis.phasellus@outlook.edu            |    28 | FP           |
| 270101010   | Caesar Cole        | amet.ornare.lectus@aol.com              |    80 | AB           |
| 270101012   | Noelani Burch      | integer.id@outlook.net                  |    57 | CC           |
| 270101013   | Bo Vinson          | ut.erat.sed@hotmail.com                 |    10 | FP           |
| 270101014   | Bernard Johnson    | auctor.odio@icloud.net                  |    18 | FP           |
| 270101015   | Cooper Vaughan     | ut@aol.org                              |    87 | AB           |
| 270101016   | Samuel Wyatt       | maecenas@hotmail.com                    |    87 | AB           |
| 270101017   | Phelan Ferguson    | vitae.odio@hotmail.com                  |   100 | AS           |
| 270101018   | Cain Hendricks     | ligula@google.ca                        |     2 | FP           |
| 270101019   | Ulric Steele       | velit.eget@outlook.com                  |    70 | BB           |
| 270101020   | Shafira Barrett    | ac.mattis@protonmail.com                |    49 | CD           |
| 270101021   | Amethyst Stevens   | vivamus.non@protonmail.org              |    95 | AS           |
| 270101022   | Palmer Sheppard    | donec.at@outlook.ca                     |    67 | BC           |
| 270101023   | Kareem Rodriquez   | suspendisse.tristique@outlook.couk      |    10 | FP           |
| 270101024   | Lee Hickman        | morbi.non@hotmail.edu                   |    78 | BB           |
| 270101025   | Myles Lopez        | sapien.cras@aol.edu                     |    19 | FP           |
| 270101026   | Karen Clements     | molestie.dapibus@yahoo.org              |    95 | AS           |
| 270101027   | Stacey Garza       | lobortis.quis.pede@yahoo.couk           |    78 | BB           |
| 270101028   | Joseph Bolton      | odio.tristique.pharetra@aol.com         |    51 | CC           |
| 270101029   | Medge Howard       | ipsum.suspendisse.sagittis@google.com   |    65 | BC           |
| 270101030   | Palmer Love        | quisque.porttitor@google.edu            |    55 | CC           |
| 270101031   | Mara Stanley       | tempor.lorem@hotmail.net                |    46 | CD           |
| 270101032   | Acton Martinez     | porttitor.interdum@hotmail.net          |    73 | BB           |
| 270101033   | Oren Benson        | aliquet@yahoo.com                       |     4 | FP           |
| 270101034   | Channing Clark     | per.conubia@yahoo.ca                    |    33 | DD           |
| 270101035   | Colette Miles      | nunc.quis@icloud.edu                    |    58 | CC           |
| 270101036   | Sonia Hendrix      | libero.proin.sed@aol.org                |    19 | FP           |
| 270101037   | Cora Holden        | gravida.sit@outlook.org                 |    88 | AB           |
| 270101038   | Germane Stanley    | massa.mauris.vestibulum@outlook.org     |    82 | AB           |
| 270101039   | Marcia Marquez     | orci.phasellus@hotmail.net              |    34 | DD           |
| 270101040   | Katell Steele      | cras.sed@aol.edu                        |   100 | AS           |
| 270101041   | Bert Yang          | libero.proin.mi@google.couk             |    72 | BB           |
| 270101042   | Carla Barron       | nec.urna.suscipit@outlook.edu           |     3 | FP           |
| 270101043   | Josephine Shelton  | erat.semper@icloud.couk                 |    77 | BB           |
| 270101044   | Debra Morrison     | suscipit@yahoo.net                      |    50 | CC           |
| 270101045   | Joan Neal          | eleifend.vitae@outlook.ca               |     6 | FP           |
| 270101046   | Bryar Olson        | felis.adipiscing@google.com             |    61 | BC           |
| 270101047   | Georgia Ewing      | parturient.montes@icloud.couk           |    85 | AB           |
| 270101048   | Mason Nolan        | consectetuer.cursus@yahoo.org           |    12 | FP           |
| 270101049   | Clinton Huber      | lorem.ipsum@google.edu                  |    11 | FP           |
| 270101050   | Cullen Watkins     | neque.sed.dictum@yahoo.org              |    66 | BC           |
| 270101051   | Jenette Parks      | orci.adipiscing@aol.ca                  |    49 | CD           |
| 270101052   | Kamal Landry       | pellentesque.tellus@yahoo.couk          |    75 | BB           |
| 270101053   | Kristen Randall    | sed.congue@protonmail.org               |    86 | AB           |
| 270101054   | Talon Roberson     | elit.elit@icloud.couk                   |    48 | CD           |
| 270101055   | Hayes Bryan        | tincidunt.pede.ac@outlook.net           |    43 | CD           |
| 270101056   | Elliott Chandler   | lectus.pede@google.couk                 |    47 | CD           |
| 270101057   | Laurel Miller      | lorem.eu@hotmail.couk                   |    43 | CD           |
| 270101058   | Brady Perkins      | massa.vestibulum@hotmail.com            |    54 | CC           |
| 270101059   | David Rice         | ante@hotmail.com                        |    51 | CC           |
| 270101060   | Hakeem Brooks      | nibh.dolor@outlook.org                  |    34 | DD           |
| 270101061   | Nigel Conley       | quisque.tincidunt@outlook.ca            |    70 | BB           |
| 270101062   | Anne Cervantes     | diam.dictum@google.com                  |    12 | FP           |
| 270101063   | Tyler Terry        | sit.amet@protonmail.org                 |    55 | CC           |
| 270101064   | Camilla Shepherd   | a@protonmail.couk                       |    66 | BC           |
| 270101065   | Jordan Macias      | enim@icloud.ca                          |    42 | CD           |
| 270101066   | Troy Vance         | nulla.cras@icloud.org                   |    27 | FP           |
| 270101067   | Derek Ellis        | ac.eleifend@google.org                  |     3 | FP           |
| 270101068   | MacKenzie Tate     | vitae.diam.proin@google.edu             |    23 | FP           |
| 270101069   | Cairo Ford         | leo.in@aol.ca                           |    46 | CD           |
| 270101070   | Chiquita Christian | lacus.quisque@outlook.net               |    74 | BB           |
| 270101071   | Irene Walls        | eu@icloud.net                           |    90 | AA           |
| 270101072   | Iola Hooper        | integer.vulputate.risus@icloud.couk     |    17 | FP           |
| 270101073   | Ryder Hawkins      | sodales.mauris.blandit@protonmail.couk  |    50 | CC           |
| 270101074   | Ursa Pacheco       | purus.in@icloud.couk                    |     2 | FP           |
| 270101075   | Gage Buckner       | ac@aol.couk                             |    58 | CC           |
| 270101076   | Alika Kirby        | suspendisse.aliquet@google.org          |    36 | DD           |
| 270101077   | Carson Morin       | nunc.nulla@hotmail.ca                   |    28 | FP           |
| 270101078   | MacKenzie Ashley   | molestie.sodales@hotmail.ca             |    77 | BB           |
| 270101079   | Kimberley Mcintosh | eleifend.cras@yahoo.ca                  |    63 | BC           |
| 270101080   | Natalie Jennings   | mi.fringilla@outlook.edu                |    42 | CD           |
| 270101081   | Finn Weber         | a.scelerisque@aol.couk                  |    70 | BB           |
| 270101082   | Chantale White     | sit@protonmail.com                      |    61 | BC           |
| 270101083   | Lester Vaughan     | lectus.cum@icloud.ca                    |    22 | FP           |
| 270101084   | Alma Dawson        | urna@hotmail.com                        |    96 | AS           |
| 270101085   | Hayley Valentine   | non@hotmail.edu                         |    73 | BB           |
| 270101086   | Sylvester Phillips | phasellus@yahoo.org                     |    16 | FP           |
| 270101087   | Madonna Holman     | a.mi@hotmail.org                        |    38 | DD           |
| 270101088   | Mari Bright        | aliquam.auctor@hotmail.org              |     6 | FP           |
| 270101089   | Matthew Clark      | phasellus.vitae.mauris@hotmail.com      |    43 | CD           |
| 270101090   | Jael Frank         | risus.donec@icloud.ca                   |    29 | FP           |
| 270101091   | Jennifer Norman    | eu@aol.couk                             |    12 | FP           |
| 270101092   | Pamela Herrera     | amet.ante@hotmail.ca                    |    21 | FP           |
| 270101093   | Basil Cohen        | sagittis.placerat.cras@outlook.net      |     3 | FP           |
| 270101094   | Darrel Howe        | tellus@hotmail.couk                     |    98 | AS           |
| 270101095   | Hu Moody           | quisque.ornare@yahoo.org                |    76 | BB           |
| 270101096   | Jackson Andrews    | molestie@google.net                     |    61 | BC           |
| 270101097   | Whilemina Carney   | proin@outlook.couk                      |    38 | DD           |
| 270101098   | Martin Noble       | quis.accumsan@icloud.org                |    14 | FP           |
| 270101099   | Jameson Bush       | quisque@outlook.edu                     |    17 | FP           |
| 270101100   | Nina David         | nisl.quisque@icloud.ca                  |    40 | CD           |
| 270101101   | Hillary O'Neill    | eros.non.enim@google.org                |    94 | AA           |
| 270101102   | Nolan Glover       | dui@google.com                          |    44 | CD           |
| 270101103   | Ashton Beard       | tincidunt.tempus@yahoo.org              |    72 | BB           |
| 270101104   | Fiona Clarke       | congue.turpis@yahoo.couk                |    89 | AB           |
| 270101105   | Kieran Barry       | ultrices.vivamus.rhoncus@protonmail.org |    91 | AA           |
| 270101106   | Nolan Doyle        | enim.nec@outlook.com                    |    77 | BB           |
| 270101107   | Julie Hays         | euismod@google.edu                      |    50 | CC           |
| 270101108   | Alea Landry        | mattis.cras.eget@icloud.com             |    81 | AB           |
| 270101109   | Catherine Noble    | integer.tincidunt@aol.net               |    21 | FP           |
| 270101110   | Montana England    | pharetra.quisque@google.edu             |    48 | CD           |
| 270101111   | Heidi Wiggins      | maecenas.malesuada.fringilla@google.net |    84 | AB           |
| 270101112   | Britanni Beach     | nascetur@google.edu                     |     7 | FP           |
| 270101113   | Colleen Goff       | tellus.phasellus@google.net             |    70 | BB           |
| 270101114   | Halla Baker        | interdum.sed@aol.net                    |    56 | CC           |
| 270101115   | Ginger Mcintyre    | turpis@protonmail.net                   |    60 | BC           |
| 270101116   | Marcia Garza       | malesuada.vel@protonmail.edu            |    90 | AA           |
| 270101117   | Evelyn Ashley      | eu.erat@protonmail.edu                  |    22 | FP           |
| 270101118   | Christen Dale      | sed.auctor.odio@hotmail.couk            |    57 | CC           |
| 270101119   | Evangeline Levy    | donec.tincidunt@aol.couk                |    83 | AB           |
| 270101120   | Summer Fields      | integer.vitae@protonmail.net            |    26 | FP           |
| 270101121   | Abel Mullins       | faucibus.orci@google.com                |    58 | CC           |
| 270101122   | Breanna Vazquez    | penatibus.et.magnis@hotmail.edu         |    28 | FP           |
| 270101123   | Brianna Sellers    | nulla.ante.iaculis@icloud.com           |    89 | AB           |
| 270101124   | Amethyst Nichols   | in@yahoo.ca                             |    14 | FP           |
| 270101125   | Christen Mckee     | cras.eget@icloud.org                    |    33 | DD           |
| 270101126   | Quail Padilla      | auctor.non@aol.org                      |    18 | FP           |
| 270123001   | Gary Lara          | volutpat.nunc@protonmail.com            |    46 | CD           |
| 270123002   | Hedy Campbell      | vel.arcu@hotmail.edu                    |    17 | FP           |
| 270123003   | Kelsie Kent        | amet@aol.com                            |    36 | DD           |
| 270123004   | Kirk Christensen   | morbi.quis@hotmail.org                  |    37 | DD           |
| 270123005   | Byron Wiley        | mi.fringilla@outlook.com                |    47 | CD           |
| 270123006   | Garrison Donovan   | morbi.non@outlook.net                   |    27 | FP           |
| 270123007   | Hammett Chang      | ac@aol.com                              |    55 | CC           |
| 270123008   | Quon Atkinson      | donec@hotmail.edu                       |    62 | BC           |
| 270123009   | Kameko Campbell    | neque.sed.sem@hotmail.couk              |    28 | FP           |
| 270123010   | Macon Waters       | nulla.dignissim@outlook.ca              |    37 | DD           |
| 270123011   | Gretchen Sosa      | per.inceptos@yahoo.couk                 |    80 | AB           |
| 270123012   | Colby Slater       | tincidunt.congue@yahoo.org              |    58 | CC           |
| 270123013   | Mechelle Hayes     | ligula@aol.net                          |    87 | AB           |
| 270123014   | Rose Higgins       | nisi.sem@yahoo.com                      |    39 | DD           |
| 270123015   | Cassandra Ochoa    | libero.proin.mi@google.com              |    75 | BB           |
| 270123016   | Davis Boyle        | consectetuer@google.com                 |    75 | BB           |
| 270123017   | Yasir Rosales      | mauris.blandit.enim@google.edu          |    67 | BC           |
| 270123018   | James Rogers       | placerat@aol.net                        |    64 | BC           |
| 270123019   | Benjamin Walton    | mus@google.org                          |    81 | AB           |
| 270123020   | Dacey Christian    | magna.phasellus@icloud.couk             |    75 | BB           |
| 270123021   | Uriah Chase        | lectus.convallis@protonmail.edu         |    49 | CD           |
| 270123022   | Colton Andrews     | pede.sagittis.augue@aol.net             |    51 | CC           |
| 270123023   | Colby Cohen        | tincidunt.tempus@outlook.couk           |    42 | CD           |
| 270123024   | Kitra Caldwell     | convallis.in@google.ca                  |   100 | AS           |
| 270123025   | Kylynn Mason       | lacinia.orci.consectetuer@google.org    |    94 | AA           |
| 270123026   | Ingrid Mccullough  | non.luctus.sit@icloud.couk              |    53 | CC           |
| 270123027   | Carissa Duncan     | elit@icloud.couk                        |    76 | BB           |
| 270123028   | Hedda Daugherty    | vel.quam@protonmail.net                 |    33 | DD           |
| 270123029   | Sage Clay          | eu.turpis@google.org                    |    43 | CD           |
| 270123030   | Mariko Hinton      | lorem@yahoo.ca                          |    43 | CD           |
| 270123031   | Colleen Russo      | dui.cum.sociis@outlook.couk             |    77 | BB           |
| 270123032   | Helen Watson       | lorem.luctus@yahoo.com                  |    41 | CD           |
| 270123033   | Dante Dodson       | ante.blandit@protonmail.ca              |    97 | AS           |
| 270123034   | Hedwig Mcleod      | ac@aol.edu                              |    98 | AS           |
| 270123036   | Zorita Russo       | in.magna.phasellus@google.net           |    96 | AS           |
| 270123037   | Galvin Valenzuela  | mauris.vestibulum@protonmail.ca         |    26 | FP           |
| 270123038   | Cassidy Taylor     | eu@icloud.net                           |    44 | CD           |
| 270123040   | Zahir Clayton      | enim.nisl@aol.couk                      |    71 | BB           |
| 270123041   | Wylie Green        | nulla@icloud.edu                        |    25 | FP           |
| 270123042   | Kaseem Langley     | magna.cras@yahoo.ca                     |    35 | DD           |
| 270123043   | Lesley Gould       | in.condimentum.donec@outlook.couk       |    54 | CC           |
| 270123044   | Chava Henry        | tellus@aol.org                          |    60 | BC           |
| 270123045   | Andrew Ewing       | habitant.morbi@outlook.edu              |    86 | AB           |
| 270123046   | Adrian Martin      | lobortis@aol.com                        |    53 | CC           |
| 270123047   | Alice Sheppard     | elit@protonmail.org                     |    72 | BB           |
| 270123048   | Abraham Jordan     | massa.lobortis@icloud.net               |    47 | CD           |
| 270123049   | Eaton Waters       | ante.ipsum@icloud.org                   |     3 | FP           |
| 270123050   | Sarah Soto         | nascetur.ridiculus@hotmail.edu          |    31 | DD           |
| 270123051   | Mia Church         | nunc@google.edu                         |    42 | CD           |
| 270123052   | Madeson Kennedy    | convallis.convallis.dolor@yahoo.ca      |    78 | BB           |
| 270123053   | Keane Foley        | in.ornare@protonmail.org                |    90 | AA           |
| 270123054   | Autumn Riley       | a.felis.ullamcorper@outlook.ca          |    68 | BC           |
| 270123055   | Fulton Saunders    | semper.egestas@hotmail.com              |    68 | BC           |
| 270123056   | Clark Brown        | sed@google.net                          |    43 | CD           |
| 270123057   | Elijah Austin      | fusce.aliquam.enim@yahoo.org            |    20 | FP           |
| 270123058   | Jael Brewer        | quisque.fringilla@google.ca             |    73 | BB           |
| 270123059   | Timothy Flynn      | magnis.dis@hotmail.edu                  |    92 | AA           |
| 270123060   | Cassidy Frank      | urna.convallis.erat@icloud.ca           |    96 | AS           |
| 270123062   | Phelan Patrick     | sit.amet@google.edu                     |    74 | BB           |
| 270123065   | Erin Howell        | ornare@outlook.com                      |    68 | BC           |
| 270123066   | Sean Hubbard       | ut@icloud.org                           |    27 | FP           |
| 270123067   | Madaline Gillespie | urna@aol.com                            |    83 | AB           |
| 270123068   | Geraldine Daniel   | molestie.sodales@protonmail.edu         |    12 | FP           |
| 270123069   | August Walls       | non.sollicitudin.a@hotmail.com          |    92 | AA           |
| 270123070   | Amos Sargent       | in@icloud.net                           |    90 | AA           |
| 270123071   | Briar Bond         | malesuada.ut.sem@outlook.edu            |     4 | FP           |
| 270123072   | Kirsten Schmidt    | nulla.cras.eu@outlook.org               |    59 | CC           |
| 270123073   | Nora Adkins        | tristique@hotmail.net                   |    66 | BC           |
| 270123074   | Kuame Fuentes      | justo.proin@aol.org                     |    42 | CD           |
| 270123075   | Forrest William    | eu.tempor.erat@google.ca                |    38 | DD           |
| 270123076   | Joelle Perkins     | eu.dolor@aol.ca                         |    38 | DD           |
| 270123077   | Darrel Romero      | dui.nec@icloud.couk                     |    88 | AB           |
| 270123078   | George Carey       | tempor.diam@google.com                  |    35 | DD           |
| 270123079   | Ezra Mclaughlin    | nec.imperdiet@hotmail.com               |    93 | AA           |
| 270123080   | Charlotte Taylor   | quam.vel@yahoo.ca                       |    25 | FP           |
| 270123081   | Frances Armstrong  | nisi.a.odio@hotmail.ca                  |    78 | BB           |
| 270123082   | Amela Powell       | imperdiet.erat.nonummy@hotmail.couk     |    43 | CD           |
| 270123083   | Leroy Sharpe       | eget.venenatis.a@outlook.net            |    87 | AB           |
| 270123084   | Hyatt Hayden       | sociis.natoque.penatibus@icloud.net     |    15 | FP           |
+-------------+--------------------+-----------------------------------------+-------+--------------+
*/

-- TASK - 09a

-- // AS saradhi

USE week08;

REVOKE SELECT ON cs246_grade FROM headTA;

-- TASK - 09b

-- // AS headTA

USE week08;

SELECT roll_number, name, email, marks, letter_grade
FROM cs246_student NATURAL JOIN cs246_marks NATURAL JOIN cs246_grade;

-- Error Code: 1142. SELECT command denied to user 'headTA'@'localhost' for table 'cs246_grade'

-- TASK - 09c

-- // AS doaa

USE week08;

REVOKE select(roll_number, name, reg_status, audit_credit),
	   insert(roll_number, name, reg_status, audit_credit), 
       update(roll_number, name, reg_status, audit_credit) ON cs246_student FROM doaa;
       
-- Error Code: 1142. GRANT command denied to user 'doaa'@'localhost' for table 'cs246_student'

-- TASK - 09d

-- // AS root

USE week08;

REVOKE select(roll_number, name, email) ON  cs245_student FROM headTA;
REVOKE select(roll_number, name, email) ON  cs246_student FROM headTA;
REVOKE select(roll_number, name, email) ON  cs245_student FROM pbhaduri;
REVOKE select(roll_number, name, email) ON  cs246_student FROM saradhi;
REVOKE select(roll_number, name, reg_status, audit_credit), 
      insert(roll_number, name, reg_status, audit_credit), 
      update(roll_number, name, reg_status, audit_credit) ON  cs246_student FROM doaa;

-- TASK - 09e
      
REVOKE select, insert, update ON cs245_marks FROM headTA;
REVOKE select, insert, update ON cs246_marks FROM headTA;
REVOKE select, update ON cs246_grade FROM saradhi;
REVOKE select, update ON cs245_grade FROM pbhaduri;
REVOKE select, insert, update, delete ON cs245_student FROM doaa;
REVOKE select, insert, update, delete ON cs246_student FROM doaa; 

-- TASK - 10

-- // AS root

DROP USER headTA;
DROP USER saradhi;
DROP USER pbhaduri;
DROP USER doaa;

SELECT USER FROM mysql.user;

/*
+------------------+
| USER             |
+------------------+
| ayushkumar       |
| ayushkumar       |
| debian-sys-maint |
| mysql.session    |
| mysql.sys        |
| phpmyadmin       |
| root             |
+------------------+
*/

-- this query doesn't contain any of the user we created in this assignment, hence those users are deleted.
