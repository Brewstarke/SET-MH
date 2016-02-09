### Helper Funcitons for various issues encountered with the data.


#*************************************************************
## Capwords ------------------------------------------------------
# Character case issues:
# Converting first character in each word from lower case to upper case
capwords <- function(s, strict = FALSE) {
  cap <- function(s) paste(toupper(substring(s, 1, 1)),
{s <- substring(s, 2); if(strict) tolower(s) else s},
sep = "", collapse = " " )
sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}


#*************************************************************
# SA Slope calculator ---- slopeSAer
# Create a function that checks to see if there's enough data to calculate a linear regression, 
# and then regresses pin height across time (as decimal year) 
slopeSAer <- function(e) {                                              
	if(nrow(e) < 2) {return(data.frame(intercept = NA, slope = NA))     # if number of rows (data points) is less than 2 return NA's
	} else {  # if there's enough data take data = e (which will be subsetted in later functions) then...
		p <-  coef(lm(plugMeanAccret ~ DecYear, data = e))       # regress the plug depth against time (decimal years) and return the coefficients of the regression- slope and intercept
		p <- data.frame(slope = round(p[2], digits= 4))      # subset out just the slope coefficient from the object p
	}
	
} 

#*************************************************************
# SET Slope Calculator ---- slopeer based on Philippe Hensel's original code
# Create a function that checks to see if there's enough data to calculate a linear regression, 
# and then regresses pin height across time (as decimal year) 
slopeer <- function(d) {
  if(nrow(d) < 2) {
  	return(data.frame(intercept = NA, slope = NA))
  }else {
    p <-  coef(lm(Raw ~ DecYear, data = d))
    p <- data.frame(slope = round(p[2], digits= 4))
  }
}


#*************************************************************
# Function to calculate the standard error 
stder <- function(x){ sqrt(var(x,na.rm=TRUE)/length(na.omit(x)))}

