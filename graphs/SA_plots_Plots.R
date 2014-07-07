SA_Plot_grid <- function(highlightSite = NULL, title)
{
	require(ggplot2)
	require(ggthemes)
	require(plyr)
	require(reshape2)
	require(scales)
	
	title <- title
	# 	data <- SET.data.M[(SET.data.M$SET_Type == SET_Type),] # Subset the data type - removed to add faceting on this variable
	data <- SA.data.M
	SiteOrder <- unique(SA.data.M$Site_Name)[c(8:7, 1:2, 4, 6, 9, 3, 5)]
	data$Site_Name <- factor(data$Site_Name, levels= SiteOrder) 
	
	# Add control structure to ensure Site is available to select.
	data$highlight <-  as.factor(data$Site_Name == highlightSite)
	
	S <- ggplot(data= data, aes(y = Accretion, 
					    x = as.Date(Start_Date), color= Site_Name,
					    group= interaction(
					    	Site_Name, 
					    	Stratafication,
					    	sep= " "
					    )
	))
	
	
	SA <- S + 
		
		stat_smooth(method = glm, size = 1,  se = FALSE) + 
		#stat_smooth(method= loess, se= FALSE, size= .5, alpha = 1) + 
		
		facet_wrap( ~ Site_Name, ncol = 3) +
		scale_x_date(breaks = "1 year", 
			     labels=date_format("%Y"), 
			     limits = as.Date(c('2008-10-01','2014-10-01'))) + 
		theme_bw(base_family="serif") + 
		theme(legend.position= "none") +
		
		labs(list(title = title, 
			  y = "Accretion on marsh surface (mm)", 
			  x = "Date")) 
	
	SA
}
#####

##


SA_Plot_grid(highlightSite = c("North Greensedge - West Hempstead", "Lawrence Marsh"), title = "Marsh Accretion Across LI")
