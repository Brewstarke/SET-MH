# Trends analysis 
# Based on the SOP provided by NPS/USGS/NOAA

# Question 1: Is accretion trend equal to elevation trend?
# Paired t-Test across stations.

# Create funciton that takes a SET station and outputs the paired T-test result

accretionElevation <- function(stationID){
	stationID <- 'AH-1'
	
	library(dplyr)
	# @stationID = SET-MH station of interest. T-test will compare accretion rates to elevation rates
	# outputs a set of list: 1) t-test results
	# 			2) what the results mean- description of 
	
	# parse out the vector of total elevation change 
	
	SET <- meanslope.Pos %>% 
		filter(Plot_Name == stationID) %>% 
		.$meanslope
	Acc <- SA.plot.means %>% 
		filter(Plot_Name == stationID) %>% 
		.$plot_mean
	
}


