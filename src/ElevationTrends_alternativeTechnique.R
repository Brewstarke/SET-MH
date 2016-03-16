###
# SET Elevation trend calculator using dplyr and broom packages

# SET SLOPE SUMMARY AND ANALYSIS CODE
# Statistical Methods by Philippe Hensel and Penelope Pooler
# Last edited on 12/19/2012
###
# Progromatic Methods Modified by Adam Starke - 
# Specifically for use along side SET Database v. 2.94 links found in ~/data/SET_data_imports.R
# 
# Picks up from 'munge/Data_munge.R' to analyze 'cleaned' data
#



SET_Summarize <- function(data){
	df <- data %>% # Start with the munged and tidy dataframe (long format)
		group_by(Site_Name, Location_ID, Position_ID, pin_ID) %>% # Group by the full dataset by individual pin
		do(tidy(lm(Raw ~ DecYear, data = .))) %>% # apply a linear regression model of pin height against time (decimal year) 
		filter(term == 'DecYear') %>% 
		group_by(Site_Name, Location_ID, Position_ID) %>% 
		summarise(meanElevationRate = mean(estimate), ElevationRate_se = stder(estimate)) %>% # Summarize down to the station level.
		inner_join(StudyStations) %>% 
		select(SET_ID, Location_ID, Site_Name, Stratafication, Plot_Name, SET_Type, meanElevationRate, ElevationRate_se)
	attr(df, which = "Datainfo") <- attr(data, "Datainfo")
	df
}

# Run each filtered dataset through summarize funtion ----

a <- SET_Summarize(SET.data.long) %>% mutate(dataset = "A")

b <- SET_Summarize(SET.data.cleanV1) %>% mutate(dataset = "B")

c <- SET_Summarize(SET.data.cleanV2) %>% mutate(dataset = "C")

d <- SET_Summarize(SET.data.cleanV3) %>% mutate(dataset = "D")

CompiledSET <- a %>% bind_rows(b) %>% bind_rows(c) %>% bind_rows(d)

SET.site.Summary <- function(stationLeveldata){
	stationLeveldata %>% 
		group_by(Site_Name, Stratafication, SET_Type)
}


# Surface Accretion Summarization ----

SA.rates  <- SA.data.long %>% 
	rename(Location_ID = Location_ID.x) %>% 
	select(Layer_ID, Location_ID, Date, Estab_Date, Accretion, Site_ID, Plot_Name, Organization, DecYear) %>% 
	group_by(Layer_ID, Location_ID, Date, Estab_Date, Accretion, Site_ID, Plot_Name, Organization, DecYear) %>% 
	summarise(plugMeanAcc = mean(Accretion), plugSEAcc = stder(Accretion)) %>% 
	group_by(Layer_ID, Location_ID) %>% 
	do(tidy(lm(plugMeanAcc ~ DecYear, data = .))) %>% 
	filter(term == 'DecYear') %>%
	left_join(StudyStations) %>% 
	rename(Accretion = estimate, AccretionSE = std.error) %>% 
	select(Layer_ID, Location_ID, Site_Name, Stratafication, Plot_Name, SET_Type, Accretion, AccretionSE)
	



