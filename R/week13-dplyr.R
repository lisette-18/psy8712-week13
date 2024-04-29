#Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(keyring)
library(RMariaDB)
library(tidyverse)

#Data Import and Cleaning
conn <- dbConnect(MariaDB(), #use dbConnect as required by class
                  user="horne146",
                  password=key_get("latis-mysql","horne146"),
                  host="mysql-prod5.oit.umn.edu",
                  port=3306,
                  ssl.ca = "mysql_hotel_umn_20220728_interm.cer")

show_dbs <- dbGetQuery(conn, "SHOW DATABASES;") #show databases present
dbExecute(conn, "USE cla_tntlab;")

employees_tbl <- dbGetQuery(conn, "SELECT * FROM datascience_employees;") %>% 
  as_tibble() #using dbGetQuery and as_tibble to create tibble
testscores_tbl <- dbGetQuery(conn, "SELECT * FROM datascience_testscores;") %>%
  as_tibble() #using dbGetQuery and as_tibble to create tibble
offices_tbl <- dbGetQuery(conn, "SELECT * FROM datascience_offices;") %>%
  as_tibble() #using dbGetQuery and as_tibble to create tibble

##CSV Files
write_csv(employees_tbl, "../data/employees.csv") #use write_csv in order to convert tibbles to csv files to be read in
write_csv(testcores_tbl, "../data/testscores.csv") #use write_csv in order to convert tibbles to csv files to be read in
write_csv(offices_tbl, "../data/offices.csv") #use write_csv in order to convert tibbles to csv files to be read in

week13_tbl <- tibble(employees_tbl %>% #use tibble() to create as a tibble
                       inner_join(testscores_tbl, by = "employee_id") %>% #inner_join to connect testscores to the employees tbl
                       full_join(offices_tbl, by = "city")) #use full_join to combine based on the previous two databases being combined

write_csv(week13_tbl, "../out/week13.csv")
