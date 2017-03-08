###
#
# Munge the data tables pulled in from Access using the SET_data_imports script found in the ~/data folder. 
# 
### 
## @knitr MungeTables
#SQL type joins to flatten the tables from the database. ----

#Study Sites with Locations data --Location_ID is a numeric key analagous to Plot_Name 
StudyStations <- left_join(Sites, Locations, by="Site_ID") # Change to a left join --@^*
StudyStationLocations <- StudyStations %>% select(Location_ID, Site_Name, Stratafication, Plot_Name, X_Coord, Y_Coord, Coord_System, UTM_Zone, Datum, SET_Type)

#Surface Accretion data 
SA <- inner_join(SA_Layers, SAccret, by="Layer_ID")

#SET Rod data
SET <- inner_join(SETdata, Positions, by="Position_ID")

# SET readers-  Gather up Event_ID, SET Reader and Contact_ID -- Then match up Contact ID with Contacts Last name-
Contacts %<>% select(Contact_ID, Last_Name, First_Name, Organization) %>% mutate(FullName = paste(First_Name, Last_Name, sep = " "))

SET_readers <- EventContacts %>% 
	left_join(Contacts, by = "Contact_ID") %>% 
	select(Event_ID, Contact_ID, Contact_Role, Last_Name, First_Name, Organization, FullName)%>% 
	mutate(ID = paste(Event_ID, Contact_ID, sep = "_")) %>% 
	spread(key = Contact_Role, value = FullName) %>% 
	dplyr::rename(SET_Reader = `SET Reader`) %>% 
	select(Event_ID, Last_Name, First_Name, Organization, SET_Reader) %>% 
	filter(complete.cases(.))


# Sampling events and sites
# join site-location data with sampling 'events'
Samplings <- inner_join(StudyStations, Events, by= "Location_ID") 
Samplings <- inner_join(Samplings, SET_readers, by = "Event_ID")


# Complete datasets with ALL variables
SA.data <- inner_join(SA, Samplings, by="Event_ID")
SET.data <- inner_join(SET, Samplings, by="Event_ID")

# Remove excess dataframes leaving only SA and SET data ----
rm(Events,
   Contacts,
   EventContacts,
   SET_readers,
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
SET.data %<>% tbl_df() %>% 
	select(Pin1:Pin9_Notes, Arm_Direction, Site_Name, SET_Type, Stratafication:Plot_Name, Location_ID.x, Position_ID, Start_Date, Organization, SET_Reader) %>% 
	mutate(Stratafication = capwords(as.character(Stratafication)), Start_Date = as.Date(Start_Date))     # Eventually add a filter that will filter out only 'clean' readings
	
attr(SET.data, 'Datainfo') <-"Full SET dataset including all measures in a WIDE format" # give dataframe some metadata attributes

# Complete SET dataset in a LONG format ----
SET.data.long <- SET.data %>%
	select(Site_Name, Stratafication, Plot_Name, SET_Type, Pin1:Pin9_Notes, Arm_Direction, Location_ID.x, Position_ID, Start_Date, SET_Reader)%>% 
	group_by(Position_ID, Start_Date) %>% 
	gather(pin, measure, Pin1:Pin9_Notes) %>% filter(!is.na(measure)) %>% # Remvoe NA from PinX_Notes 
	separate(pin, c('name', 'note'), "_", remove = TRUE) %>% 
	separate(name, c('name', 'Pin_number'), 3, remove = TRUE) %>% 
	mutate(key = ifelse(is.na(note),yes = "Raw", no = note)) %>% 
	select(-note, -name) %>% 
	spread(key, measure) %>% 
	mutate(pin_ID = paste(Position_ID, Pin_number, sep = "_")) %>% # Above all transposing and repositioning dataframe.
	ungroup() %>% # Below- adding columns, renaming variables, and reordering rows.
	dplyr::rename(Date = Start_Date, Location_ID = Location_ID.x) %>%  # rename SET reading date
	group_by(pin_ID) %>% # group by pinID to 
	mutate(EstDate = min(Date)) %>%  # create a column identifying the EstDate (date of the first SET-MH station reading)
	arrange(Date) %>% # arrange by date
	mutate(Change = as.numeric(Raw) - as.numeric(Raw[1]), 
	       incrementalChange = c(NA, diff(Change))) %>% # add column of incremental change
	ungroup() %>% 
	mutate(DecYear = round((((as.numeric(difftime(.$Date, .$EstDate, units = "days"))))/365),3))

attr(SET.data.long, 'Datainfo') <-"Full SET dataset including all measures in a LONG format" # give dataframe some metadata attributes


# Clean outliers and 'issues' at time of reading ----
# Two strategies- 1) drop complete time series for a pin that has an 'issue' at any one point in the series, 
# vs 2) drop only that data point that has an issue.
# Or a merger of both stratagies.... 
# For holes: drop the whole timeseries
# For others: drop only that value

# Create a list of pins that have a note regarding an issue ----
troublePins <- SET.data.long %>% ungroup() %>% 
	select(Notes, pin_ID) %>% 
	filter(complete.cases(.)) %>% 
	`attr<-`("Datainfo", "List of pins that have reported issues (holes, etc)")

pinlistClean <- unique(troublePins$pin_ID)

# SET data cleaned of any pins that have an 'issue' in the timeseries- Most restrictive dataset strategy 1 from above. ----

	
SET.data.cleanV1 <- SET.data.long %>% 
	filter(!pin_ID %in% troublePins$pin_ID) %>% 
	droplevels()


attr(SET.data.cleanV1, 'Datainfo') <- "Any pin with a 'history of an issue' has been dropped" # edit metadata

# SET data cleaned of any measures of a pin that had an issue ----
SET.data.cleanV2 <- SET.data.long %>%
	filter(is.na(Notes))%>% 
	droplevels()

attr(SET.data.cleanV2, 'Datainfo') <- "Any individual pin reading with a 'an issue' has been dropped" # edit metadata

# SET data cleaned of any pins that were in a hole or on a mussel.
bigIssues <- c("Hole", "hole", "mussel", "Holr", "Shell", "Mussel", "edge of hole", "hole next to mussel")
bigIssuePins <- troublePins %>% filter(Notes %in% bigIssues)


SET.data.cleanV3 <- SET.data.long %>% 
	filter(!pin_ID %in% bigIssuePins$pin_ID)%>% # Filter OUT the pins that have been recorded on a shell/hole/mussel
	droplevels()

attr(SET.data.cleanV3, 'Datainfo') <- "Any individual pin reading taken atop a hole or mussle has been dropped" # edit metadata

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



## @knitr SAdata
###
# Surface Accretion  -----
#
#Clean up SA.data dataframe and reshape; same as above but working on surface accretion data
# similar steps as SET.data

SA.data.long <- SA.data %>% gather('measure', 'Accretion', Measure_1:Measure_6) %>% 
	filter(!is.na(Accretion)) %>% 
	select(Layer_ID, Layer_Label, Location_ID.x, Estab_Date, Start_Date, Accretion, Core_Type, Site_ID, Plot_Name, Organization) %>% 
	mutate(DecYear = round((((as.numeric(difftime(Start_Date, Estab_Date, units = "days"))))/365),3)) %>% 
	dplyr::rename(Date = Start_Date)





### All clear to hear-- 07Mar2014- AFS -----

