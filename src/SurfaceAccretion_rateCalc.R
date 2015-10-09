# Analysis of Surface Accretion - Feldspar Plots 
#
#
#
#
# Find mean for each plot consisting of the average of the measures made on each plug (1 plug from each plot)

require(plyr)
require(xlsx)


#*************************************************************
# 1.)
# Calculate slope using function slopeSAer created above ----
# Outputs average slope (read as annual rate mm/year) of change by Site, Stations, and Plot
SA.plug.means <- ddply(.data= SA.data.M, # Average depth for each plug cut
                       .(Site_Name, 
                         Stratafication, 
                         Layer_Label, 
                         Start_Date, 
                         Location_ID,
                         Plot_Name),
		       plyr::summarize,
                       Dec_year= mean(DecYear),
                       plug_mean= round(mean(Accretion), digits= 3),
                       plug_se= round(sqrt(var(Accretion,na.rm=TRUE)/length(na.omit(Accretion))))
                      )

# regress mean plug 'height' against Dec_year to find slope or rate mm/year
meanslope.Accret <- ddply(.data= SA.plug.means, 
                          .(Location_ID, 
                            Site_Name, 
                            Stratafication, 
                            Layer_Label, 
                            Plot_Name), 
                          slopeSAer)

SA.plot.means <- ddply(.data= meanslope.Accret,
                       .(Location_ID, 
                         Site_Name, 
                         Stratafication, 
                         Plot_Name),
											 plyr::summarize,
                       plot_mean = round(mean(slope,na.rm=TRUE),digits= 3), 
                       plot_SE= round(sqrt(var(slope,na.rm=TRUE)/length(na.omit(slope))), digits= 3)
                       )

# Join to get Station info-
SA.plot.means <- join(x= SA.plot.means, y= StudySites, by= "Location_ID", type= "left")
SA.station.means <- SA.plot.means[,3:6]
SA.plot.means <- SA.plot.means[,3:36]

#Use plot means to calculate station means-


SA.site.means <- plyr::ddply(.data=SA.plot.means, 
                          .(Site_Name, 
                            Stratafication), # Same as above, add Layer_ID as it's unique to the station level (effectively averaging the plots from above)
			     plyr::summarize, 
                          site_Mean= round(mean(plot_mean, na.rm=TRUE), digits= 3), 
                          site_SE= round(stder(plot_mean), digits= 3)
                       )

SA.site.means <- plyr::rename(SA.site.means, replace=c(site_Mean = "Mean_Accretion_Rate", site_SE = "SE of mean Accrretion mm/yr"))


write.xlsx(x= SA.site.means, file="reports/SArates.xls")



# Good to here- AFS 11Mar2014

