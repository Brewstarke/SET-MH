# rCharts -1st go-

require(rCharts)
require(slidify)

options(r.charts.mode = 'iframesrc',
        rcharts.cdn = TRUE,
        RCHART_WIDTH = 600,
        RCHART_HEIGHT = 400
        )
require(knitr)
opts_chunk$set(tidy = F, results = 'asis', comment = NA)

# Scatter chart of mean elevations

stationSE <- nPlot(Date ~ change, group= 'Position_ID', data= SET.data.Melt, type= 'scatterChart')
stationSE$xAxis(axisLabel = 'Date')

stationSE$print("SEplot")

publish("C:\Users\astarke\Dropbox\Public\rCharts", host= "dropbox")

# C:\Users\astarke\Dropbox\Public\rCharts