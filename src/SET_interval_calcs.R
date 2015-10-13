### Attempt to calculate the change in error of linear regression across time intervals (rolling linear regression)
library(zoo)
library(dplyr)



# START With some basic data-
# Pulled 1 group of data that will have a running linear regression applied to it, then if it works extrapolate out to either a 'dplyr::do' or an 'apply' function

rollSETregress <- SET.data.Melt %>% 
	arrange(Date, variable) %>% 
	dplyr::select(Site_Name, SET_Type, Plot_Name, Stratafication, Position_ID, Date, variable, DecYear, change) %>% 
	# filter(Position_ID == '20130215094730-774740099.906921', variable == "Pin2") %>% 
	group_by(Site_Name, SET_Type, Plot_Name, Stratafication, Position_ID, Position_ID, variable) 

rollSETregress_subsetpin <- SET.data.Melt %>% 
	arrange(Date, variable) %>% 
	dplyr::select(Site_Name, SET_Type, Plot_Name, Stratafication, Position_ID, Date, variable, DecYear, change) %>% 
	filter(Position_ID == '20130215094730-774740099.906921' ,variable == "Pin2") %>% 
	group_by(Site_Name, SET_Type, Plot_Name, Stratafication, Position_ID, Position_ID, variable) 



runningRegressionSETs <- function(SETdata){
	data <-  SETdata
# 	# create a list of unique positions and pins.
# 	pins <- unique(data$variable)
# 	positions <- unique(data$Position_ID)
	ts_length <- length(data$Date)
	
	data$beta = rep(NA, ts_length)
	for(i in 2:ts_length) data$beta[i] <- coef(lm(DecYear ~ change, data = data[1:i,]))[2]
	data
}



betaRuns3 <- runningRegressionSETs(rollSETregress) # Full set of data


betaRuns_subset <- runningRegressionSETs(rollSETregress_subsetpin) # Subset of the full run

beatRuns2_subsetCompare <- betaRuns2 %>% 
	arrange(Date, variable) %>% 
	dplyr::select(Site_Name, SET_Type, Plot_Name, Stratafication, Position_ID, Date, variable, DecYear, change, beta) %>% 
	filter(Position_ID == '20130215094730-774740099.906921' ,variable == "Pin2") %>% 
	group_by(Position_ID, variable) 



rollSETregress_subset %>% 
	xtabs( ~ Site_Name, data = .)

runningRegressionSETs <- function(SETdata){
	data <-  SETdata
	# 	# create a list of unique positions and pins. 
	
		data$ID <- paste(Position_ID, variable)
		IDs <- unique(data$ID)
	for(i in 1:length(IDs)){
		temp <- filter(data, ID == IDs[i])
		
		
	}
	ts_length <- length(data$Date)
	
	SETdata$beta = rep(NA, ts_length)
	for(t in 2:ts_length) SETdata$beta[t] <- coef(lm(DecYear ~ change, data = SETdata[1:t,]))[2]
	SETdata
}







### More sratch #########################
#
#



for(i in 1:length(rollSETregress$Date))coef(lm(rollSETregress[1:i,]$DecYear ~ rollSETregress[1:i,]))[2]




linearRoll <- function(x){
	rollLM <- rollapply(data = x, 
			    FUN = function(x) coef(lm(x$change ~ x$DecYear))[2],
			    width = 1:length(x))
	
	return(rollLM)
	}

		

rollregress = rollapply(., width = 1:length(.),
			FUN = function(z) coef(lm(.$DecYear ~ .$change, data = as.data.frame(z))),
			by.column = FALSE, align = "left")[2]


	


# From StackExchange= ----

## lms is a function which calculate the linear regression coefficient
lms <- function(y, x){
	s = which(is.finite(x * y))
	y = y[s]
	x = x[s]
	return(cov(x, y)/var(x))
}


library(dplyr)
n.dates <- 60
n.stocks <- 2
date <- seq(as.Date("2011-07-01"), by=1, len=n.dates)
symbol <- replicate(n.stocks, paste0(sample(LETTERS, 5), collapse = ""))
x <- expand.grid(date, symbol)
x$return <- rnorm(n.dates*n.stocks, 0, sd = 0.05)
names(x) <- c("date", "company", "return")	
## z is a dataframe which stores our final result
z <- data.frame()

## x has to be ungrouped
x <- ungroup(x)

## subset with "filter" and roll with "rollapply"
symbols <- unique(x$company)
for(i in 1:length(symbols)){
	temp <- filter(x, company == symbols[i])
	z <- rbind(z, mutate(temp, beta = rollapply(temp[, c(2, 3)], 
						    FUN = function(x) lms(x[, 1], x[, 2]),
						    width = 20, fill = NA,
						    by.column = FALSE, align = "right")))
}

## final result
print(z)
	


rollapply(z, width = 4,
	  function(x) coef(lm(y ~ x, data = as.data.frame(x))),
	  by.column = FALSE, align = "right")

##########################	
	