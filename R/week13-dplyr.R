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
