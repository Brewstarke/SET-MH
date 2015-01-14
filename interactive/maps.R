# MAPS!!
#  
# Leaflet maps
#
####

library(leaflet)
library(rgdal)
library(rgeos)
library(sp)


mapData <- SummaryTableCoords %>% filter(SET_Type == "Rod SET")

pal <- colorQuantile("Reds", domain = NULL, n = 5) #set color scheme using quantiles extracted from data.

setmap <- leaflet() %>% clearBounds() %>% 
	addTiles('http://a{s}.acetate.geoiq.com/tiles/terrain/{z}/{x}/{y}.png', 
		 attribution = 'Tiles courtesy of <a href="http://openstreetmap.se/" target="_blank">OpenStreetMap Sweden</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>% 
	addCircleMarkers(data = mapData,  
			 lng = ~X_Coord, 
			 lat= ~Y_Coord, 
			 color = ~pal(Mean_elevation_change), 
			 fill = TRUE, 
			 opacity = 1, 
			 weight = 10,
			 layerId = ~Site_Name
			 ) %>%
	addPopups(data = mapData, layerId = ~Site_Name,   
		  lng = ~X_Coord, 
		  lat= ~Y_Coord)

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
# transform to EPSG- WGS 1984
dfw_data <- spTransform(dfw_data, CRS("+init=epsg:4326")) # NEED TO CHECK THAT THIS CONVERSION IS CORRECT
# ----
# simplify to create a spatialpolygons class
simp_dfw <- gSimplify(dfw_data, tol = 0.01, topologyPreserve = TRUE)
dfw_data_data <- dfw_data@data[]
simp_dfw <- SpatialPolygonsDataFrame(Sr = simp_dfw, data = dfw_data_data)

# ----
# start making leaflet map
leafdata <- paste(downloaddir, "/", filename,"", sep = "")
# Convert shp file to geoJSON
writeOGR(obj = simp_dfw, dsn = "NYSDEC_TWetlands", layer = "", driver= "GeoJSON") # outputting file with no extension

# try using fromJSON
wetlandJSON <- RJSONIO::fromJSON("simp_dfw.geojson", asText= FALSE)# Works thought creates a very large data.



wetlandsMap <- leaflet() %>% clearBounds() %>% addGeoJSON(wetlandJSON)
wetlandsMap
