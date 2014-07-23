rm(list=ls())

library("data.table")

#-------- Define import function -------------------------------------
readFADN <- 
  function(file,
           sub, 
           origdata = "D://Data//data_FADN_PUBLIC//OrigData"
           ) {

     if (missing(sub))
       stop("Please specify SGM or SO for the <sub> argument")
     
    exdir <-  file.path(origdata,file,sub,fsep="//")
    full.filepath <- file.path(exdir,
                               paste(file,".csv",sep=""),
                               fsep="//") 
    data <- data.table(read.csv(full.filepath,sep=";"))
    
    
    # Rename with description (spaces and other replace with ".")
    setnames(data, FADN.code.key[,code], 
             FADN.code.key[,FADNlookup(code)]
            )
    
    
    save(list= c("data","FADN.code.key", "FADNlookup"),
         file= file.path(exdir,
                         paste(file,
                               ".RData",
                               sep=""
                              ),
                         fsep="//"
                        )
        )
    
#    return(data)


}
#-------- End of function def ----------------------------------------

# Define FADN code key
source("D://Data//data_FADN_PUBLIC//code_R//FADN.code.key.R")
View(FADN.code.key)

# Run the function for all the zip files in the "most recent" table
#  on http://ec.europa.eu/agriculture/rica//database/reports 
# At the time of writing, there were 15 datafiles in this table.

readFADN(file="YEAR_A24","SGM")              # 1
readFADN(file="YEAR_A24","SO")              # 1

readFADN(file="YEAR_A24_TF8","SGM")          # 2
readFADN(file="YEAR_A24_TF8","SO")          # 2

readFADN(file="YEAR_A24_TF14","SGM")         # 3
readFADN(file="YEAR_A24_TF14","SO")         # 3

readFADN(file="YEAR_A24_A28_A29_A30","SGM")  # 4
readFADN(file="YEAR_A24_A28_A29_A30","SO")  # 4

readFADN(file="YEAR_A24_ES6","SGM")          # 5
readFADN(file="YEAR_A24_ES6","SO")          # 5

readFADN(file="YEAR_A24_A26","SGM")          # 6
readFADN(file="YEAR_A24_A26","SO")          # 6

readFADN(file="YEAR_A24_A39","SGM")          # 7
readFADN(file="YEAR_A24_A39","SO")          # 7

readFADN(file="YEAR_A24_ES6_TF8","SGM")      # 8
readFADN(file="YEAR_A24_ES6_TF8","SO")      # 8

readFADN(file="YEAR_A24_ES6_TF14","SGM")     # 9
readFADN(file="YEAR_A24_ES6_TF14","SO")     # 9

readFADN(file="YEAR_A24_A1","SGM")           # 10
readFADN(file="YEAR_A24_A1","SO")           # 10

readFADN(file="YEAR_A24_A1_TF8","SGM")       # 11
readFADN(file="YEAR_A24_A1_TF8","SO")       # 11

readFADN(file="YEAR_A24_A1_TF14","SGM")      # 12
readFADN(file="YEAR_A24_A1_TF14","SO")      # 12

readFADN(file="YEAR_A24_A1_ES6","SGM")       # 13
readFADN(file="YEAR_A24_A1_ES6","SO")       # 13

readFADN(file="YEAR_A24_A26","SGM")          # 14
readFADN(file="YEAR_A24_A26","SO")          # 14

readFADN(file="YEAR_A24_ES6_TF8","SGM")      # 15
readFADN(file="YEAR_A24_ES6_TF8","SO")      # 15


rm(list=ls())

print("Refer to FADN.code.key for code meanings.")
print("Use FADNlookup to return description given a code.")
print("FADNlookup also works in reverse with (,reverse=T).")