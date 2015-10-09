# MAPS!!
#  
# Leaflet maps
#
####

library(leaflet)
library(rgdal)
library(rgeos)
library(sp)
library(dplyr)
library(htmltools)

## Shapefile Data Loading
#

wetlands.shp <- readOGR(".","dfw_tidal_wetlands", encoding = "ESRI Shapefile")

wetlands.shp <- spTransform(wetlands.shp, CRS("+init=epsg:4326"))


mapData <- SummaryTableCoords %>% filter(SET_Type == "Rod SET")

pal <- colorQuantile("Reds", domain = NULL, n = 5) #set color scheme using quantiles extracted from data.
'http://a{s}.acetate.geoiq.com/tiles/terrain/{z}/{x}/{y}.png'
'http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
setmap <- leaflet() %>% clearBounds() %>% 
	addTiles('http://a{s}.acetate.geoiq.com/tiles/terrain/{z}/{x}/{y}.png', 
		 attribution = 'Tiles courtesy of <a href="http://openstreetmap.se/" target="_blank">OpenStreetMap Sweden</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>% 
	addCircleMarkers(data = mapData, fillOpacity = 1,
			 lng = ~X_Coord, 
			 lat= ~Y_Coord, 
			 color = ~pal(Mean_elevation_change), 
			 fill = TRUE, 
			 opacity = 1, 
			 weight = 10,
			 popup = ~Site_Name) %>% 
	addPolygons(NLM_summary)
	

setmap 

# ---- 
# Add wetlands boundaries using DEC data pulled from web
# help from http://zevross.com/blog/2014/04/11/using-r-to-quickly-create-an-interactive-online-map-using-the-leafletr-package/

wetlandsURL <- "https://gis.ny.gov/gisdata/fileserver/?DSID=1139&file=tidal_wetlands_lower.zip"
downloaddir <- getwd()
destname <- "NYSDEC_TidalWetlands.zip"
download.file(wetlandsURL, destname)
unzip(destname, exdir = downloaddir, junkpaths = TRUE)

filename <- list.files(downloaddir, pattern= ".shp", full.names = FALSE)
filename <- gsub(".shp", "", filename)
dfw_data <- readOGR(downloaddir, filename)
# transform to EPSG- WGS 1984 - leaflet uses this CRS (coordinate system
dfw_data <- spTransform(dfw_data, CRS("+init=epsg:4326")) # NEED TO CHECK THAT THIS CONVERSION IS CORRECT
# ----
# simplify to create a spatialpolygons class
simp_dfw <- gSimplify(dfw_data, tol = 0.01, topologyPreserve = TRUE)
dfw_data_data <- dfw_data@data[]
simp_dfw <- SpatialPolygonsDataFrame(Sr = simp_dfw, data = dfw_data_data)


## NLM Summary maps
NLM_summary <- readOGR(getwd(), "NLM_Summary_SL")
NLM_summary <- spTransform(NLM_summary, CRS("+init=epsg:4326"))

# ----- save the data slot
subdat_data<-subdat@data[,c("GEOID10", "Population")]

# ----- simplification yields a SpatialPolygons class
subdat<-gSimplify(subdat,tol=0.01, topologyPreserve=TRUE)

# ----- to write to geojson we need a SpatialPolygonsDataFrame

NLM_summaryJSON <- writeOGR(NLM_summary, NLM_summary, driver="GeoJSON")
	
plot(NLM_summary)
