## @knitr Plot_multiLMs

## Plot of sites elevation trends through time in a grid (faceted) layout. Showing points, connected by pin/direction/site
# This script is pulled into knitr reports found in the ~/reports folder

require(ggplot2)
require(ggthemes)
require(plyr)
require(reshape2)



SET_Plot_facetted <- function()
	{
	require(ggplot2)
	require(ggthemes)
	require(plyr)
	require(reshape2)
	
SET_Plot2 <- ggplot(data=SET.data.Melt, aes(y = change, 
                                         x = Date, color= interaction(Stratafication, SET_Type, sep= " "))) 

SET_Plot2 + 
	theme_bw(base_family="serif") +
	geom_point(alpha= 0.15) + 
	stat_smooth(method="lm", size = 1.5, alpha = 1) +
	facet_wrap( ~ Site_Name) +
	labs(list(title = "Marsh Elevation Trends- TNC Long Island Sites", 
		  y = "Elevation Change (mm)", 
		  x = "Date",
		  colour = "Marsh and SET Type")) +
	ylim(-15,40) +
	theme(legend.position= "bottom")

	}
SET_Plot_facetted()


#### Overlay plot

SET_Plot_overlay <- function(SET_Type = 'Rod SET', highlightSite = NULL)
	{
	require(ggplot2)
	require(ggthemes)
	require(plyr)
	require(reshape2)
	
	
	data <- SET.data.Melt[(SET.data.Melt$SET_Type == SET_Type),] # Subset the data type
	
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
	end <- max(data$Date)
	SET_Plot2 + 
		theme_bw(base_family="serif") +
		stat_smooth(method = loess, size = .75,  se = FALSE) +
		#annotate("text", y= 10, label = "Some text")+
		#geom_point(alpha = 0.1) +
		#geom_path(alpha = 0.1) +
		#facet_wrap( ~ Site_Name) +
		labs(list(title = "Marsh Elevation Trends Across LI",
			  y = "Elevation Change (mm)", 
			  x = "Date")) +
		ylim(-15,40) +
		scale_x_date(limits = c(as.Date("2013-1-1"), end))+
		theme(legend.position= "none")
		
	
}

SET_Plot_overlay(SET_Type = "Rod SET", 
		 highlightSite = c("North Greensedge - West Hempstead", "Lawrence Marsh"))
