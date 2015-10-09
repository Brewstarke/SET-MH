#### Overlay plot 2
# Plotting 'raw' numbers across time.

SET_Plot_overlay2 <- function(SET_Type = 'Rod SET', highlightSite = NULL, title)
{
	require(ggplot2)
	require(ggthemes)
	require(plyr)
	require(reshape2)
	
	title <- title
	data <- SET.data.Melt[(SET.data.Melt$SET_Type == SET_Type),] # Subset the data type
	
	# Add control structure to ensure Site is available to select.
	
	data$highlight <-  data$Site_Name == highlightSite
	
	SET_Plot2 <- ggplot(data= data, aes(y = Raw, 
					    x = Date, 
					    color= interaction(Site_Name, 
					    		   Stratafication, 
					    		   SET_Type, 
					    		   sep= " "), 
					    #color = highlight,
					    alpha= 0.5)) 
	
	SET_Plot2 + 
		theme_bw(base_family="serif") +
		stat_smooth(method = loess, size = .75,  se = FALSE) +
		#annotate("text", y= 10, label = "Some text")+
		#geom_point(alpha = 0.1) +
		#geom_path(alpha = 0.1) +
		#facet_wrap( ~ Site_Name) +
		labs(list(title = title,
			  y = "Relative Elevation of marsh surface (mm)", 
			  x = "Date")) +
		#ylim(-15,40) +
		theme(legend.position= "none")
	
	
}

SET_Plot_overlay2(SET_Type = "Rod SET", highlightSite = c("North Greensedge - West Hempstead", "Lawrence Marsh"), title = "Marsh elevation changes across LI")
