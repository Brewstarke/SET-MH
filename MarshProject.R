## 
# Start of SET analysis <<Project>> using R Studio Project utility and ProjectTemplate package
# 
# ProjectTemplate provides functions to automatically build a directory structure for a new R project. Using this
# structure, ProjectTemplate automates data loading, preprocessing, library importing and unit testing.
# for more info see:  http://projecttemplate.net
#
##

# for ProjectTemplate to properly run you must set the working directory to the folder 
# that contains this script (~/SET-MH_Analysis if folder name went unchanged)

#setwd("SET-MH_Analysis") 

library(ProjectTemplate)


load.project()

# Running the above triggers the data loading script "~/data/SET_data_imports.R"
# After loading the raw data, a 'munge' script "~/munge/SET_data_munge.R" runs 
# to clean data, rename some variables and organize the structure of the data as needed.

# Add an outlier, data QA/QC script here- Maybe a shinygadget? 


# SET data analysis pulled from the ~/src folder
## Need to update these source scripts ####
# source('src/SurfaceElevation_rateCalc.R')  ---- Relic code
source('src/ElevationTrends_alternativeTechnique.R') # replaces 'src/SurfaceElevation_rateCalc.R' AND 'src/SurfaceAccretion_rateCalc.R'

#Surface Accretion data analysis pulled from the ~/src folder

# Calculated an average accretion by plot (for each plot at each station) and a station average of those plot averages
# As well as a mean slope (accretion rate) for each plot-station.
# source('src/SurfaceAccretion_rateCalc.R') #  replaced with above (line 30)

# Create a summary table of the sites being monitored. 
source('src/Summaries.R')


# Run running regression analysis
source('src/SET_interval_calcs.R')

save.image('.RData')# Save everything in the environment to the local project folder

# Quick hack to get Marsh_App working.
studysites <- unique(SummaryTable$Site_Name)
names(studysites) <- studysites
studysites <- as.vector(studysites)

# Save selected data for marsh app.
save(SET.data.Melt,
     studysites,
     SA.data.M,
     SummaryTableCoords,
     SummaryTable_wide,
     intervalSET, 
     SummaryTable, 
     file = '~/R_Code/SET_app/appData.Rdata')




