# Trends analysis 
# Based on the SOP provided by NPS/USGS/NOAA

# Question 1: Is accretion trend equal to elevation trend?
# Paired t-Test across stations.

# Create funciton that takes a SET station and outputs the paired T-test result

accretionElevation <- function(SETdata, stationID){
	# 
	# stationID = SET-MH station of interest. T-test will compare accretion rates to elevation rates at that station
	# outputs a single row dataframe using the broom package:
	# SETdata = SET data set -typically used for comparisons across outlier removal strategies.
	# 1) t-test results
	# 	2) what the results mean- description of 
	#
	# parse out the vector of total elevation change 
	
	SET <- SETdata %>% 
		filter(Plot_Name == stationID) %>% filter(SET_Type == 'Rod SET') %>% 
		.$meanElevationRate
	
	Acc <- SA.rates %>% 
		filter(Plot_Name == stationID) %>% 
		.$Accretion
	
	tTest <- t.test(SET, Acc, paired = FALSE)
	tTest %<>% tidy()
	tTest %<>% mutate(station_ID = as.character(stationID))
	tTest
	
}

# ttest1 <- accretionElevation(a, stationID = 'BC-3')

# Build dataframe from results of t-Test with translations of the processes driving the measured trends.


accretionElevationDF <- function(data){
	tmp <- NULL # setup blank data frame
	
		for(i in unique(SA.data.long$Plot_Name))
			{
			tmp1 <- accretionElevation(data, i)
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

accretionElevationA <- accretionElevationDF(a) %>% mutate(dataset = 'A')
accretionElevationB <- accretionElevationDF(b) %>% mutate(dataset = 'B')
accretionElevationC <- accretionElevationDF(c) %>% mutate(dataset = 'C')
accretionElevationD <- accretionElevationDF(d) %>% mutate(dataset = 'D')

# Plot comparing different input datasets
comparisons <- accretionElevationA %>% 
	bind_rows(accretionElevationB) %>% 
	bind_rows(accretionElevationC) %>% 
	bind_rows(accretionElevationD)

comparisons %>% ggplot(aes(x = station_ID, y = ElevationMean, color = dataset)) +
	geom_pointrange(position = 'jitter', aes(ymin = conf.low, ymax = conf.high)) +
	theme_bw()

# ANOVA comparing 4 different 'datasets' 
# If no significant difference between datasets then proceed as usual.

fit <- aov(ElevationMean ~ dataset * station_ID, data = comparisons)
fit

# Display dataframe in DT (datatable HTMLwidget)

accretionElevationA %>% 
	select(station_ID, dominantprocess, ElevationMean, AccretionMean, diffMeans, t_stat, p.value, significance) %>% 
	datatable(#class = 'cell-border stripe',
		  rownames = FALSE, 
		  extensions = list('ColVis', 'FixedHeader'), options = list(dom = 'C<"clear">lfrtip', pageLength = 50),
		  style = 'bootstrap',
		  class = 'table-bordered',
		  caption = 'Standard T-test comparison of accretion rate to elevation rate across stations.',
		  filter = 'top')%>% 
	formatRound(3:6, digits = 2) %>% 
	formatRound(7, digits = 3)


accretionElevationA %>% 
	ggplot(aes(y = ElevationMean, x = AccretionMean, color = station_ID, label = station_ID))+
	geom_label(vjust = 1)+
	geom_point(aes(size = p.value))+ 
	geom_abline(slope = 1, intercept = 0)+
	geom_hline(yintercept = 3.24, color = 'red', size = 1)+
	xlim(0,8)+
	ylim(0,8)+
	theme_bw() +
	theme(legend.position = 'none')




