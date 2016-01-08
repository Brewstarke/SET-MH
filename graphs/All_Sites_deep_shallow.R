## @knitr Plot2

## Plot of sites elevation trends through time in a grid (faceted) layout. Showing points, connected by pin/direction/site
# This script is pulled into knitr reports found in the ~/reports folder

require(ggplot2)
require(ggthemes)
require(plyr)
library(plotly)
set_credentials_file("gumbo71", "dchur7plbf")

SiteNames <- as.vector(unique(SET.data$Site_Name))

# 
# [1] Bass Creek                       
# [2] Mashomack Point                  
# [3] Pine Neck                        
# [4] Accabonac Harbor                 
# [5] Indian Island                    
# [6] Hubbard Creek                    
# [7] North Greensedge - West Hempstead
# [8] Lawrence Marsh                   
# [9] Cedar Beach                      
# [10] West Pond                        
# [11] East Creek                       
# [12] Flax Pond                        
# [13] Frost Creek 



PlotData <- SET.data.Melt %>% 
	filter(Site_Name %in% SiteNames[10:13]) %>% 
	droplevels()

# PlotData$SiteNameF <- factor(PlotData$Site_Name, levels = c("North Greensedge - West Hempstead" , "Lawrence Marsh", "Mashomack Point", "Cedar Beach"))


SET_Plot2 <- ggplot(data=PlotData, aes(y = change, x = Start_Date, color = interaction(SET_Type, Stratafication))) 

SET_Plot2 + 
  # theme_bw(base_family="serif") + 
	theme_few(base_size = 14)  + 
	theme(legend.position = "right", legend.title=element_blank(), legend.direction = "vertical") +
	guides(colour = guide_legend(override.aes = list(alpha = 1), reverse = TRUE)) +
  	geom_point(alpha = 0.02, size = 0.5) +
  	facet_grid(. ~ SiteName) +
	stat_smooth(method = "loess", se = FALSE, data = PlotData, 
		    aes(y = change, x = Start_Date, color = interaction(SET_Type, Stratafication)), size = .5, alpha = 0.9) + 
	stat_smooth(method = "lm", se = TRUE, fill = "seashell", size = 1.5) +
	scale_color_brewer(type = div, palette = "Paired", name = "SET Type", labels = c("Deep SET", "Shallow SET")) +
	labs(list(title = "Hempstead  & Eastern Long Island Marshes \nComparison of Elevation Trends", y = "Elevation Change (mm)", x = "Date")) +
	ylim(-5,15) 
  #	geom_path(by = PlotData$ID, alpha=.02) 


# With Surface Accretion.
SET_Plot2 + 
	# theme_bw(base_family="serif") + 
	theme_few(base_size = 14)  + 
	theme(legend.position = "right", legend.title=element_blank(), legend.direction = "vertical") +
	guides(colour = guide_legend(override.aes = list(alpha = 1), reverse = TRUE)) +
	geom_point(alpha = 0.02, size = 0.5) +
	facet_grid(. ~ SiteNameF) +
	stat_smooth(method = "loess", se = FALSE, data = PlotData, aes(y = change, x = Start_Date, color = interaction(SET_Type, Stratafication)), size = .5, alpha = 0.9) + 
	stat_smooth(method = "lm", se = TRUE, fill = "seashell", size = 1.5) +
	scale_color_brewer(type = div, palette = "Paired", name = "SET Type", labels = c("Deep SET", "Shallow SET")) +
	labs(list(title = "Hempstead  & Eastern Long Island Marshes \nComparison of Elevation Trends", y = "Elevation Change (mm)", x = "Date")) +
	ylim(-5,15) +
	geom_point(data=SA_PlotData, aes(y = Accretion, x = as.Date(Start_Date), alpha= 0.05))



