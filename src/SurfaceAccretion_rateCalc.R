# Analysis of Surface Accretion - Feldspar Plots 
#
#
#
#
# Find mean for each plot consisting of the average of the measures made on each plug (1 plug from each plot)

require(plyr)
require(xlsx)


slopeSAer <- function(e) {                                              
  if(nrow(e) < 0) {return(data.frame(intercept = NA, slope = NA))     # if number of rows (data points) is less than 2 return NA's
  } else {                                                            # if there's enough data take data = e (which will be subsetted in later functions) then...
    p <-  coef(lm(plug_mean ~ Dec_year, data = e, na.action= na.omit))                    # regress the plug depth against time (decimal years) and return the coefficients of the regression- slope and intercept
    p <- data.frame(slope = round(p[2], digits= 4))                   # subset out just the slope coefficient from the object p
  }
  
} # this function is also found in '/helpers.R' 

#*************************************************************
# 1.)
# Calculate slope using function slopeer created above ----
# Outputs average slope (read as annual rate mm/year) of change by Site, Stations, and Plot
SA.plug.means <- ddply(.data= SA.data.M, # Average depth for each plug cut
                       .(Location_ID, 
                         Site_Name, 
                         Stratafication, 
                         Layer_Label, 
                         Start_Date, 
                         Plot_Name),
                       summarize,
                       Dec_year= mean(DecYear),
                       plug_mean= round(mean(Accretion), digits= 3),
                       plug_se= round(sqrt(var(Accretion,na.rm=TRUE)/length(na.omit(Accretion))))
                      )

# regress mean plug 'height' against Dec_year to find slope or rate mm/year
meanslope.Accret <- ddply(SA.plug.means, 
                          .(Location_ID, 
                            Site_Name, 
                            Stratafication, 
                            Layer_Label, 
                            Start_Date, 
                            Plot_Name), 
                          slopeSAer)



SA.plot.means <- ddply(.data= meanslope.Accret,
                       .(Location_ID, Plot_Name),
                       summarize,
                       plot_mean = round(mean(slope,na.rm=TRUE),digits= 3), 
                       plot_SE= round(sqrt(var(slope,na.rm=TRUE)/length(na.omit(slope))), digits= 3)
                       )

# Join to get Station info-
SA.plot.means <- join(x= SA.plot.means, y= StudySites, by= "Location_ID", type= "left")[, c(1:4, 7, 13,14, 16:21)]


#Use plot means to calculate station means-


SA.site.means <- ddply(.data=SA.plots.means, 
                          .(Site_Name, Stratafication), # Same as above, add Layer_ID as it's unique to the station level (effectively averaging the plots from above)
                          summarize, 
                          site_Mean= round(mean(plot_mean, na.rm=TRUE), digits= 3), 
                          site_SE= round(stder(plot_mean), digits= 3)
                       )

SA.site.means <- rename(SA.site.means, replace=c(site_Mean = "Mean_Accretion_Rate", site_SE = "SE_ofmeanAccrate"))


write.xlsx(x= SA.site.means, file="reports/SArates.xls")



# Good to here- AFS 11Mar2014