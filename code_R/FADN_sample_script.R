# Gets (public) FADN data from the web, reads csv's and converts 
#  them to RData files (as well as giving vars descriptive names), 
#  and loads all of them into memory as separate objects (merging
#  can proceed from there as needed)

library(data.table)

source('D:/Data/data_FADN_PUBLIC/code_R/getFADN.R')
source('D:/Data/data_FADN_PUBLIC/code_R/readFADN.R')
source('D:/Data/data_FADN_PUBLIC/code_R/loadFADN.R')