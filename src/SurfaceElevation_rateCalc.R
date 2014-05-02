# SET SLOPE SUMMARY AND ANALYSIS CODE
# Statistical Methods by Philippe Hensel and Penelope Pooler
# Last edited on 12/19/2012
###
# Progromatic Methods Modified by Adam Starke - 
# Specifically for use along side SET Database v. 2.94 links found in ~/data/SET_data_imports.R
# 
# Picks up from 'munge/Data_munge.R' to analyze 'cleaned' data
#
# Required Packages -----


### Analysis -----
# DO SEPARATE REGRESSIONS FOR EACH PIN WITH RESPONSE BEING CHANGE IN MM OF THAT PIN AND REGRESSOR BEING DECIMAL YEARS
# NOTE: PIN LENGTHS LISTED AS "value" AND TIME AS "years"
# NOTE: WE DO NOT FORCE REGRESSION THROUGH ORIGIN (WE USE RAW PIN HEIGHTS)
#####
# Alternative Method for calculating the slope of each pin- 
# Utilizing the same methodology that Philippe Hensel and Penelope Pooler developed
# Uses plyr package, keeping things in dataframes instead of lists
# lmSET is made up by subsetting on Site_Name, Plot_Name, Arm_Direction, and Pin

#*************************************************************
# Create a function that checks to see if there's enough data to calculate a linear regression, 
# and then regresses pin height across time (as decimal year) 
slopeer <- function(d) {
  if(nrow(d) < 3) {return(data.frame(intercept = NA, slope = NA)) # if number of rows (data points) is less than 3 return NA's
  } else {                                                        # if there's enough data take data = d (which will be subsetted in later functions) then...
    p <-  coef(lm(Raw ~ DecYear, data = d))                       # regress the pin heigh against time (decimal years) and return the coefficients of the regression- slope and intercept
    p <- data.frame(slope = round(p[2], digits= 4))               # subset out just the slope coefficient from the object p 
  }
} # this function is also found in '/helpers.R' 

#*************************************************************
# 1.)
# Calculate slope using function slopeer created above ----
# 
meanslope.Pin <- ddply(SET.data.M, .(SET_Type, 
                                     Site_Name, 
                                     Plot_Name,
                                     Position_ID, 
                                     Stratafication, 
                                     variable, 
                                     Location_ID), slopeer)

#dt <- join(x= meanslope.Pin, y= StudySites, by= "Location_ID")
#*************************************************************
# 2.)
# Summarize slopes by Position_ID ----
# (unique to site & station & SET arm position) by calculating mean slope and SE of slope means

meanslope.Pos <- ddply(.data= meanslope.Pin, 
                   .(SET_Type, 
                     Site_Name,
                     Plot_Name,
                     Stratafication, 
                     Position_ID, 
                     Location_ID), 
                   summarize, 
                   meanslope= round(mean(slope,na.rm=TRUE),digits= 3), 
                   seSlope= round(sqrt(var(slope,na.rm=TRUE)/length(na.omit(slope))), digits= 3)) # can be replaced by stder function

#*************************************************************
# 3.) 
# Calculate mean by Location_ID (Station) by averaging the mean slopes of each SET arm Position (which consists of mean pin slopes)
# 
meanslope.Loc <- ddply(.data= meanslope.Pos, 
                       .(SET_Type, 
                         Site_Name,
                         Plot_Name,
                         Stratafication, 
                         Location_ID), 
                       summarize, 
                       meanslopes= round(mean(meanslope,na.rm=TRUE),digits= 3), 
                       seSlope= round(sqrt(var(meanslope,na.rm=TRUE)/length(na.omit(meanslope))), digits= 3)) # can be replaced by stder function

SET.station.means <- join(x= meanslope.Loc, 
                          y= StudySites, 
                          by= "Location_ID", 
                          type= "left")[, c(1:4, 6:7, 19:24)] #[section indexes the columns/variables wanted in the final dataframe]

SET.site.means <- ddply(.data= SET.station.means, 
                       .(Site_Name,
                         Stratafication,
                         SET_Type),
                       summarize, 
                       meanslope= round(mean(meanslopes,na.rm=TRUE),digits= 3), 
                       seSlope= round(sqrt(var(meanslopes,na.rm=TRUE)/length(na.omit(meanslopes))), digits= 3)) # can be replaced by stder function

SET.site.means <- rename(SET.site.means, replace=c(meanslope = "Mean_elevation_change", seSlope = "SE_ofmeanrate"))

### All clear to hear-- 10Mar2014- AFS -----TEST FROM HERE UP
# Up to here works but needs to be better documented and cleaned up.

write.xlsx(x=SET.site.means, file="reports/SETelevrate.xls")


