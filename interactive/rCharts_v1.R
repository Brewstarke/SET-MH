
rPlot(meanslopes ~ Stratafication | SET_Type, data = SET.station.means, color = "Site_Name", type = 'point')

n1 <- nPlot(meanslopes ~ Stratafication, 
      group= "Site_Name",
      data = SET.station.means,
      type = "multiBarHorizontal")
n1

