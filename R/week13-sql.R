#Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(RMariaDB)
library(keyring)

#Data Import and Cleaning
conn <- dbConnect(MariaDB(), #using dbConnect as required by lecture
                  user="horne146",
                  password=key_get("latis-mysql","horne146"),
                  host="mysql-prod5.oit.umn.edu",
                  port=3306,
                  ssl.ca = '../mysql_hotel_umn_20220728_interm.cer')
dbExecute(conn, "USE cla_tntlab;")

#Analysis 
query1 <- dbGetQuery(conn, "SELECT COUNT(*) AS total_managers 
FROM datascience_employee AS e 
INNER JOIN datascience_testscore AS t ON e.employee_id = t.employee_id 
AND t.test_Score IS NOT NULL;")

#use SELECT and COUNT to get number of managers
#pull FROM the datascience_employees database
#INNER JOIN to join two tables 
#to get only those who have test scores from table 2

query1

query2 <- dbGetQuery(conn, "SELECT COUNT(DISTINCT e.employee_id) AS unique_managers 
FROM datascience_employees AS e
INNER JOIN datascience_testscore AS t ON e.employee_id = t.employee_id 
AND t.test_Score IS NOT NULL;") 

#use SELECT, COUNT, DISTINCE to get only employees who have unique id numbers 
#FROM employees database
#INNER JOIN to join tables
#to get only those who have test scores from table 2

query2

query3 <- dbGetQuery(conn, "SELECT COUNT(e.employee_id) AS n_managers 
FROM datascience_employees AS e 
INNER JOIN datascience_testscores AS t ON e.employee_id = t.employee_id 
WHERE t.test_score IS NOT NULL
AND manager_hire = 'N'
GROUP BY city;") 

#SELECT COUNT to get number of managers
#FROM to pull from employees database
#INNER JOIN to join to another table
#IS NOT NULL to get only those who have test scores from table 2
#AND to get only those who were not hired as a manager
#GROUP BY #group by function to organize by location 

query3

query4 <- dbGetQuery(conn, "SELECT performance_group 
AVG(yrs_employed) AS mean_yrs 
STDDEV(yrs_employed) AS sd_yrs 
FROM datascience_employees AS e 
INNER JOIN datascience_testscore AS t ON e.employee_id = t.employee_id  
WHERE t.test_score IS NOT NULL 
GROUP BY performance_group;") 

#SELECT the performance group
#use AVG to get average of yrs employed
#use STDDEV to get standard deviation of yrs employed
#FROM employee database
#INNER JOIN to join with test score database
#IS NOT NULL to get only those who have test scores from table 2
#GROUP BY function to organize by performance group

query4

query5 <- dbGetQuery(conn, "SELECT e.employee_id AS employee_id, t.test_score AS test_score, offices.type AS type 
FROM datascience_employees AS e 
INNER JOIN datascience_testscore AS t ON e.employee_id = t_employee_id
INNER JOIN datascience_offices AS offcies on e.city = offices.office
WHERE t.test_Score IS NOT NULL
ORDER BY offices.type 
t.test_score DESC;") 

#use select to get those variables we want
#FROM employees database
#INNER JOIN to join the two tibbles by common column
#IS NOT NULL to get only those who have test scores from table 2
#ORDER BY location
#DESC organize by descending test scores

View(query5) #easier to see with view