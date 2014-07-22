rm(list=ls())

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
    DT <- data.table(read.csv(full.filepath,sep=";"))
    #save(DT,)
    
    return(DT)


}
#-------- End of function def ----------------------------------------

# Define FADN code key
source("D://Data//data_FADN_PUBLIC//code_R//FADN.code.key.R")

# Run the function for all the zip files in the "most recent" table
#  on http://ec.europa.eu/agriculture/rica//database/reports 
# At the time of writing, there were 15 datafiles in this table.

data <- readFADN(file="YEAR_A24","SGM")              # 1
colnames(data)
# Rename with description where possible -- causes error, but works
try(FADN.code.key[,lapply(code, function(x) setnames(data,x, FADNlookup(x)))])
colnames(data)

readFADN(file="YEAR_A24_TF8")          # 2
readFADN(file="YEAR_A24_TF14")         # 3
readFADN(file="YEAR_A24_A28_A29_A30")  # 4
readFADN(file="YEAR_A24_ES6")          # 5
readFADN(file="YEAR_A24_A26")          # 6
readFADN(file="YEAR_A24_A39")          # 7
readFADN(file="YEAR_A24_ES6_TF8")      # 8
readFADN(file="YEAR_A24_ES6_TF14")     # 9
readFADN(file="YEAR_A24_A1")           # 10
readFADN(file="YEAR_A24_A1_TF8")       # 11
readFADN(file="YEAR_A24_A1_TF14")      # 12
readFADN(file="YEAR_A24_A1_ES6")       # 13
readFADN(file="YEAR_A24_A26")          # 14
readFADN(file="YEAR_A24_ES6_TF8")      # 15