rm(list=ls())

#-------- Define import function -------------------------------------
getFADN <- 
  function(file,
           url=
             "http://ec.europa.eu/agriculture/rica//database/reports",
           origdata = "D://Data//data_FADN_PUBLIC//OrigData"
           ) {


    # Download the file to a temp file    
    temp <- tempfile()
    zip.url  <- file.path(url,paste(file,".zip", sep=""))
    download.file(zip.url,temp)
  
    # Unzip it to a subdir of origdata, creating it if necessary
    exdir <- file.path(origdata,file,fsep="//") 
    try(dir.create(exdir, showWarnings = F))
    unzip(temp, exdir=exdir, overwrite = T)

    # Unlink from temp file
    unlink(temp)

}
#-------- End of function def ----------------------------------------


# Run the function for all the zip files in the "most recent" table
#  on http://ec.europa.eu/agriculture/rica//database/reports 
# At the time of writing, there were 15 datafiles in this table.

getFADN(file="YEAR_A24")              # 1
getFADN(file="YEAR_A24_TF8")          # 2
getFADN(file="YEAR_A24_TF14")         # 3
getFADN(file="YEAR_A24_A28_A29_A30")  # 4
getFADN(file="YEAR_A24_ES6")          # 5
getFADN(file="YEAR_A24_A26")          # 6
getFADN(file="YEAR_A24_A39")          # 7
getFADN(file="YEAR_A24_ES6_TF8")      # 8
getFADN(file="YEAR_A24_ES6_TF14")     # 9
getFADN(file="YEAR_A24_A1")           # 10
getFADN(file="YEAR_A24_A1_TF8")       # 11
getFADN(file="YEAR_A24_A1_TF14")      # 12
getFADN(file="YEAR_A24_A1_ES6")       # 13
getFADN(file="YEAR_A24_A26")          # 14
getFADN(file="YEAR_A24_ES6_TF8")      # 15