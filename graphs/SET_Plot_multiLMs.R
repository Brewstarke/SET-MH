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
	
SET_Plot2 <- ggplot(data=SET.data.M, aes(y = change, 
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


#### Overlay plot

SET_Plot_overlay <- function(SET_Type = 'Rod SET', highlightSite)
	{
	require(ggplot2)
	require(ggthemes)
	require(plyr)
	require(reshape2)
	
	
	data <- SET.data.M[(SET.data.M$SET_Type == SET_Type),] # Subset the data type
	
	SET.data.M$highlight <- for (i in seq(length(SET.data.M$Site_Name))){
		
		
	if(SET.data.M$Site_Name== "Mashomack"){
		SET.data.M$highlight = 1
	} else {
		SET.data.M$highlight = 0
	}
}
	
	SET_Plot2 <- ggplot(data= data, aes(y = change, 
						 x = Date, 
						 linetype= interaction(Site_Name, 
						 		      Stratafication, 
						 		      SET_Type, 
						 		      sep= " "), 
						 color= SET.data.M$highlight)) 
	
	SET_Plot2 + 
		theme_bw(base_family="serif") +
		# geom_point(alpha= 0.15) + 
		stat_smooth(method = loess, size = 1, alpha = .25, se = FALSE) +
		
		labs(list(title = "Marsh Elevation Trends- TNC Long Island Sites- ", 
			  y = "Elevation Change (mm)", 
			  x = "Date",
			  colour = "Marsh and SET Type")) +
		ylim(-15,40)
		#theme(legend.position= "bottom")
	
}
