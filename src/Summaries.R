## Summary Tables and Plots
library(xlsx)
library(reshape2)
library(plyr)
library(dplyr)
library(tidyr)

SummaryTable <- join(y= SA.site.means,  
		     x= SET.site.means, 
		     by= c("Stratafication", "Site_Name"), 
		     type= "left")

SummaryTable$SubSurface_change <- SummaryTable$Mean_elevation_change - SummaryTable$Mean_Accretion_Rate

attr(SummaryTable, "doc")  <- "Summary Table is the accumulation of SET and MH mean rates and associated SE's. 
				SubSurface_change: mean elevation change - mean accretion rate
				Sample N: number of SET readings"


SiteVisits <- SET.data.Melt %>%
	#ungroup() %>%
	group_by(Site_Name, Stratafication, SET_Type) %>%
	dplyr::summarise('Sample N' = n_distinct(Start_Date))

# Add site visits 
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

SummaryTable_wide <- melt(data= SummaryTable, 
		    id.var= c("Site_Name", "Stratafication", "SET_Type"), 
		    measure.var= c("Sample N", "Mean_elevation_change", "SE_ofmeanrate", "Mean_Accretion_Rate", "SE of mean Accrretion mm/yr", "SubSurface_change"), na.rm=TRUE)

SummaryTable_wide <- dcast(data=SummaryTable_wide, formula= Site_Name + Stratafication ~ ...)

write.xlsx(x= SummaryTable_wide, file="reports/Site_Summary_Table.xls", append= FALSE)


# save environment for app-
save.image("~/R_Code/SET-MH_Analysis/.RData")
