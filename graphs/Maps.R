## @knitr Maps
# 
# Maps 
# 
# Long Island bounds are (-72.0643, 40.5201, -71.8011, 41.2138)
#
###

# Mapping the SET-MH sites (merged 1st station coordinates for site coordinates) along with some additional data
library(ggmap)
## For cloudmade maps
api <- c("c669db620b804a3a90fbe4193c4c6ec8")
# Basic_marshplots- Blank
# Map sytle code = 125286

#Basic Land outline map- using cloudmademap
Site.blankmap <- get_cloudmademap(bbox= c(bottom= 40.5201, 
                                          left= -74.0643, 
                                          top= 41.2138, 
                                          right= -71.8011),
                                  api_key= api,
                                  maptype= 125286,
                                  color= "bw", 
                                  zoom= 10, 
                                  highres= TRUE)

# Plot map and sites together.

ggmap(Site.blankmap) +  
  geom_point(aes(x= X_Coord, y= Y_Coord, size= 3), 
             data= SummaryTableCoords, show_guide= FALSE) +
  geom_text(data= SummaryTableCoords, aes(x= X_Coord, y= Y_Coord, label= Site_Name), angle= 1, hjust= 0)


