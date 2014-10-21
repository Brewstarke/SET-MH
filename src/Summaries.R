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

SiteVisits <- SET.data %>%
		group_by( Site_Name, Stratafication, SET_Type ) %>%
		summarise("Sample N" = length(unique(Start_Date)))

SummaryTable <- join(x= SiteVisits, 
		     y= SummaryTable, 
		     by= c("Stratafication", "Site_Name", "SET_Type"))

SummaryTableCoords <- join(x= SummaryTable, y= StudySites, by= "Site_Name", type= "left", match= 'first')
SummaryTableCoords <- SummaryTableCoords[,c(1:9,18, 21:26)]

write.xlsx(x= SummaryTableCoords, file="reports/Summary_Table.xls", append= FALSE)

## Plot means Summary

PlotSummaryTable <- join(y= SA.plot.means,  
		     x= SET.station.means, 
		     by= c("Stratafication", "Plot_Name"), 
		     type= "left")

# PlotSummaryTable$SubSurface_change <- PlotSummaryTable$meanslopes - PlotSummaryTable$plot_mean

write.xlsx(x= PlotSummaryTable, file="reports/Stations_Summary_Table.xls", append= FALSE)

SummaryTemp <- melt(data= SummaryTable, 
		    id.var= c("Site_Name", "Stratafication", "SET_Type"), 
		    measure.var= c("Sample N", "Mean_elevation_change", "SE_ofmeanrate", "Mean_Accretion_Rate", "SE of mean Accrretion mm/yr", "SubSurface_change"), na.rm=TRUE)

SummaryTemp2 <- dcast(data=SummaryTemp, formula= Site_Name + Stratafication ~ ...)

write.xlsx(x= SummaryTemp2, file="reports/Site_Summary_Table.xls", append= FALSE)

