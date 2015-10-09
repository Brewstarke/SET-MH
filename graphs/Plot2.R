## @knitr Plot2

## Plot of sites elevation trends through time in a grid (faceted) layout. Showing points, connected by pin/direction/site
# This script is pulled into knitr reports found in the ~/reports folder

require(ggplot2)
require(ggthemes)
require(plyr)

SET_Plot2 <- ggplot(data=SET.data.Melt, aes(y = change, x = Start_Date, color = interaction(SET_Type, Stratafication))) 

SET_Plot2 + 
  # theme_bw(base_family="serif") + 
	theme_fivethirtyeight(base_size = 14)  + 
  	geom_point(alpha= 0.02) +
  	facet_wrap(~Site_Name) +
	stat_smooth(method="loess", se = FALSE, data=SET.data.Melt, aes(y = change, x = Start_Date, color = interaction(SET_Type, Stratafication)), size = 1.2, alpha = 0.9) + 
	scale_color_brewer(type = div, palette = "Spectral") +
  	labs(list(title = "Marsh Elevation Trends- TNC Long Island Sites", y = "Elevation Change (mm)", x = "Date")) +
  	ylim(-15,40) +
  	geom_path(by=SET.data.Melt$ID, alpha=.02) 

