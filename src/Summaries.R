## Summary Tables and Plots
library(xlsx)
# library(reshape2)
# library(plyr)
library(dplyr)
library(tidyr)

# Site visits
SiteVisits <- SET.data.cleanV3 %>%
	ungroup() %>%
	group_by(Site_Name, Stratafication, SET_Type, Location_ID) %>%
	dplyr::summarise('Sample N' = n_distinct(Date))

# Combine the SET and the MH summaries together
SummaryTable <- left_join(x = SET.station.Summary,  
		     y = SA.rates, 
		     by= c('Location_ID', 'Site_Name', 'Plot_Name'))

SummaryTable <- SummaryTable %>% ungroup() %>% 
	left_join(SiteVisits, by= c('Location_ID', 'Site_Name', 'SET_Type')) %>% # Add site visits for n
	left_join(StudyStationLocations %>% 
		  	select(Location_ID, X_Coord, Y_Coord, Datum, Coord_System, UTM_Zone), by = 'Location_ID') %>% 
	select(Site_Name, SET_Type, Plot_Name, ElevationRate_mean, ElevationRate_se, StationMeanAcc, StationAccSE, `Sample N`, X_Coord, Y_Coord, Datum, Coord_System, UTM_Zone, dataset)

tmp <- SummaryTable %>% gather(key = 'var', value = 'vals', ElevationRate_mean:StationAccSE) %>% 
	unite('new',SET_Type, var, sep = '_') %>% 
	spread(key = new, value = vals)

	

SummaryTable$SubSurface_change <- SummaryTable$ElevationRate_mean - SummaryTable$StationMeanAcc

attr(SummaryTable, "doc")  <- "Summary Table is the accumulation of SET and MH mean rates and associated SE's. 
				SubSurface_change: mean elevation change - mean accretion rate
				Sample N: number of SET readings"




## Plot means Summary

PlotSummaryTable <- join(y= SA.plot.means,  
		     x= SET.station.means, 
		     by= c("Stratafication", "Plot_Name"), 
		     type= "left")

# PlotSummaryTable$SubSurface_change <- PlotSummaryTable$meanslopes - PlotSummaryTable$plot_mean

write.xlsx(x= PlotSummaryTable, file="reports/Stations_Summary_Table.xls", append= FALSE)




# save environment for app-
save.image("~/R_Code/SET-MH_Analysis/.RData")
# Save excel file for sharing etc....
write.xlsx(x= SummaryTable, file="reports/Summary_Table.xls", append= FALSE)
