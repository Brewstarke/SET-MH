## Summary Tables and Plots
require(xlsx)
require(reshape2)
require(plyr)
require(dplyr)

SummaryTable <- join(y= SA.site.means,  
		     x= SET.site.means, 
		     by= c("Stratafication", "Site_Name"), 
		     type= "left")

SummaryTable$SubSurface_change <- SummaryTable$Mean_elevation_change - SummaryTable$Mean_Accretion_Rate

SiteVisits <- SET.data %.%
		group_by( Site_Name, Stratafication, SET_Type ) %.%
		summarise("Sample N" = length(unique(Start_Date)))

SummaryTable <- join(x= SiteVisits, y= SummaryTable, by= c("Stratafication", "Site_Name", "SET_Type"))

SummaryTableCoords <- join(x= SummaryTable, y= StudySites, by= "Site_Name", type= "left", match= 'first')
SummaryTableCoords <- SummaryTableCoords[,c(1:9,18, 21:26)]

write.xlsx(x= SummaryTableCoords, file="reports/SummaryTable.xls", append= FALSE)

