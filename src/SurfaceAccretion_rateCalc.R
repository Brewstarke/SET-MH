# Analysis of Surface Accretion - Feldspar Plots 
#
#
#
#
# Find mean for each plot consisting of the average of the measures made on each plug (1 plug from each plot)

require(plyr)
require(xlsx)
library(dplyr)


#*************************************************************
# SA Slope calculator ---- slopeSAer
# Create a function that checks to see if there's enough data to calculate a linear regression, 
# and then regresses pin height across time (as decimal year) 

#*************************************************************
# 1.)
# Calculate slope using function slopeSAer created above ----
# Outputs average slope (read as annual rate mm/year) of change by Site, Stations, and Plot
# Plug mean by date, plot and station (locationID synonomyous with PlotName)

SA.plug.means <- SA.data.M %>% 
	select(Site_Name, Estab_Date, Stratafication, Plot_Name, Layer_Label, Start_Date, DecYear, Accretion) %>% 
	group_by(Site_Name, Stratafication, Plot_Name, Layer_Label, Start_Date) %>% 
	dplyr::summarise(plugMeanAccret = round(mean(Accretion), 3), 
		  plug_se= round(sqrt(var(Accretion,na.rm=TRUE)/length(na.omit(Accretion))), 3),
		  DecYear = (DecYear[1]), 
		  sampleDate = Estab_Date[1])  # to carry over the DecYear and Estab_date the group_by must select just the first value [1] as some plugs only had one measure available.

# Each plot measure (plugMeanAccret) is regressed against time (DecYear) to generate 3 slopes which will be used to summarize the station

SA.plot.regress <- SA.plug.means %>% 
	select(Site_Name, sampleDate, Stratafication, Plot_Name, Layer_Label, Start_Date, DecYear, plugMeanAccret) %>% 
	group_by(Site_Name, Stratafication, Plot_Name, Layer_Label) %>% 
	do(slopeSAer(.))


# regress mean plug 'height' against Dec_year to find slope or rate mm/year
# 
# meanslope.Accret <- ddply(.data= SA.plug.means, 
#                           .(Location_ID, 
#                             Site_Name, 
#                             Stratafication, 
#                             Layer_Label, 
#                             Plot_Name), 
#                           slopeSAer)
# 
# SA.plot.means <- ddply(.data= meanslope.Accret,
#                        .(Location_ID, 
#                          Site_Name, 
#                          Stratafication, 
#                          Plot_Name),
# 											 plyr::summarize,
#                        plot_mean = round(mean(slope,na.rm=TRUE),digits= 3), 
#                        plot_SE= round(sqrt(var(slope,na.rm=TRUE)/length(na.omit(slope))), digits= 3)
#                        )
# 
# # Join to get Station info-
# SA.plot.means <- join(x= SA.plot.means, y= StudySites, by= "Location_ID", type= "left")
# SA.station.means <- SA.plot.means[,3:6]
# SA.plot.means <- SA.plot.means[,3:36]

#Use plot means to calculate station means-

# 
# SA.site.means <- plyr::ddply(.data=SA.plot.means, 
#                           .(Site_Name, 
#                             Stratafication), # Same as above, add Layer_ID as it's unique to the station level (effectively averaging the plots from above)
# 			     plyr::summarize, 
#                           site_Mean= round(mean(plot_mean, na.rm=TRUE), digits= 3), 
#                           site_SE= round(stder(plot_mean), digits= 3)
#                        )
# 
# SA.site.means <- plyr::rename(SA.site.means, replace=c(site_Mean = "Mean_Accretion_Rate", site_SE = "SE of mean Accrretion mm/yr"))
# 
# 
# write.xlsx(x= SA.site.means, file="reports/SArates.xls")



# Good to here- AFS 11Mar2014

