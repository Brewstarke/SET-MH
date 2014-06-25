###
#
# Munge the data tables pulled in from Access using the SET_data_imports script found in the ~/data folder. 
# 
### 
# Required Packages -----
require(reshape2)
require(RODBC)
require(plyr)

#SQL type joins to flatten the tables from the database. ----

#Study Sites with Locations data --Location_ID is analagous to Plot_Name 
StudySites <- join(Sites, Locations, by="Site_ID", type="inner") 

#Surface Accretion data 
SA <- join(SA_Layers, SAccret, by="Layer_ID", type= "inner")

#SET Rod data
SET <- join(SETdata, Positions, by="Position_ID", type= "inner")

# Sampling events and sites
# join site-location data with sampling 'events'
Samplings <- join(StudySites, Events, by= "Location_ID", type="inner") 

# Complete datasets with ALL variables
SA.data <- join(SA, Samplings, by="Event_ID", type="inner")
SET.data <- join(SET, Samplings, by="Event_ID", type= "inner")

# Remove excess dataframes leaving only SA and SET data ----
rm(Events,
   Positions,
   SA,
   SA_Layers,
   SAccret,
   SET,
   SETdata,   
   Samplings,
   Sites
   )

### HAVE TWO COMPLETE DATASETS AT THIS POINT ####
# One set contains SET data with location, date and pin height data
# One has Surface Accretion data with location, date and accretion data
capwords <- function(s, strict = FALSE) {
	cap <- function(s) paste(toupper(substring(s, 1, 1)),
				 {
				 	s <- substring(s, 2); if(strict) tolower(s) else s
				 	},
				 sep = "", collapse = " " )
	sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}


SET.data$Stratafication <- as.character(SET.data$Stratafication)
SET.data$Stratafication <- as.factor(capwords(SET.data$Stratafication)) # Standardize the character format
SET.data$Start_Date <- as.Date(SET.data$Start_Date) # Ensure that 'Start_Date' is of class 'date'

# Clean up SET.data dataframe and reshape to allow for analysis-----
# 'keeps' is list of variable names to keep; 'iders' are identifier variables used in reshaping the dataframe
keeps <- c("SET_Type", 
           "Position_ID", 
           "Location_ID", 
           "Site_Name", 
           "Stratafication", 
           "Plot_Name", 
           "Start_Date", 
           "Pin1", 
           "Pin2", 
           "Pin3", 
           "Pin4", 
           "Pin5", 
           "Pin6", 
           "Pin7", 
           "Pin8", 
           "Pin9", 
           "Arm_Direction", 
           "Position_Name", 
           "X_Coord",
           "Y_Coord",
           "Coord_Units",
           "Coord_System",
           "UTM_Zone",
           "Datum")
# Identifiers used for plyr ----
iders <- c("SET_Type", 
           "Position_ID", 
           "Location_ID", 
           "Site_Name", 
           "Stratafication", 
           "Plot_Name", 
           "Start_Date",
           "Arm_Direction", 
           "Position_Name", 
           "X_Coord",
           "Y_Coord",
           "Coord_Units",
           "Coord_System",
           "UTM_Zone",
           "Datum")

SET.data <- SET.data[keeps] 
# Use reshape2 to melt wide table down to a long format (really only transposing the pin readings) =====
SET.data.M <- melt(SET.data, id= iders, na.rm=TRUE)

###
#  Munge dates to create sample date and establishment date---- 
#  
# Rename 'Start_Date' to just 'Date' to remove confusing variable name
SET.data.M$Date <- as.Date((SET.data.M$Start_Date))

# Create column of 'establishment dates'= EstDate ----
# Date the site was first established
# Use ddply to split by Location_ID and find the first date read, record that in -$EstDate
SET.data.M <-ddply(SET.data.M,
                   .(Location_ID),
                   transform,
                   EstDate= (as.Date(min(Date)))) 

# Create variable DecYear- decimal years - in SET data, for regression analysis. 
# difftime- calculates the time difference between t1 and t2 in units identified

SET.data.M$DecYear <- round((((as.numeric(difftime(SET.data.M$Date, SET.data.M$EstDate, units = "days"))))/365),3)
SET.data.M <- rename(SET.data.M, c(value="Raw")) #rename 'value' to 'Raw'
SET.data.M <- SET.data.M[order(SET.data.M$Start_Date),]

# Calculates a 'change' used for plots primarily- regressions are run through 'raw' data to reduce chance of error.
SET.data.M <- ddply(SET.data.M, 
                    .(Position_ID,
                      variable), 
                    transform, 
                    change = as.numeric(Raw-Raw[1]),
		    incrementalChange = c(NA, diff(change)))

###
# Surface Accretion  -----
#
#Clean up SA.data dataframe and reshape; same as above but working on surface accretion data
# similar steps as SET.data

keepsA <- c("Location_ID", 
	    "Layer_Label", 
	    "Estab_Date", 
	    "Measure_1", 
	    "Measure_2", 
	    "Measure_3", 
	    "Measure_4",
	    "Measure_5", 
	    "Measure_6", 
	    "Site_Name", 
	    "Stratafication", 
	    "Plot_Name", 
	    "Start_Date")
SA.data <- SA.data[keepsA] # Drop unneeded variables

idersSA <- c("Location_ID", 
	     "Layer_Label", 
	     "Estab_Date", 
	     "Site_Name", 
	     "Stratafication", 
	     "Plot_Name", 
	     "Start_Date")
SA.data.M <- melt(SA.data, id= idersSA, na.rm=TRUE) # melt down dataframe into tidy table.


# Create variable DecYear- decimal years - in SA.data, for regression analysis
SA.data.M$DecYear <- round((((as.numeric(difftime(SA.data.M$Start_Date, SA.data.M$Estab_Date, units = "days"))))/365),3)

#SA.data.M$DecYear <- round(((SA.data.M$Start_Date-SA.data.M$Estab_Date)/365),3)
SA.data.M <- rename(SA.data.M, c(value="Accretion")) #rename 'value' to 'Accretion'



stder <- function(x){ sqrt(var(x,na.rm=TRUE)/length(na.omit(x)))}

### All clear to hear-- 07Mar2014- AFS -----