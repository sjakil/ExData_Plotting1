# create funtion to download data
downloadData <- function(){
    
    # download file to current working directory
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "./exdata_data_household_power_consumption.zip", method = "curl")
    
    # since it is a zip file, unzip it to get the data
    unzip("./exdata_data_household_power_consumption.zip")
    
}


# create function to get and clean data
getData <- function(){
    
    # check if file has been downloaded, if not download it first
    if (!file.exists("./household_power_consumption.txt"))
        downloadData()
    
    # read the data using ';' seperator and making sure string do not get read as factors by default
    data <- read.csv("./household_power_consumption.txt", sep = ";", stringsAsFactors = FALSE)
    
    # format the date so that we can make a selection with it
    data$DateFormatted <- strptime(data$Date, format = "%d/%m/%Y")
    
    # select only the dates we are interested in
    data <- data[as.character(data$DateFormatted) %in% c("2007-02-01", "2007-02-02"), ]
    
    # make new column combining date and time into one
    data$DateTime <- as.POSIXct(strptime(paste(data$Date,data$Time), "%d/%m/%Y %H:%M:%S"))
    
    # return the data
    return(data)
    
}

# initialize data
data <- getData()

# initialize a png device
png(filename = "plot4.png", width = 480, height = 480, units = "px", bg = "white")

# set plot layout to a grid of 2 by 2
par(mfrow = c(2, 2))

# create top left plot using data
plot(data$DateTime, data$Global_active_power, xlab = "", ylab = "Global Active Power", type = "l")


# create top right plot using data
plot(data$DateTime, data$Voltage, xlab = "datetime", ylab = "Voltage", type = "l")


# create bottom left plot using data
plot(data$DateTime, c(data$Sub_metering_1), xlab = "", ylab = "Energy sub metering", type = "n")

# add points for first line
points(data$DateTime, data$Sub_metering_1, type = "l", col = "black")

# add points for second line
points(data$DateTime, data$Sub_metering_2, type = "l", col = "red")

# add points for third line
points(data$DateTime, data$Sub_metering_3, type = "l", col = "blue")

# create legend
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1, 1, 1), lwd=c(2.5, 2.5, 2.5), col=c("black", "red","blue"), bty = "n") 


# create bottom right plot
plot(data$DateTime, data$Global_reactive_power, xlab = "datetime", ylab = "Global_Active_Power", type = "l")


# close device and save file
dev.off()