### Attempt to calculate the change in error of linear regression across time intervals (rolling linear regression)
library(zoo)
library(dplyr)






compileSETregressions <- function(wholeData){
	
		runningRegressionSETs <- function(SETdata){
			###
			# Creates a beta value (slope) and SE of the beta for each increment in a running/incremental/additive manner
			# 
			ts_length <- length(SETdata$Date)
			SETdata$beta = rep(NA, ts_length)
			SETdata$SE_beta = rep(NA, ts_length)
			SETdata$Rsquare = rep(NA, ts_length)
			for(i in 2:ts_length) {
				regress <- lm(Change ~ DecYear, data = SETdata[1:i,])
				SETdata$beta[i] <- coef(regress)[2]
				SETdata$SE_beta[i] <- summary(regress)$coef[4]
				SETdata$Rsquare[i] <- summary(regress)$r.square
			}
			SETdata
		}
	##
	# Brings in the entire SET data set in long format, subsets the data down to the pin level and
	# fits a regression line (beta) and SE of the regression (SE_beta) for each pin through time.
	#  
	temp <- wholeData # set input data as a temp dataframe
	temp$uniqueIDer <- paste(temp$Position_ID, temp$Pin_number) # Create a unique id for running the runningRegressionSETs() function over...
	subsetsUnique <- unique(temp$uniqueIDer)
	
	z <- data.frame() # make empty dataframe to store results
	
	for (i in 1:length(subsetsUnique)){
		
	tempsubset <- temp %>% filter(uniqueIDer == subsetsUnique[i])
	
	z <- rbind(z, runningRegressionSETs(tempsubset))
	
	}

	z #final output of the entire dataset with added beta and SE_beta columns.
}


summarizeSETregressions <- function(wholeRegress){
	# Summarize pin regressions on the direction and then the station level
	directionLevel <- wholeRegress %>% 
		group_by(Position_ID, Location_ID, Start_Date)
}

# Full SET dataset ---@^* WORK NEEDED HERE---
SET.data.Melt <- SET.data.long %>% 
	filter(Date != '2008-08-08', Site_Name != 'Frost Creek') %>% as.data.frame()

regressionsSET <- compileSETregressions(SET.data.Melt)

# Subset regression data
intervalSET <- regressionsSET %>% 
	select(SET_Type, Site_Name, Stratafication, Date, Plot_Name, Arm_Direction, beta, SE_beta)

save(intervalSET, SummaryTable, file = 'RegressionAnalysis/regress.RData')

# Plots

# 
# regressionsSET %>% 
# 	# filter(Site_Name == "East Creek") %>% 
# 	filter(SET_Type == "Rod SET") %>% 
# 	ggplot(aes(x = Date, y = beta))+
# 	#geom_line()+
# 	geom_point()+
# 	geom_smooth()+
# 	facet_grid(Site_Name ~ .)

# 
# regressionsSET %>% 
# 	filter(Site_Name == "Pine Neck") %>% 
# 	filter(SET_Type == "Rod SET") %>%
# 	filter(!is.na(beta)) %>% 
# 	ggvis(x = ~Date, y = ~beta) %>%
# 	layer_points() %>% 
# 	layer_smooths(se = TRUE) %>% 
# 	add_tooltip(function(df) round(df$beta, digits =2), 'hover') %>% 
# 	scale_numeric("y", trans = "log10")
# 	
# 









