## Summary Tables and Plots


# Site visits
SiteVisits <- SET.data.long %>%
	ungroup() %>%
	group_by(Site_Name, Stratafication, SET_Type, Location_ID) %>% 
	dplyr::summarise('Sample N' = n_distinct(Date)) %>%  ungroup() 
# --------------------------------------------------------------------------------------------

# Combine the SET and the MH summaries together
SummaryTable <- full_join(x = SET.station.Trends.summary,  
		     y = SA.rates, 
		     by= c('Location_ID', 'Site_Name', 'Plot_Name')) 

# --------------------------------------------------------------------------------------------
SummaryTables <- SummaryTable %>% ungroup() %>% 
	left_join(SiteVisits, 
		  by= c('Location_ID', 'Site_Name', 'SET_Type')) %>%  # Add site visits for n
	ungroup() %>% 
	left_join(StudyStationLocations,
		  by = c('Location_ID', 'Site_Name', 'SET_Type', 'Plot_Name')) %>% 
	ungroup() %>%
	select(Site_Name, SET_Type, Plot_Name, Stratafication, meanElevationRate, ElevationRate_se, StationMeanAcc, 
	       StationAccSE, `Sample N`, X_Coord, Y_Coord, UTM_Zone, Datum, dataset)  %>% 
	ungroup() %>%
	mutate(Plot = strsplit(as.character(Plot_Name), split = "-S")) %>% 
	select(Site_Name, SET_Type, meanElevationRate:Plot) %>% 
	gather(key = 'var', value = 'vals', meanElevationRate:`Sample N`) %>% 
	unite('new',SET_Type, var, sep = '_') %>% 
	spread(key = new, value = vals)  
	
# -------------------------------------------------------------------------------------------- 
	
tmp <- SummaryTable %>% 
	ungroup() %>% 
	mutate(Plot = strsplit(as.character(Plot_Name), split = "-S")) %>% 
	select(Site_Name, SET_Type, meanElevationRate:Plot) %>% 
	gather(key = 'var', value = 'vals', meanElevationRate:StationAccSE) %>% View()
	unite('new',SET_Type, var, sep = '_') %>% 
	spread(key = new, value = vals) 

	
# --------------------------------------------------------------------------------------------
SummaryTable$SubSurface_change <- SummaryTable$ElevationRate_mean - SummaryTable$StationMeanAcc

attr(SummaryTable, "doc")  <- "Summary Table is the accumulation of SET and MH mean rates and associated SE's. 
				SubSurface_change: mean elevation change - mean accretion rate
				Sample N: number of SET readings"


# --------------------------------------------------------------------------------------------

## Plot means Summary

PlotSummaryTable <- left_join(y= SA.plot.means,  
		     x= SET.station.means, 
		     by= c("Stratafication", "Plot_Name"), 
		     type= "left")

# PlotSummaryTable$SubSurface_change <- PlotSummaryTable$meanslopes - PlotSummaryTable$plot_mean

write.xlsx(x= PlotSummaryTable, file="reports/Stations_Summary_Table.xls", append= FALSE)




# save environment for app-
save.image("~/R_Code/SET-MH_Analysis/.RData")
# Save excel file for sharing etc....
write.xlsx(x= SummaryTable, file="reports/Summary_Table.xls", append= FALSE)
