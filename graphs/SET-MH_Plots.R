

SET_Plot_overlayvert <- function(plot_title)
{
	require(ggplot2)
	require(ggthemes)
	require(plyr)
	require(reshape2)
	require(scales)
	
	plot_title <- plot_title
	data <- SET.data.M[(SET.data.M$SET_Type == "Rod SET"),] # Subset the data type - removed to add faceting on this variable
	#data <- join(x = SET.data.M, y= SA.data.M, by = c("Site_Name", "Stratafication", "Plot_Name", "Start_Date"))
	data_01 <- SA.data.M
	data_01 <- plyr::rename(x = data_01, replace = c("Start_Date" = "Date", "Accretion" = "change"))
	SiteOrder <- unique(SET.data.M$Site_Name)[c(9,8,1:2, 4, 6, 7, 3, 5)]
	data$Site_Name <- factor(data$Site_Name, levels= SiteOrder) 
	
	# Add control structure to ensure Site is available to select.
	#data$highlight <-  as.factor(data$Site_Name != highlightSite)
	
	SET_Plot2 <- ggplot()
	
	SET_Plot2A <- SET_Plot2 + 		
		stat_smooth(data= data, # SET data
			    aes(y = change,
			        x = as.Date(Date),
			        color= interaction(Site_Name, 
				    		   Stratafication, sep = " "),
			        group= interaction(Site_Name, 
				    		   Stratafication,
				    		   sep= " ")),
			    method = glm,
			    se = FALSE, 
			    size = 1,
			    linetype= "dotted") + 
	    	stat_smooth(data= data_01, # SA data 
	    		    aes(y = change,
	    		        x = as.Date(Date),
	    		        color= interaction(Site_Name, 
	    		        		   Stratafication, sep = " "),
	    		        group= interaction(Site_Name,
	    		        		   Stratafication,
	    		        		   sep= " ")),
	    		    linetype= "solid",
	    		    size= 1,
	    		    method = glm,
	    		    se = FALSE) + 
		
		facet_wrap( ~ Site_Name, ncol = 3) +
		scale_x_date(breaks = "6 months", 
			     labels=date_format("%Y"), 
			     limits = as.Date(c('2011-10-01','2014-10-01'))) +
		theme_bw(base_family="serif") + 
		theme(legend.position= "none") +
		labs(list(title = plot_title, 
			  y = "Relative Elevation of marsh surface (mm)", 
			  x = "Date"))+
		scale_linetype_identity(name= "Monitoring Type", 
					guide= "legend", 
					labels = c("Overall Elevation", "Surface Accretion"))
	
	SET_Plot2A
}

#####

##

SET_Plot_overlayvert(plot_title = "Marsh Elevation Changes Across LI")
