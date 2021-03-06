#Version 1.0 - Original release with four calls to plot_GAM...
#Versoin 1.1 - Plot_GAMMRaster changed to make one four panel plot, so call to that function changed in here - EAH 12/24/15 
#uncomment for batch mode. Comment for testing
#Start "cd C:\path\bin\Rgui.exe CMD BATCH C:\path\WhaleWatch_Run.r"

#Set working directories
#setwd("/Users/evan.howell/lib/git/WhaleWatch") #Change this when making live
#setwd("/Users/ehowell/git/WhaleWatch") #Change this when making live
#setwd("~/Dropbox/Documents/R/Blue_whales/Operational") #Change this when making live
path = getwd()
codedir = paste(path,"/Code",sep="")
modeldir = paste(path,"/ModelRuns",sep="")
datadir = paste(path, "/Data",sep="")

#Load global functions used in process
source("Code/load_Functions.R")

#Set up logfile
templogfile = "logs/templog"
logfile <- file(templogfile, open="wt")
sink(logfile, type=c("output","message")) #set all output to templog

#set up initial log with helpful information
logprint("Starting operations to make WhaleWatch product")
  
if (file.exists(paste(datadir,"/bathy.txt",sep=""))){
	logprint("Bathymetry data present, moving to next command")
}else{
  logprint("Bathymetry data does not exist, creating bathymetry file")
  get_Bathymetry()
}

#Now run function to get environmental data parameters
logprint("Running function get_EnvData")
factorfile = get_EnvData()
logprint("Finished running function get_EnvData")

#Now run function to get predictions from the 40 models
logprint("Running function predict_GAMM")
predictvec = predict_GAMM(factorfile)
logprint("Finished running function predict_GAMM")

#Now run function to make the plots
logprint("Running function plot_GAMMRaster")

#Make four panel plot
plot_GAMMRaster(predictvec)
logprint("Finished running function plot_GAMMRaster")

#Close up temp logfile, then rename logfile from templog to dated logfile
newlogfile = paste("logs/log",format(Sys.time(), "%Y-%m-%dT%H-%M-%S"),".log",sep="")

logprint(paste("Closing temporary logfile and renaming to file ", newlogfile))

logprint("DONE!!!! Check Images, Data, and Predictions directories")
close(logfile)

file.rename(templogfile, newlogfile)
#sink(type = c("output", "message")) #reset all messages to STDOUT and STDERR
