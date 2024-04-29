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
