## @knitr DataLoad


###
# Data importing from SET_Monitoring_Database 'Backend Data Storage File' currently SET_DB_BE_ver_2.92_TNC_Master
# ProjectTemplate automatically runs this script, importing the dataframes below into the R workspace
#
###

library(RODBC)

SET.DB.path <- "T:/Coastal/Marsh-Wetlands/SET-MH_project/SET_Data/SET_Monitoring_Database/Database_storage/SET_DB_BE_ver_2.94_TNC_Master.mdb"


SET.DB <- odbcConnectAccess2007(SET.DB.path)

## @knitr DataTableLoad

### Pull in the tables of interest containing data needed for analysis ====
#Location data- i.e. study sites and stations within sites
Sites <- sqlFetch(SET.DB, sqtable= "tbl_Sites")
Locations <- sqlFetch(SET.DB, sqtable= "tbl_Locations")

# Sites and Locations will be joined in munge by 'site_ID'
# Use capwords function to standardize caps and revert Stratafication to as a factor
Locations$Stratafication <- as.factor(capwords((as.character(Locations$Stratafication))))

# Sampling events
Events <- sqlFetch(SET.DB, sqtable= "tbl_Events")

# Contacts/Field Personel
EventContacts <- sqlFetch(SET.DB, sqtable = "xref_Event_Contacts")
Contacts <- sqlFetch(SET.DB, sqtable = "tlu_Contacts")

# SET Rod data
Positions <- sqlFetch(SET.DB, sqtable= "tbl_SET_Position")
SETdata<- sqlFetch(SET.DB, sqtable= "tbl_SET_Data")

# Surface Accretion data
SAccret <- sqlFetch(SET.DB, sqtable= "tbl_Accretion_Data") 
SA_Layers <- sqlFetch(SET.DB, sqtable= "tbl_Feldspar_Layers")

close(SET.DB) #close the connection to the Access SET database.

## @knitr quiet
### END OF SET_data_imports.R script ###
#
# The datatables created here are then 'munged' in the scripts found in the ~/munge folder
#
###

