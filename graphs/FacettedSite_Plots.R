

SET_Plot_overlayvert <- function(SET_Type = 'Rod SET', highlightSite = NULL, title)
{
	require(ggplot2)
	require(ggthemes)
	require(plyr)
	require(reshape2)
	require(scales)
	
	title <- title
	data <- SET.data.M[(SET.data.M$SET_Type == SET_Type),] # Subset the data type
	
	# Add control structure to ensure Site is available to select.
	
	data$highlight <-  data$Site_Name == highlightSite
	
	SET_Plot2 <- ggplot(data= data, aes(y = change, 
					    x = Date, 
					    group= interaction(Site_Name, 
					    		   Stratafication, 
					    		   SET_Type, 
					    		   sep= " "), 
					    color = highlight,
					    alpha= 0.5)) 
	
	SET_Plot2 + 
		theme_bw(base_family="serif") +
		stat_smooth(method = loess, size = .75,  se = FALSE) +
		#annotate("text", y= 10, label = "Some text")+
		#geom_point(alpha = 0.1) +
		#geom_path(alpha = 0.1) +
		facet_grid( . ~ Site_Name) +
		labs(list(title = title,
			  y = "Relative Elevation of marsh surface (mm)", 
			  x = "Date")) +
		scale_x_date(breaks = "1 year", 
			     labels=date_format("%Y"),
			     limits = as.Date(c('2011-01-01','2014-10-01'))) +
		theme(legend.position= "none")
	
	
}

SET_Plot_overlayvert(SET_Type = "Rod SET", highlightSite = c("North Greensedge - West Hempstead", "Lawrence Marsh"), title = "Marsh elevation changes across LI")
