###
#
# Data importing from SET_Monitoring_Database 'Backend Data Storage File' currently SET_DB_BE_ver_2.92_TNC_Master
# ProjectTemplate automatically runs this script, importing the dataframes below into the R workspace
#
###

SETout <- function(){ 
  # Load packages needed for import and reshaping
  require(RODBC)
  require(reshape2)
  require(RODBC)
  require(plyr)
  
  SET.DB.path <- file.choose()
  SET.DB <- odbcConnectAccess2007(SET.DB.path)
  
  ### Pull in the tables of interest containing data needed for analysis
  
  #Location data- i.e. study sites and stations within sites
  Sites <- sqlFetch(SET.DB, sqtable= "tbl_Sites")
  Locations <- sqlFetch(SET.DB, sqtable= "tbl_Locations")
  
  # Sampling events
  Events <- sqlFetch(SET.DB, sqtable= "tbl_Events")
  
  # SET Rod data
  Positions <- sqlFetch(SET.DB, sqtable= "tbl_SET_Position")
  SETdata<- sqlFetch(SET.DB, sqtable= "tbl_SET_Data")
  
  # Surface Accretion data
  SAccret <- sqlFetch(SET.DB, sqtable= "tbl_Accretion_Data") 
  SA_Layers <- sqlFetch(SET.DB, sqtable= "tbl_Feldspar_Layers")
  
  close(SET.DB) #close the connection to the Access SET database.
  #SQL type joins to create datasets with tangible identifiers
  
  #Study Sites with Locations data
  StudySites <- join(Sites, Locations, by="Site_ID", type="inner") 
  
  #Surface Accretion data
  SA <- join(SA_Layers, SAccret, by="Layer_ID", type= "inner")
  
  #SET Rod data
  SET <- join(SETdata, Positions, by="Position_ID", type= "inner")
  
  # Sampling events and sites
  # join site-location data with sampling 'events'
  Samplings <- join(StudySites, Events, by= "Location_ID", type="inner") 
  
  
  
  ###
  #
  # Munge the data tables pulled in from Access using the SET_data_imports script found in the ~/data folder. 
  # 
  ### 
  
  #
  # The list of names that Don and Jennifer want populated:
  # Will make list <- c(....)
  # Contact Name  Contact Email  Data Collector	Site Label	SET ID	Latitude (SET)	Longitude (SET)	SET Geographical Location	Month	Day	Year	SET Armature Position ID	pin1 (mm)	pin2 (mm)	pin3 (mm)	pin4 (mm)	pin5 (mm)	pin6 (mm)	pin7 (mm)	pin8 (mm)	pin9 (mm)	MH Replicate Number (within plot)	MH plot A (mm)	MH plot B (mm)	MH plot C (mm)	SET Notes	Marker Horizon Notes	
  #
  #
  #
  # Complete datasets with ALL variables
  SA.data <- join(SA, Samplings, by="Event_ID", type="inner")
  SET.data <- join(SET, Samplings, by="Event_ID", type= "inner")
  
  
  # Clean up SET.data dataframe and reshape to allow for analysis
  # 'keeps' is list of variable names to keep; 'iders' are identifier variables used in reshaping the dataframe
  keeps <- c("Event_ID", "Site_Name", "Stratafication", "Plot_Name", "Start_Date", "Pin1", "Pin2", "Pin3", "Pin4", "Pin5", "Pin6", "Pin7", "Pin8", "Pin9", "Arm_Direction", "Position_Name")
  iders <- c("Site_Name", "Stratafication", "Plot_Name", "Start_Date", "Arm_Direction", "Position_Name")
  SET.DATA <- SET.data[keeps]
  SET.data.M <- melt(SET.DATA, id= iders, na.rm=TRUE)  
  
  #should be good to go with analysis from here---- Analysis scripts found in "~/src" folder
  
  #Clean up SA.data dataframe and reshape; same as above but working on surface accretion data
  keepsA <- c("Layer_Label", "Estab_Date", "Measure_1", "Measure_2", "Measure_3", "Measure_4","Measure_5", "Measure_6", "Site_Name", "Stratafication", "Plot_Name", "Start_Date")
  SA.data <- SA.data[keepsA]
  idersSA <- c("Layer_Label", "Estab_Date", "Site_Name", "Stratafication", "Plot_Name", "Start_Date")
  SA.data.M <- melt(SA.data, id= idersSA, na.rm=TRUE)
  
  
  # CALCULATING SLOPE FOR PIN OVER TIME AND SUMMARIZING SLOPES BY POS. AND BY SET
  #
  # CREATE ID TO INDEX DATA BY SITE, PHASE, SET , POSITION AND PIN
  
  SET.data.M$ID <- paste(SET.data.M$Plot_Name, SET.data.M$Arm_Direction, SET.data.M$variable, sep="_")
  #SA.data.M$ID <- paste(SA.data.M$Site_Name, SA.data.M$Layer_Label, SA.data.M$Start_Date, sep="_")
  #SA.data.M$ID2 <- paste(SA.data.M$Site_Name, SA.data.M$Start_Date, sep="_")
  
  ###
  #  ADD BASELINE DATE TO DATA TABLE- 
  #  by creating column of 'establishment dates'= EstDate
  
  SET.data.M$Date <- (SET.data.M$Start_Date)
  #Date the site was first established
  
  
  try1 <- join(SA.data, SET.data, by= "Event_ID", type="inner")
                   
  
  
}





SET.data.M <-ddply(SET.data.M,
                   .(Plot_Name),
                   transform,
                   EstDate= (as.Date(min(Date)))) 

# Create variable DecYear- decimal years - in SET data, for regression analysis. 
SET.data.M$DecYear <- round((((as.numeric(difftime(SET.data.M$Date, SET.data.M$EstDate, units = "days"))))/365),3)
SET.data.M <- rename(SET.data.M, c(value="Raw")) #rename 'value' to 'Raw'


# Create variable DecYear- decimal years - in SA data, for regression analysis
SA.data.M$DecYear <- round((((as.numeric(difftime(SA.data.M$Start_Date, SA.data.M$Estab_Date, units = "days"))))/365),3)

#SA.data.M$DecYear <- round(((SA.data.M$Start_Date-SA.data.M$Estab_Date)/365),3)
SA.data.M <- rename(SA.data.M, c(value="Accretion")) #rename 'value' to 'Accretion'

SET.data.M <- ddply(SET.data.M, 
                    .(ID), 
                    transform, 
                    change = Raw-Raw[1])

#Clear unused data frames out
rm(StudySites, SET, Samplings,SA.data, SET.DATA, Events, Positions, SA, Locations, SA_Layers, SAccret, SET.data, Sites, SETdata, keeps, keepsA, SET.DB, config, iders, idersSA, project.info)

# standardize characters in Stratafication
SET.data.M$Stratafication <- as.character(SET.data.M$Stratafication)
SET.data.M$Stratafication <- as.factor(capwords(SET.data.M$Stratafication))
