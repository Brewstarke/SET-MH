### Attempt to calculate the change in error of linear regression across time intervals (rolling linear regression)
library(zoo)
library(dplyr)


runningRegressionSETs <- function(SETdata){
	###
	# Creates a beta value (slope) and SE of the beta for each increment in a running/incremental/additive manner
	# 
	
	data <-  SETdata
# 	# create a list of unique positions and pins.
# 	pins <- unique(data$variable)
# 	positions <- unique(data$Position_ID)
	ts_length <- length(data$Date)
	data$beta = rep(NA, ts_length)
	data$SE_beta = rep(NA, ts_length)
	for(i in 2:ts_length) {
		regress <- lm(change ~ DecYear, data = data[1:i,])
		data$beta[i] <- coef(regress)[2]
		data$SE_beta[i] <- summary(regress)$coef[4]
	}
	data
}



compileSETregressions <- function(wholeData){
	##
	# Brings in the entire SET data set in long format, subsets the data down to the pin level and
	# fits a regression line (beta) and SE of the regression (SE_beta) for each pin through time.
	#  
	temp <- wholeData # set input data as a temp dataframe
	temp$uniqueIDer <- paste(temp$Position_ID, temp$variable) # Create a unique id for running the runningRegressionSETs() function over...
	subsetsUnique <- unique(temp$uniqueIDer)
	z <- data.frame() # make empty dataframe to store results
	
	for (i in 1:length(subsetsUnique)){
	tempsubset <- temp %>% filter(uniqueIDer == subsetsUnique[i])
	z <- rbind(z, runningRegressionSETs(tempsubset))
	
	}
	z #final output of the entire dataset with added beta and SE_beta columns.
}


# Full SET dataset 
regressionsSET <- compileSETregressions(SET.data.Melt)


# Plots


regressionsSET %>% 
	filter(Site_Name == "Pine Neck") %>% 
	filter(SET_Type == "Rod SET") %>% 
	ggplot(aes(x = Date, y = beta))+
	#geom_line()+
	geom_point()+
	geom_smooth()+
	facet_grid(Plot_Name ~ Position_Name)













