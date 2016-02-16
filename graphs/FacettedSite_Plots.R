

SET_Plot_overlayvert <- function(highlightSite = NULL, title)
{
	require(ggplot2)
	require(ggthemes)
	require(scales)
	
	title <- title
# 	data <- SET.data.M[(SET.data.M$SET_Type == SET_Type),] # Subset the data type - removed to add faceting on this variable
	data <- SET.data.compclean
		SiteOrder <- unique(SET.data.compclean$Site_Name)[c(9,8,1:2, 4, 6, 7, 3, 5)]
			data$Site_Name <- factor(data$Site_Name, levels= SiteOrder) 
	
	# Add control structure to ensure Site is available to select.
	#	data$highlight <-  as.factor(data$Site_Name != highlightSite)
	
	SET_Plot2 <- ggplot(data= data, aes(y = Change, 
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
		#stat_smooth(method= loess, se= FALSE, size= .5, alpha = 1) + 
	
		facet_wrap( ~ Site_Name, ncol = 3) +
		scale_x_date(breaks = "6 months", 
			     labels=date_format("%Y"), 
			     limits = as.Date(c('2008-10-01','2015-10-01'))) + 
		
		theme_bw(base_family="serif") + 
		theme(legend.position= "none") +
		theme(axis.title.x = element_text(size=12),
							axis.text.x  = element_text(angle=90, vjust=0.5, size=12))+
		
		labs(list(title = title, 
			  y = "Relative Elevation of marsh surface (mm)", 
			  x = "Date")) 
		
	SET_Plot2A
}
#####

##


SET_Plot_overlayvert(highlightSite = c("North Greensedge - West Hempstead", "Lawrence Marsh"), title = "Marsh elevation change across LI")


#SET_Plot_overlayvert(highlightSite = c("Mashomack Point", "Bass Creek"), title = "Marsh elevation changes across LI")

SET_Plot_overlayvert(title = "Marsh Elevation Changes Across LI")

