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

#Analysis

t_managers <- week13_tbl %>%
  summarize(n()) #total number of managers

t_managers

u_managers <- week13_tbl %>%
  select(employee_id) %>% #selecting employee ids
  unique() %>% #getting the unique IDs to avoid repetition 
  nrow() #total number of unique managers

u_managers

non_managerhire <- week13_tbl %>% 
  filter(manager_hire == "N") %>% #filter for those who were not hired as a manager first
  group_by(city) %>% #group by the locatio in which they work
  summarize(n()) #number of managers split by location, but only include those who were not originally hired as managers.

non_managerhire

employment_performance <- week13_tbl %>%
  group_by(performance_group) %>% #using group_by to organize data into groups based on performance level
  summarize(mean = mean(yrs_employed), #summarize the average yrs people have been employed
            sd = sd(yrs_employed)) #summarize the sd of the yrs people have been employed

employment_performance

summary <- week13_tbl %>%
  select(type, employee_id, test_score) %>% #using the select function to pick the three variables required
  arrange(type, desc(test_score)) #use function arrange to organize by location and desc() to make test scores in decending order

summary