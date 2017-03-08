###
# SET-MH Elevation trend calculator using dplyr and broom packages

# SET SLOPE SUMMARY AND ANALYSIS CODE
# Statistical Methods by Philippe Hensel and Penelope Pooler
# Last edited on 12/19/2012
###
# Programatic Methods Modified by Adam Starke - 
# Specifically for use along side SET Database v. 2.94 links found in ~/data/SET_data_imports.R
# 
# Picks up from 'munge/Data_munge.R' to calculate trends in elevation and accretion from 'tidy' data
#



SET_Summarize <- function(data){
	
	# SET_Summarize function takes a long format, rod-SET dataseries and calculates the 
	# regression coefficient across all unique pin/direction/station/site locations
	# then calculates the mean of those regression coefficients across directions and then stations
	# to arrive at a 'Station level' summary statistic that can be used in further analysis
	# as in '/src/TrendsAnalysis.R'
	# Output is trimmed down to Site_Name and Location_ID
	
	df <- data %>% # Start with the munged and tidy dataframe (long format)
		dplyr::group_by(Site_Name, SET_Type, Location_ID, Plot_Name, Position_ID, pin_ID) %>% # Group by the full dataset by individual pin
		dplyr::do(tidy(lm(Raw ~ DecYear, data = .))) %>% # apply a linear regression model of pin height against time (decimal year) 
		filter(term == 'DecYear') 
	pinLevel <<- df 
		
	df2 <- df %>% # Summarize down to position or direction level
		ungroup() %>% 
		group_by(Site_Name, SET_Type, Location_ID, Plot_Name, Position_ID) %>% 
		dplyr::summarize(meanElevationRate = mean(estimate), ElevationRate_se = stder(estimate)) 
	positionLevel <<- df2
	
	df3 <- df2 %>% 
		ungroup() %>% # Summarize down to the station level.
		group_by(Site_Name, SET_Type, Location_ID, Plot_Name) %>% 
		dplyr::summarize(ElevationRate_mean = mean(meanElevationRate), ElevationRate_se = stder(meanElevationRate))
		# select(SET_ID, Location_ID, Site_Name, Stratafication, Plot_Name, SET_Type, meanElevationRate, ElevationRate_se)
	stationLevel <- df3 
	
	attr(df3, which = "Datainfo") <- attr(data, "Datainfo")
	df3
}

# Run each filtered dataset through summarize funtion to learn impacts of 'issues' of pins ----

a <- SET_Summarize(SET.data.long) %>% mutate(dataset = "A") # "Full SET dataset including all measures in a LONG format"

b <- SET_Summarize(SET.data.cleanV1) %>% mutate(dataset = "B") # "Any pin with a 'history of an issue' has been dropped"

c <- SET_Summarize(SET.data.cleanV2) %>% mutate(dataset = "C") # "Any individual pin reading with a 'an issue' has been dropped"

d <- SET_Summarize(SET.data.cleanV3) %>% mutate(dataset = "Any pins impacted by holes or mussels dropped")# "Any individual pin reading taken atop a hole or mussle has been dropped"

CompiledSET <- a %>% bind_rows(b) %>% bind_rows(c) %>% bind_rows(d)

# Using the more conservative approach- drop all pins that have had a mussel/hole issue during the readings. ----
SET.station.Summary <- SET_Summarize(SET.data.cleanV3) %>% mutate(dataset = "Any pins impacted by holes or mussels dropped")# "Any individual pin reading taken atop a hole or mussle has been dropped"


# SET-MH study site level summaries ----

SET_site_Summary <- function(stationLeveldata){
	stationLeveldata %>% left_join(StudyStationLocations, by = c('Location_ID', 'Site_Name', 'SET_Type')) %>% 
		ungroup() %>% group_by(Site_Name, Stratafication, SET_Type) %>%
		summarise(mean_ElevationRate = mean(ElevationRate_mean), ElevationRate_se = stder(ElevationRate_mean))
}

# Generate Site summary ----
SET.site.Summary <- SET_site_Summary(SET.station.Summary)

# Surface Accretion Rate Summarizations ----


SA.rates  <- SA.data.long %>% 
	rename(Location_ID = Location_ID.x) %>% 
	select(Layer_ID, Location_ID, Date, Estab_Date, Accretion, Site_ID, Plot_Name, Organization, DecYear) %>% 
	group_by(Layer_ID, Location_ID, Date, Estab_Date, Accretion, Site_ID, Plot_Name, Organization, DecYear) %>% 
	summarise(plugMeanAcc = mean(Accretion), plugSEAcc = stder(Accretion)) %>% 
	group_by(Layer_ID, Location_ID) %>% 
	do(tidy(lm(plugMeanAcc ~ DecYear, data = .))) %>% # Uses broom package 'tidy' to clean up linear regression of mean accretion
	filter(term == 'DecYear') %>% ungroup() %>% 
	left_join(StudyStationLocations, by = 'Location_ID') %>% 
	rename(SurfaceAccretion_plot = estimate, SurfaceAccretionSE_plot = std.error) %>% 
	select(Layer_ID, Location_ID, Site_Name, Stratafication, Plot_Name, SurfaceAccretion_plot, SurfaceAccretionSE_plot) %>% 
	ungroup() %>% 
	group_by(Site_Name, Stratafication, Plot_Name, Location_ID) %>% 
	summarise(StationMeanAcc = mean(SurfaceAccretion_plot), StationAccSE = stder(SurfaceAccretion_plot))
	



