## Summary Tables and Plots
require(xlsx)
require(reshape2)
require(plyr)
require(dplyr)

SummaryTable <- join(SA.site.means, SET.site.means, by= c("Stratafication", "Site_Name", "SET_Type"))

SummaryTable$SubSurface_change <- SummaryTable$Mean_elevation_change - SummaryTable$Mean_Accretion_Rate

SiteVisits <- SET.data %.%
									group_by( Site_Name, Stratafication ) %.%
									summarise("Sample N" = length(unique(Start_Date)))

SummaryTable <- join(SiteVisits, SummaryTable, by= c("Stratafication", "Site_Name"))

SummaryTableCoords <- join(x= SummaryTable, y= StudySites, by= "Site_Name", type= "left", match= 'first')
SummaryTableCoords <- SummaryTableCoords[,c(1:8, 20:21, 37)]

write.xlsx(x= SummaryTableCoords, file="reports/SummaryTable.xls", append= FALSE)

