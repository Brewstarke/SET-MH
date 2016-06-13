# Elevation Survey Maps	
library(leaflet)
library(dplyr)
library(tidyr)
library(magrittr)
library(htmltools)

sharpElevationPts %>% 
	leaflet() %>% 
	addProviderTiles('MapQuestOpen.Aerial') %>% 
	addMarkers(lng = ~point_x, lat = ~point_y, popup = ~as.character(rtk_elv))

