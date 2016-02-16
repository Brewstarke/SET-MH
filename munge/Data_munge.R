###
#
# Munge the data tables pulled in from Access using the SET_data_imports script found in the ~/data folder. 
# 
### 
## @knitr MungeTables
#SQL type joins to flatten the tables from the database. ----

#Study Sites with Locations data --Location_ID is a numeric key analagous to Plot_Name 
StudyStations <- inner_join(Sites, Locations, by="Site_ID") 

#Surface Accretion data 
SA <- inner_join(SA_Layers, SAccret, by="Layer_ID")

#SET Rod data
SET <- inner_join(SETdata, Positions, by="Position_ID")

# Sampling events and sites
# join site-location data with sampling 'events'
Samplings <- inner_join(StudyStations, Events, by= "Location_ID") 

# Complete datasets with ALL variables
SA.data <- inner_join(SA, Samplings, by="Event_ID")
SET.data <- inner_join(SET, Samplings, by="Event_ID")

# Remove excess dataframes leaving only SA and SET data ----
rm(Events,
   Positions,
   SA,
   SA_Layers,
   SAccret,
   SET,
   SETdata,   
   Samplings,
   Sites,
   Locations
   )
## @knitr MungeSETVariables

# list of Notes regarding issues with pin placement 
# removes <- c("deer trail", 'hole', 'Hole', )


# Complete SET data in a WIDE format ----
# Trim excess columns and clean charcter strings.
SET.data <- SET.data %>% tbl_df() %>% select(Pin1:Pin9_Notes, Arm_Direction, Site_Name, SET_Type, Stratafication:Plot_Name, Position_ID, X_Coord, Y_Coord, Start_Date) %>% 
	mutate(Stratafication = capwords(as.character(Stratafication)), Start_Date = as.Date(Start_Date))    # Eventually add a filter that will filter out only 'clean' readings
	
attr(SET.data, 'Datainfo') <-"Full SET dataset including all measures in a WIDE format" # give dataframe some metadata attributes

# Complete SET dataset in a LONG format ----
SET.data.long <- SET.data %>% 
	droplevels() %>% 
	select(Site_Name, Stratafication, Plot_Name, SET_Type, num_range("Pin", 1:9), Arm_Direction, Position_ID, Start_Date) %>% 
	gather("Pin", "Raw", 5:13) %>% 
	group_by(Position_ID, Pin) %>% 
	rename(Date = Start_Date) %>%  # rename SET reading date
	mutate(EstDate = min(Date)) %>%  # create a column identifying the EstDate (date of SET-MH station establishment/first reading)
	arrange(Date) %>% 
	mutate(Change = as.numeric(Raw - Raw[1]),
	       incrementalChange = c(NA, diff(Change))) %>% 
	ungroup() %>% 
	mutate(DecYear = round((((as.numeric(difftime(.$Date, .$EstDate, units = "days"))))/365),3))
attr(SET.data.long, 'Datainfo') <-"Full SET dataset including all measures in a LONG format" # give dataframe some metadata attributes


# Clean outliers and 'issues' at time of reading ----
# Two strategies- 1) drop complete time series for a pin that has an 'issue' at any one point in the series, vs 2) drop only that data point that has an issue.
# Or a merger of both stratagies.... 
# For holes: drop the whole timeseries
# For others: drop only that value

# Create a list of pins that have a note regarding an issue ----
pinlistCleandf <- SET.data %>% select(ends_with("_Notes"), Position_ID) %>% select(1:9, Position_ID) %>% 
	gather('pin', 'note', -Position_ID) %>% filter(!is.na(note))

pinlistClean <- unique(pinlistCleandf$Position_ID)

# SET data cleaned of any pins that have an 'issue' in the timeseries- Most restrictive dataset strategy 1 from above. ----

