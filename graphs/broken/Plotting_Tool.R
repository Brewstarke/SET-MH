###
#
# Plot outputting function
#
###

# Function creating individual outputs (.png or .pdf depending on what extension you put in ggsave() )
# Output files are stored in working directory
require(ggplot2)
require(plyr)

doPlot <- function(site.name) {
  dum <- subset(SET.data.M, Site_Name == site.name)
  ggobj <- SET_Plot2 <- qplot(Start_Date, change, data=dum)+   
    stat_smooth() + theme_bw()  + 
    labs(list(title = sprintf(" %s: Change in Marsh Surface Elevation \n as deteced by deepRod-SET", site.name), 
              x = "Elevation Change", 
              y = "Date"))
  
    #manipulate the plot looks here.
  print(ggobj)
  ggsave(sprintf("%s.png", site.name))
}
laply(unique(SET.data.M$Site_Name), doPlot)
dev.off()
