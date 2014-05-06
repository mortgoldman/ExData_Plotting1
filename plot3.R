## Exploratory data analysis -- Week 1 project
##
## Mort Goldman

## This script expects the household power consumption file to already have been 
## installed in working directory.  If not it produces an error.  If the file is 
## in place and has the expected format, then this script produces the "plot1.png"
## figure showing frequency of Global Active Power for the specified days. 

## some very basic error handling:  just make sure file placed in expected location
housePowConsFN <- "household_power_consumption.txt"
if (!file.exists(housePowConsFN)) {
  stop(cat("please place file '", housePowConsFN, "' in 'ElecPower' folder",sep=""))
} 

## now read in the data:

## Note there may be concerns with some systems reading full file.
## This is NOT an issue for my system (as I have 16GB RAM ...)
## Actual memory used by full dataset is about 150MB, so no problem (for me).
## Read takes about 10 seconds on my PC, so again, not worth optimizing, but could
## be more significant for others, and there are plenty of ways to tune if desired.
## 
hpcClasses <- c(rep("character",2),rep("numeric",7))
hPC <- read.table (housePowConsFN, header=TRUE,
                   sep=";",na.strings=c("?"), quote="",
                   colClasses=hpcClasses,
                   comment.char="",
                   nrows=2075259)

## take a quick look at what we have
## str(householdPowerConsumption)
## summary(householdPowerConsumption)
## head(householdPowerConsumption)

## convert date strings into dates:
hPC$dt <- as.Date(hPC$Date,"%d/%m/%Y")

## and then select only the dates from 2007-02-01 and 2007-02-02 
hPC <- hPC[hPC$dt == as.Date("2007-02-01") |
           hPC$dt == as.Date("2007-02-02"), ]

## nrow(hPC) # this gets us to 2,880 rows

## convert date/time characters into R date/time class
hPC$dttm <- with(hPC,strptime(paste(Date,Time),"%d/%m/%Y %H:%M:%S"))

##########################################################
## and finally produce the requested chart and save as PNG:

png(filename="plot3.png", width=480,height=480,units="px")

## seems a tad hokey to use the Sub_metering_1 as the "dummy" plot, 
##   but it works to set the Y-axis scale correctly ...
##   there's likely a cleaner way to do this, but I think this works:
plot(hPC$dttm,hPC$Sub_metering_1, type="n",
     ylab="Energy sub metering",xlab="")
points(hPC$dttm,hPC$Sub_metering_1, col="black", type="l")
points(hPC$dttm,hPC$Sub_metering_2, col="red", type="l")
points(hPC$dttm,hPC$Sub_metering_3, col="blue", type="l")

legend("topright", legend=c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), 
       col=c("black","red","blue"),lty=c(1,1,1),lwd=1,pch=c(NA,NA,NA))

dev.off()
