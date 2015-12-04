#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(tidyr)
library(metricsgraphics)


library()

load('regress.RData')


studysites <- unique(SummaryTable$Site_Name)
names(studysites) <- studysites

### UI ### 

ui <- shinyUI(fluidPage(
   
   # Application title
   titlePanel("Running Regression Analysis"),
   
   # Sidebar with a slider input for number of bins 
   fluidRow(
      column(12,
             wellPanel(
             	selectInput("site", label = "Study Site:",
      			 choices = names(studysites)),
      			 selectInput("SETtype", label = "Type of SET",
      			 	    choices = c("Rod SET", "Shallow SET"))
      			       			 )
             ),
      
      # Show a plot of the generated distribution
      column(12,
             metricsgraphicsOutput("plotMetrics", height = 650
             	  )
      )
   )
))

### SERVER ###

server <- shinyServer(function(input, output) {
	
	tmpdata <- reactive({ 
		intervalSET %>%
		filter(Site_Name == input$site) %>%
		filter(SET_Type == input$SETtype)
	})
	

		
	# output$plotTau <- renderTaucharts({
	# 	tauchart(tmpdata()) %>% 
	# 		tau_point(x = 'Date', y = 'beta', size = 'SE_beta') %>% 
	# 		tau_trendline(type = 'linear', showPanel = FALSE, showTrend = TRUE, hideError = FALSE) %>% 
	# 		tau_legend() 
	# 		
	# })		
			
	output$plotMetrics <- renderMetricsgraphics({
		tmpdata() %>% 
			mjs_plot(x = Date, y = beta) %>% 
			mjs_point(least_squares = TRUE) %>% 
			mjs_axis_x(xax_format = "date", show_secondary_x_label = TRUE) %>% 
			mjs_add_confidence_band(lower_accessor = SE_beta, upper_accessor = SE_beta)
	})
	
})



# Run the application 
shinyApp(ui = ui, server = server)
