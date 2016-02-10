# Trends analysis 
# Based on the SOP provided by NPS/USGS/NOAA

# Question 1: Is accretion trend equal to elevation trend?
# Paired t-Test across stations.

# Create funciton that takes a SET station and outputs the paired T-test result

accretionElevation <- function(stationID){
	# 
	# @stationID = SET-MH station of interest. T-test will compare accretion rates to elevation rates at that station
	# outputs a single row dataframe using the broom package:
	#	1) t-test results
	# 	2) what the results mean- description of 
	#
	# parse out the vector of total elevation change 
	
	SET <- meanslope.Pos %>% 
		filter(Plot_Name == stationID) %>% 
		.$meanslope
	Acc <- SA.plot.regress %>% 
		filter(Plot_Name == stationID) %>% 
		.$slope
	tTest <- t.test(SET, Acc, paired = FALSE)
	tTest %<>% tidy()
	tTest %<>% mutate(stationID = as.character(stationID))
	tTest
	
}

# Build dataframe from results of t-Test with translations of the processes driving the measured trends.


accretionElevationDF <- function(){
	tmp <- NULL # setup blank data frame
	
		for(i in unique(SA.data.M$Plot_Name))
			{
			tmp1 <- accretionElevation(i)
			tmp <- bind_rows(tmp, tmp1)
			}
	
	dframe <- tmp %>%
		dplyr::rename(diffMeans = estimate, 
				ElevationMean = estimate1, 
				AccretionMean = estimate2,
				t_stat = statistic, 
				df = parameter) %>%
		mutate(significance = ifelse(.$p.value < 0.05,
					     yes = "Significant",
					     no = "Not significant")) %>% 
		mutate(dominantprocess = ifelse(.$significance == "Significant",
		       			 yes = ifelse(.$diffMeans < 0,
		       			 	     yes = "Shallow Subsidence: below-ground processes diminish elevation change",
		       			 	     no = "Shallow Expansion: below-ground processes are enhancing elevation change"),
		       			 no = "Surface Accretion is driving elevation change"))

	dframe
}

accretionElevation <- accretionElevationDF()


# Display dataframe in DT (datatable HTMLwidget)

accretionElevation %>% 
	select(stationID, dominantprocess, ElevationMean, AccretionMean, diffMeans, t_stat, p.value, significance) %>% 
	datatable(class = 'cell-border stripe',
		  rownames = FALSE, 
		  caption = "Comparison of elevation change and accretion rate",
		  extensions = list('ColVis', 'FixedHeader'), options = list(dom = 'C<"clear">lfrtip', pageLength = 50))%>% 
	formatRound(3:6, digits = 2) %>% 
	formatRound(7, digits = 3)







