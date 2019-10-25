library(rlpi)
####################################################################
## Collect arguments
args <- commandArgs(TRUE)
## Default setting when no arguments passed
if(length(args) != 11) {
  args <- c("--help")
}
 
## Help section
if("--help" %in% args) {
  cat("
      The R Script
      Arguments:
      group
      subgroup
      state
      statusauth
      status
      bootstrap
      referenceyear
      startyear
      plotmax
      input
      output
      --help
      ")
  q(save="no")
}
groupArg <- args[1]
subGroupArg <- args[2]
stateArg <- args[3]
statusAuthArg <- args[4]
statusArg <- args[5]
bootstrapArg <- args[6]
referenceYearArg <- args[7]
startyearArg <- args[8]
plotMaxArg <- args[9]
inputArg <- args[10]
outputArg <- args[11]
####### values
in_file <- "lpi.csv"
groups <- NULL
subgroups <- NULL
states <- NULL
statusauth <- NULL
statuses <- NULL
bootstrap <- 1000
referenceyear <- 1970
plotmax <- 2015
output <- "output"
startyear <- "X1950"
endyear <- "X2015"
## using numbers or not
## lpi
if(!is.null(inputArg)){
  in_file <- inputArg
}
# output
if(!is.null(outputArg)){
  output <- outputArg
}
outdir <- output
# group
if(!is.null(groupArg) && groupArg != "All"){
  outdir <- paste(outdir, "group-", groupArg, "_", sep="")
  groups <- unlist(strsplit(groupArg, "+", fixed=TRUE)) 
}
# subgroup
if(!is.null(subGroupArg) && subGroupArg != "All"){
  outdir <- paste(outdir, "subgroup-", subGroupArg, "_", sep="")
  subgroups <- unlist(strsplit(subGroupArg, "+", fixed=TRUE))
}
# state
if(!is.null(stateArg) && stateArg != "All"){
  outdir <- paste(outdir, "state-", stateArg, "_", sep="")
  states <- unlist(strsplit(stateArg, "+", fixed=TRUE))
}
# statusauth
if(!is.null(statusAuthArg) && statusAuthArg!= "All"){
  outdir <- paste(outdir, "statusauth-", statusAuthArg, "_", sep="")
  statusauth <- statusAuthArg
}
# status
if(!is.null(statusArg) && statusArg!= "All" ){
  outdir <- paste(outdir, "status-", statusArg, "_", sep="")
  statuses <- unlist(strsplit(statusArg, "+", fixed=TRUE))
}
## bootstrap
if (!is.null(plotMaxArg)){
  bootstrap <- as.numeric(bootstrapArg)
}
#referenceyear
if (!is.null(referenceYearArg) ){
  referenceyear <- as.numeric(referenceYearArg)
}
#plotmax
if ( !is.null(plotMaxArg)){
  plotmax <- as.numeric(plotMaxArg)
  endyear <- paste("X", plotmax, sep = "")
}


if (file.exists(outdir)){
    setwd(outdir)
} else {
    dir.create(outdir, recursive = TRUE)
    setwd(outdir)
}

if ( !is.null(startyearArg)){
  startyear <- paste("X", as.numeric(startyearArg), sep = "")
}


#sprintf ("input='%s', bootstrap=%s, refenreceyear=%s, plotmax=%s",
#          in_file, bootstrap, referenceyear, plotmax)
# read the data
data <- read.csv(in_file, na.strings = "", quote = "\"",sep = ",")
## filter data
if(length(groups) > 0){
  data <- data[data$FunctionalGroup %in% groups,]
  write("Filtering by groups", file="runoutput.txt", append=TRUE)
  write(dim(data), file="runoutput.txt", append=TRUE)
}
if(length(subgroups) > 0){
  data <- data[data$FunctionalSubGroup %in% subgroups,]
  write("Filtering by subgroups", file="runoutput.txt", append=TRUE)
  write(dim(data), file="runoutput.txt", append=TRUE)  
}
if(length(states) > 0){
  data <- data[data$State %in% states,]
  write("Filtering by states", file="runoutput.txt", append=TRUE)
  write(dim(data), file="runoutput.txt", append=TRUE)
}
statusauth_str <- paste(statusauth, "Status", sep="")
write(statusauth_str, file="runoutput.txt", append=TRUE)
write(statuses, file="runoutput.txt", append=TRUE)
write(length(statuses), file="runoutput.txt", append=TRUE)
if(length(statuses) > 0){
  data <- data[unlist(data[statusauth_str]) %in% statuses,]
  write("Filtering by status", file="runoutput.txt", append=TRUE)
  write(dim(data), file="runoutput.txt", append=TRUE)	
}

if(dim(data)[1] == 0){
  print ("Empty data. Quit")
  q(save = "no", status=4)
}


#write.table(data, file=paste(outdir, "lpi_input.csv", sep="/"), sep = ",")
write.table(data, "lpi_input.csv", sep = ",")

taxonlist <- as.vector(data[['TaxonID']])
uniqueTaxonIDs <- unique(taxonlist)
write (paste("\nTaxonIDs:", uniqueTaxonIDs), file="runoutput.txt", append=TRUE) 
if ( length(uniqueTaxonIDs) < 3 ) {
  print ("The number of taxa is less than 3. Quit!!!!")
  q(save="no", status=1)
}
#### run with refernceyear, referenceyear+10, referenceyear + 20, referneceyear+30
ref_years <- c(referenceyear, referenceyear+5, referenceyear+10, referenceyear+15)
for (year in ref_years){
  #### check whether it has enough 3 taxa
  dataThisYear <- data[!is.na(data[paste("X", year, sep="")]),]
  if ( length(unique(as.vector(dataThisYear[['TaxonID']] ) )) < 3 ) { next }
  yfname <- paste("nesp", year, sep="_")
  ytitle <- paste("lpi", year, sep="_")
  # old rlpi create infile
  #infile_name <- create_infile(data, name=yfname)
  # new version of rlpi
  #index_vector = rep(FALSE, nrow(data))
  #index_vector[1:100] = TRUE
  #infile_name <- create_infile(data, index_vector=index_vector, name=yfname, start_col_name="X1950", end_col_name="X2015")
  infile_name <- create_infile(data, name=yfname, start_col_name=startyear, end_col_name=endyear)
  nesp_lpi<-LPIMain(infile_name, REF_YEAR=year, PLOT_MAX=plotmax,
                    BOOT_STRAP_SIZE=bootstrap, VERBOSE=TRUE, goParallel=TRUE, title=ytitle)
  ggplot_lpi(nesp_lpi)
}

