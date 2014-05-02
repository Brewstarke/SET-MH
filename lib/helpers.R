### Helper Funcitons for various issues encountered with the data.

# Character case issues:
# Converting first character in each word from lower case to upper case

# required.packages <- c("reshape2", 
#                        "RODBC", 
#                        "plyr", 
#                        "xlsx", 
#                        "ggplot2",
#                        "Hmisc",
#                        "xtable",
#                        "ggthemes",
#                        "scales",
#                        "png", 
#                        "jpeg",
#                        "RColorBrewer")
# 
# 
# pkgTest <- function(pkg){
#   if(!require(pkg, character.only = TRUE)){
#     install.packages(pkg, dep = TRUE)
#     if(!require(pkg, character.only = TRUE)) stop("Package not found")
#   }
# }
# # Test and install the list above
# pkgTest(required.packages)
# 
# ## Capwords ------------------------------------------------------

capwords <- function(s, strict = FALSE) {
  cap <- function(s) paste(toupper(substring(s, 1, 1)),
{s <- substring(s, 2); if(strict) tolower(s) else s},
sep = "", collapse = " " )
sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}

# SA Slope calculator ----
# Create a function that checks to see if there's enough data to calculate a linear regression, 
# and then regresses pin height across time (as decimal year) 
SAslopeer <- function(d) {
  if(nrow(d) < 2) {return(data.frame(intercept = NA, slope = NA))
  } else {
    p <-  coef(lm(Raw ~ DecYear, data = d))
    p <- data.frame(slope = round(p[2], digits= 4))
  }
}

#*************************************************************
# Create a function that checks to see if there's enough data to calculate a linear regression, 
# and then regresses pin height across time (as decimal year) 
slopeer <- function(d) {
  if(nrow(d) < 2) {return(data.frame(intercept = NA, slope = NA))
  } else {
    p <-  coef(lm(Raw ~ DecYear, data = d))
    p <- data.frame(slope = round(p[2], digits= 4))
  }
}


#*************************************************************
# Function to calculate the standard error 
stder <- function(x){ sqrt(var(x,na.rm=TRUE)/length(na.omit(x)))}

