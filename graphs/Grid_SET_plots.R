SET_Plot_grid <- function(highlightSite = NULL, title)
{
	require(ggplot2)
	require(ggthemes)
	require(plyr)
	require(reshape2)
	require(scales)
	
	title <- title
	# 	data <- SET.data.M[(SET.data.M$SET_Type == SET_Type),] # Subset the data type - removed to add faceting on this variable
	data <- SET.data.Melt
	SiteOrder <- unique(SET.data.Melt$Site_Name)[c(9,8,1:7)]
	data$Site_Name <- factor(data$Site_Name, levels= SiteOrder) 
	
	# Add control structure to ensure Site is available to select.
	data$highlight <-  as.factor(data$Site_Name == highlightSite)
	
	SET_Plot2 <- ggplot(data= data, aes(y = change, 
					    x = Date, color= Site_Name,
					    group= interaction(
					    	Site_Name, 
					    	Stratafication,
					    	SET_Type,
					    	sep= " "
					    )
	))
	
	
	SET_Plot2A <- SET_Plot2 + 
		
		stat_smooth(method = glm, size = 1,  se = FALSE) + 
		stat_smooth(method= loess, se= FALSE, size= .5, alpha = 1) + 
		
		facet_wrap( ~ Site_Name, ncol = 3) +
		scale_x_date(breaks = "6 months", 
			     labels=date_format("%Y"), 
			     limits = as.Date(c('2008-05-01','2014-12-01'))) + 
		
		theme_bw(base_family="serif") + 
		theme(legend.position= "none", axis.text.x  = element_text(angle=90, vjust=0.5, size=10)) +
		
		labs(list(title = title, 
			  y = "Relative Elevation of marsh surface (mm)", 
			  x = "Date")) 
	
	SET_Plot2A
}
#####

##


SET_Plot_grid(highlightSite = c("North Greensedge - West Hempstead", "Lawrence Marsh"), title = "Marsh elevation change across LI")
