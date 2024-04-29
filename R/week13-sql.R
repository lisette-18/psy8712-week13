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
query1 <- dbGetQuery(conn, "SELECT COUNT(*) AS total_managers #use select and count to get number of managers
FROM datascience_employee AS e #pull from the datascience_employees database
INNER JOIN datascience_testscore AS t ON e.employee_id = t_employee_id #to join two tables 
AND t.test_Score IS NOT NULL;") #to get only those who have test scores from table 2

query1

query2 <- dbGetQuery(conn, "SELECT COUNT(DISTINCT e.employee_id) AS unique_managers #use select, count, distinct to get only employees who have unique id numbers 
FROM datascience_employees AS e #from employees database
JOIN datascience_testscore AS t ON e.employee_id = t_employee_id #to join tables
WHERE t.test_Score IS NOT NULL;") #to get only those who have test scores from table 2

query2

query3 <- dbGetQuery(conn, "SELECT COUNT(city) #to get those based on city location
FROM datascience_employees AS e #to pull from employees database
JOIN datascience_testscores AS t  #to join to another table
WHERE t.test_score IS NOT NULL # #to get only those who have test scores from table 2
AND manager_hire = 'N' #get only those who were not hired as a manager
GROUP BY city;") #group by function to organize by location 

query3

query4 <- dbGetQuery(conn, "SELECT performance_group #select the performance group
AVG(yrs_employed) AS mean_yrs #use AVG to get average of yrs employed
STDDEV(yrs_employed) AS sd_yrs #use STDDEV to get standard deviation of yrs employed
FROM datascience_employees AS e #from employee database
JOIN datascience_testscore AS t #join with test score database
WHERE t.test_score IS NOT NULL #to get only those who have test scores from table 2
GROUP BY performance_group;") #group by function to organize by performance group

query4

query5 <- dbGetQuery(conn, "SELECT o.type, e.employee_id, t.test_score #use select to get those variables we want
FROM datascience_employees AS e #employees database
JOIN datascience_testscore AS t ON e.employee_id = t_employee_id #join the two tibbles by common column
WHERE t.test_Score IS NOT NULL; #to get only those who have test scores from table 2
ORDER BY o.type #order by location
DESC t.test_score;") #organize by decending test scores

query5