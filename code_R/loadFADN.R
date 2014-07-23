rm(list=ls())

library("data.table")


#-------- Define loading function -----------------------------------
loadSINGLE.DATASET <- 
  function(file,
           sub, 
           origdata = "D://Data//data_FADN_PUBLIC//OrigData"
           ) {

     if (missing(sub))
       stop("Please specify SGM or SO for the <sub> argument")
     
    exdir <-  file.path(origdata,file,sub,fsep="//")
    full.filepath <- file.path(exdir,
                               paste(file,".RData",sep=""),
                               fsep="//") 
    # No need for a return() because we load to the global envir
    #   directly
    load(full.filepath, envir=globalenv())
    setkey(data,"year")
}
#-------- End of function def ---------------------------------------



#-------- Define object naming wrapper function ---------------------
loadFADN <- 
  function (datafile) {
    
    # Loads a single dataset and renames the data.table s.t. all 
    # datasets can be loaded simultaneously
    dataname <- gsub("_",".",datafile)

    dataname.SGM <- paste(dataname,"SGM",sep=".")
    loadSINGLE.DATASET(file=datafile,"SGM")
    assign(dataname.SGM, data, envir=globalenv())
    
    dataname.SO  <- paste(dataname,"SO" ,sep=".")
    loadSINGLE.DATASET(file=datafile,"SO")
    assign(dataname.SO, data, envir=globalenv())
}

# Now make function accept a vector argument
loadFADN <- Vectorize(loadFADN)

#-------- End of function def ---------------------------------------


# Get list of datasets to load
files.to.load <- dir("D://Data//data_FADN_PUBLIC//OrigData//")


# Apply loading function to all (currently give you two datasets
#  per dataset code... an historical SGM based dataset, and a SO
#  based one which starts in 2004). Done this way because the
#  fundamental difference in sampling methodology makes it important
#  to explicity merge the years at the start of any analyis AFTER
#  CONSIDERING THE APPROPRIATENESS OF DOING SO!
loadFADN(files.to.load)


# Last dataset loaded left a duplicate in memory.
rm(data)


# The datasets are all data.tables(). We can see some info on them
#  with the following
#View(tables(silent=T))

# ... but it's nicer to suppress the COLS listing (there's a lot of 
#       columns!)
#tables(silent=T)[,!"COLS", with=F]

# Or to put info in the RStudio Viewer window, handy when sourcing 
#  this script with Echo=F (the default)
View(tables(silent=T)[,!"COLS", with=F]) 

