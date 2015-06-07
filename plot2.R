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
png(filename = "plot2.png", width = 480, height = 480, units = "px", bg = "white")

# create plot using data
plot(data$DateTime, data$Global_active_power, xlab = "", ylab = "Global Active Power (kilowatts)", type = "l")

# close device and save file
dev.off()