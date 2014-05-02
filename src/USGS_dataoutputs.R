# USGS output
require(xlsx)
require(ggplot2)
require(reshape2)

# Joining SET.data and SAMcast doesn't work due to the inconsistency of the data (some stations have 4-5-6 plots within)

# Will produce one cleaned version of SET data file and MH-SA data file.
# requires SET.data and SA.data to read in.
# SET data -------
SET.USGS <- SET.data [,c(1,3:24)] # save the needed variables

SET.USGS$Day <- format(SET.USGS$Start_Date, "%d")
SET.USGS$Month <- format(SET.USGS$Start_Date, "%m")
SET.USGS$Year <- format(SET.USGS$Start_Date, "%Y")

# Add extra info that is not contained in the dataset

SET.USGS$Contact_Name <- "Adam Starke"
SET.USGS$Contact_Email <- "astarke@tnc.org"

colorder <- c(2, 27, 28, 3, 5, 1, 18, 19, 6, 25, 24, 26, 16, 17, 7:15)
SET.USGS.TNC <- SET.USGS[,colorder]
SET.USGS.TNC <- rename(SET.USGS.TNC, replace= c(Start_Date= "Sample_Date"))


# Surface Accretion Data - for USGS data sheet ####
SAM <- melt(data= SA.data, 
            id.vars= c("Location_ID", "Layer_Label", "Start_Date"), 
            measure.vars=c ("Measure_1", "Measure_2", "Measure_3", "Measure_4"),
            na.rm= FALSE)
SAMcast <- dcast(SAM, Location_ID + Start_Date + variable ~ Layer_Label) # If this spits out a warning saying that it defaults to 'length' it means that there is a duplicate Layer_Label in the dataset.

SA.USGS.TNC <- join(x= SAMcast, y= StudySites, by= "Location_ID", type= "left", match= "all")[,c(1:9, 12, 18, 19, 22, 21, 23:26)]
SA.USGS.TNC <- rename(SA.USGS, replace= c(variable= "MH_replicateNumber",
                                      A= "MHplot_A",
                                      B= "MHplot_B",
                                      C= "MHplot_C",
                                      D= "MHplot_D",
                                      E= "MHplot_E",
                                      F= "MHplot_F",
                                      Start_Date= "Sample_Date",
                                      Y_Coord= "Latitude",
                                      X_Coord= "Longitude"))
SA.USGS.TNC$Sample_Date <- as.Date(SA.USGS.TNC$Sample_Date)

# Exploratory plots to get a visual check on data ----
# Bar plot counts samples
SA.qplot1 <- ggplot(data= SA.USGS, aes(factor(x= Plot_Name))) 
SA.qplot1 + geom_bar() + xlab("Set Station Plots")

SET.qplot1 <- ggplot(data= SET.USGS, aes(factor(x= Plot_Name))) 
SET.qplot1 + geom_bar() + xlab("Set Station Plots") + ylab("Count of Directions Read")


# Output the data tables into excel spreadsheets for distribution ----
write.xlsx(SET.USGS.TNC, "reports/SET.USGS.TNC.xls", append= FALSE) # Excel spreadsheet- SET data
write.xlsx(SA.USGS.TNC, "reports/SA.USGS.TNC.xls", append= FALSE) # Excel spreadsheet- SA data