SET.data.cleanV1 <- SET.data %>% 
	filter(!Position_ID %in% pinlistClean) %>% 
	droplevels() %>% 
	select(Site_Name, Stratafication, Plot_Name, SET_Type, num_range("Pin", 1:9), Arm_Direction, Position_ID, Start_Date) %>% 
	gather("Pin", "Raw", 5:13) %>% 
	group_by(Position_ID, Pin) %>% 
	rename(Date = Start_Date) %>%  # rename SET reading date
	mutate(EstDate = min(Date)) %>%  # create a column identifying the EstDate (date of SET-MH station establishment/first reading)
	arrange(Date) %>% 
	mutate(Change = as.numeric(Raw - Raw[1]),
	       incrementalChange = c(NA, diff(Change))) %>% 
	ungroup() %>% 
	mutate(DecYear = round((((as.numeric(difftime(.$Date, .$EstDate, units = "days"))))/365),3))

attr(SET.data.compclean, 'Datainfo') <- "Any pin with a 'history of an issue' has been dropped" # edit metadata

# SET data cleaned of any measures of a pin that had an issue ----

SET.data.cleanV2 <- SET.data %>% 
	select(Site_Name, Stratafication, Plot_Name, SET_Type, starts_with("Pin"), Arm_Direction, Position_ID, Start_Date)  %>% 
	gather("key", "value", 5:22) %>%  separate(col = key, into = c("pin", "notes"), sep = "_", remove = T) %>% separate(pin, into = c("p","pinnumb"), sep = 3) %>% spread(p, value = value)



	group_by(Position_ID, Pin) %>% 
	rename(Date = Start_Date) %>%  # rename SET reading date
	mutate(EstDate = min(Date)) %>%  # create a column identifying the EstDate (date of SET-MH station establishment/first reading)
	arrange(Date) %>% 
	mutate(Change = as.numeric(Raw - Raw[1]),
	       incrementalChange = c(NA, diff(Change))) %>% 
	ungroup() %>% 
	mutate(DecYear = round((((as.numeric(difftime(.$Date, .$EstDate, units = "days"))))/365),3))

attr(SET.data.compclean, 'Datainfo') <- "Any pin with a 'history of an issue' has been dropped" # edit metadata


# Identifiers used for reshape ----
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



# Use reshape2 to melt wide table down to a long format (really only transposing the pin readings) =====
# Eventually migrate to tidyr for speed and ease of reading code.
SET.data.Melt <- melt(SET.data, id= iders, na.rm=TRUE)
SET.data.Melt <- SET.data %>% gather()


## @knitr Dates
###
#  Munge dates to create sample date and establishment date---- 
#  
# Rename 'Start_Date' to just 'Date' to remove confusing variable name
SET.data.Melt$Date <- as.Date((SET.data.Melt$Start_Date))

# Create column of 'establishment dates'= EstDate ----
# Date the site was first established
# Use ddply to split by Location_ID and find the first date read, record that in -$EstDate
SET.data.Melt <-ddply(SET.data.Melt,
                   .(Location_ID),
                   transform,
                   EstDate= (as.Date(min(Date)))) 

# Create variable DecYear- decimal years - in SET data, for regression analysis. 
# difftime- calculates the time difference between t1 and t2 in units identified

SET.data.Melt$DecYear <- round((((as.numeric(difftime(SET.data.Melt$Date, SET.data.Melt$EstDate, units = "days"))))/365),3)
SET.data.Melt <- plyr::rename(SET.data.Melt, c(value="Raw")) #rename 'value' to 'Raw'
SET.data.Melt <- SET.data.Melt[order(SET.data.Melt$Start_Date),]

# Calculates a 'change' used for plots primarily- regressions are run through 'raw' data to reduce chance of error. ----
SET.data.Melt <- ddply(SET.data.Melt, 
                    .(Position_ID,
                      variable), 
                    mutate, 
                    change = as.numeric(Raw-Raw[1]),
		    incrementalChange = c(NA, diff(change)))
## @knitr SAdata
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
SA.data.M <- plyr::rename(SA.data.M, c(value="Accretion")) #rename 'value' to 'Accretion'



### All clear to hear-- 07Mar2014- AFS -----

