## Interactive Plots for SET-MH data

library(dygraphs)
library(xts)

# The old method of summarizing the data was to calculate the difference between Ti and Ti+1
# then calculate the mean change for all pins in each direction at each time step. then average the changes across the station and then the site.
# To do that we need to gather the SET data by pin#, direction, station, and site. 
# SET.data.Melt does this
SET.data.long <- tbl_df(SET.data.long)

PinMeans <- SET.data.long %>%
	group_by(Location_ID, Position_ID, Site_Name, Plot_Name, Date) %>%
	dplyr::summarise(mean = mean(Raw))

DirectionMeans <- PinMeans %>%
	group_by(Location_ID, Site_Name, Plot_Name, Date) %>%
	dplyr::summarise(mean = mean(mean))

StationMeans <- DirectionMeans %>%
	group_by(Site_Name, Plot_Name, Date) %>%
	dplyr::summarise(mean = mean(mean))

SiteMeans <- StationMeans %>%
	group_by(Site_Name, Date) %>%
	dplyr::summarise(SiteMean = mean(mean))	  

# To make an xts class object from a dataframe you need to either drop the rownames or rename the first coloumn as the timestamps.
# Need to gather and spread the data to have Site_Name as column headers

SET_SiteMeans <- SiteMeans %>% 
	spread(Site_Name, value = SiteMean)

SET_SiteMeans_xts <- as.xts(SET_SiteMeans, order.by = SET_SiteMeans$Date)


str(SET_SiteMeans_xts)



dygraph(SET_SiteMeans_xts, 
	main = "Average Marsh Surface Elevation Changes Across Long Island", 
	ylab = "Elevation (mm)") %>%
	dyOptions(drawPoints = TRUE,
		  pointSize = 2, 
		  connectSeparatedPoints = TRUE) %>%
	dyHighlight(highlightCircleSize = 5, 
		    highlightSeriesBackgroundAlpha = 0.2, 
		    hideOnMouseOut = FALSE) %>%
	dyRangeSelector() 


