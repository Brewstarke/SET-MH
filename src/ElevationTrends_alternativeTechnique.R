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
# user  system elapsed 
# 4.16    0.01    4.20 


SET_Summarize <- function(data){
	data %>% # Start with the munged and tidy dataframe (long format)
		group_by(Site_Name, Location_ID, Position_ID, pin_ID) %>% # Group by the full dataset by individual pin
		do(tidy(lm(Raw ~ DecYear, data = .))) %>% # apply a linear regression model of pin height against time (decimal year) 
		filter(term == 'DecYear') %>% 
		group_by(Site_Name, Location_ID) %>% 
		summarise(meanElevationRate = mean(estimate), ElevationRate_se = stder(estimate)) %>% 
		inner_join(StudyStations) %>% 
		select(SET_ID, Site_Name, Stratafication, Plot_Name, SET_Type, meanElevationRate, ElevationRate_se)
}


a <- SET_Summarize(SET.data.long)

b <- SET_Summarize(SET.data.cleanV1)

c <- SET_Summarize(SET.data.cleanV2)

d <- SET_Summarize(SET.data.cleanV3)
