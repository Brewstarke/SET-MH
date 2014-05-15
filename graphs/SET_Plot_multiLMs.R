## @knitr Plot_multiLMs

## Plot of sites elevation trends through time in a grid (faceted) layout. Showing points, connected by pin/direction/site
# This script is pulled into knitr reports found in the ~/reports folder

library(ggplot2)
library(ggthemes)
library(plyr)
library(reshape2)

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
	ylim(-15,40) 


