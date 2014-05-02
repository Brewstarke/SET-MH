## @knitr Plot2

## Plot of sites elevation trends through time in a grid (faceted) layout. Showing points, connected by pin/direction/site
# This script is pulled into knitr reports found in the ~/reports folder

require(ggplot2)
require(ggthemes)
require(plyr)

SET_Plot2 <- ggplot(data=SET.data.M, aes(y = change, x = Start_Date)) 

SET_Plot2 + 
  theme_bw(base_family="serif") + 
  theme(panel.margin = units(0, "lines"))  + 
  geom_point(alpha= 0.05) +
  facet_wrap(~Site_Name) +
  stat_smooth(method="lm", color = "mediumblue", size = 1, alpha = .7) + 
  labs(list(title = "Marsh Elevation Trends- TNC Long Island Sites", y = "Elevation Change (mm)", x = "Date")) +
  ylim(-15,40) +
  geom_path(by=SET.data.M$ID, alpha=.05) 

