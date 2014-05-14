
r1 <- rPlot(Mean_elevation_change ~ Mean_Accretion_Rate, data = SummaryTable, color = "Site_Name", type = 'point')
r1

n1 <- nPlot(meanslopes ~ Stratafication, 
      group= "Site_Name",
      data = SET.station.means,
      type = "multiBarHorizontal")
n1



r1 <- rPlot(mpg ~ wt | am + vs, data = mtcars, type = "point", color = "gear")
r1$print("chart1")
