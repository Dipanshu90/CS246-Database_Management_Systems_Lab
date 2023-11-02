import mysql.connector
import sys

roll_number = sys.argv[1]

mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="root@123",
  database="week09"
)

mycursor = mydb.cursor()

sql = "SELECT name FROM student18 WHERE roll_number = %s"
val = (roll_number, )

mycursor.execute(sql, val)

name = mycursor.fetchone()

print("Indian Institutte of Technology Guwahati\n")

print("Programme Duration: 4 years                      Semesters:Eight(8)\n")

print("Name:  " + name[0] + "                      Roll Number: " + roll_number + "\n")

print("{}      {} \t {:<50} \t {}".format("Semester","Course","CourseName","Cr"))

sql = "SELECT semester, c.cid, name, letter_grade FROM course18 as c, grade18 WHERE c.cid = grade18.cid AND roll_number=%s ORDER BY semester, cid"
val = (roll_number, )
mycursor.execute(sql, val)

data = mycursor.fetchall()

i=1
for x in data:
	if x[0]>i:
		i+=1
		print("")
	print("{} \t {:>10} \t {:<50} \t {}".format(str(x[0]),x[1],x[2],x[3]))
print("")


for i in range(1,9):

	sql = "SELECT SUM(CASE WHEN letter_grade = 'AA' THEN 10*c WHEN letter_grade = 'AB' THEN 9*c WHEN letter_grade = 'BB' THEN 8*c WHEN letter_grade = 'BC' THEN 7*c WHEN letter_grade = 'CC' THEN 6*c WHEN letter_grade = 'CD' THEN 5*c WHEN letter_grade = 'DD' THEN 4*c END)/SUM(c) AS spi FROM course18, grade18 WHERE course18.cid = grade18.cid AND roll_number=%s AND semester=%s ORDER BY course18.cid"
	val = (roll_number, i)
	mycursor.execute(sql, val)

	sem_data = mycursor.fetchall()

	print("Semester: " + str(i) + " SPI: " + str(round(sem_data[0][0],2)))

sql = "SELECT SUM(CASE WHEN letter_grade = 'AA' THEN 10*c WHEN letter_grade = 'AB' THEN 9*c WHEN letter_grade = 'BB' THEN 8*c WHEN letter_grade = 'BC' THEN 7*c WHEN letter_grade = 'CC' THEN 6*c WHEN letter_grade = 'CD' THEN 5*c WHEN letter_grade = 'DD' THEN 4*c END)/SUM(c) AS spi FROM course18, grade18 WHERE course18.cid = grade18.cid AND roll_number=%s ORDER BY course18.cid"
val = (roll_number, )
mycursor.execute(sql, val)

whole_data = mycursor.fetchall()
print("CPI: "+ str(round(whole_data[0][0],2)) + '\n')

print("The core courses are: ")

sql = "SELECT cid FROM curriculum WHERE number=1 AND cid != 'HS101' UNION SELECT cid FROM curriculum WHERE number=2 AND cid != 'SA1xx' UNION SELECT cid FROM curriculum WHERE number=3 AND cid NOT IN ('SA2xx', 'HS200') UNION SELECT cid FROM curriculum WHERE number=4 AND cid NOT IN ('HS1xx', 'SA3xx') AND cid NOT LIKE '%M' UNION SELECT cid FROM curriculum WHERE number=5 AND cid NOT IN ('SA4xx') AND cid NOT LIKE '%M' UNION SELECT cid FROM curriculum WHERE number=6 AND cid NOT LIKE '%M' UNION SELECT cid FROM curriculum WHERE number=7 AND cid = 'CS498' UNION SELECT cid FROM curriculum WHERE number=8 AND cid = 'CS499'"

mycursor.execute(sql)

core_courses = mycursor.fetchall()

for x in core_courses:
	print(x[0])

print("")

for sem in range(1,9):
	sql = "SELECT COUNT(DISTINCT cid) FROM t" + str(sem)+ " WHERE cid NOT IN (SELECT cid FROM grade18 WHERE roll_number = %s)"
	val = (roll_number,)
	mycursor.execute(sql,val)
	count = mycursor.fetchall()

	if count[0][0] > 0:
		print("Some Core courses not taken in semester "+ str(sem))
	else:
		print("All Core Courses taken in semester "+ str(sem))

print("")

sql = "SELECT COUNT(letter_grade) FROM grade18 WHERE roll_number = %s AND letter_grade IN ('FA', 'FP')" 
val = (roll_number, )
mycursor.execute(sql, val)

pass_fail = mycursor.fetchone()

if pass_fail[0] == 0:
	print("All Courses have been passed\n")
else:
	print("Some Courses have not been passed\n")

sql = "SELECT COUNT(letter_grade) FROM grade18 WHERE cid LIKE 'SA%' AND roll_number = %s AND letter_grade IN ('FA', 'FP')" 
val = (roll_number, )
mycursor.execute(sql, val)

pass_fail = mycursor.fetchone()

if pass_fail[0] == 0:
	print("All SA Courses have been passed\n")
else:
	print("Some Courses have not been passed\n")

for sem in range(1,9):
	sql = "SELECT COUNT(cid) FROM curriculum WHERE number = %s AND cid LIKE 'SA%'"
	val = (sem, )
	mycursor.execute(sql, val)
	sa_courses = mycursor.fetchone()

	if sa_courses[0] == 0:
		print("No SA Courses prescribed in semester "+ str(sem))
	else: 
		sql = "SELECT COUNT(DISTINCT cid) FROM tSA WHERE number=%s AND cid NOT IN (SELECT CASE WHEN cid LIKE 'SA1%' THEN 'SA1xx' WHEN cid LIKE 'SA2%' THEN 'SA2xx' WHEN cid LIKE 'SA3%' THEN 'SA3xx' WHEN cid LIKE 'SA4%' THEN 'SA4xx' END AS sa_courses FROM grade18 WHERE cid LIKE 'SA%' AND roll_number = %s);"
		val = (sem, roll_number)
		mycursor.execute(sql, val)
		sa_courses = mycursor.fetchone()
		
		if sa_courses[0] == 0:
			print("All prescribed SA Courses taken in semester "+ str(sem))
		else: 
			print("Some SA courses not taken in semester "+ str(sem))


		




