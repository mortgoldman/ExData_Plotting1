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

png(filename="plot1.png", width=480,height=480,units="px")
hist(hPC$Global_active_power, main="Global Active Power", 
     col="red",xlab="Global Active Power (kilowatts)")
dev.off()
