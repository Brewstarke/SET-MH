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
library(ggplot2)


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
             	h4("Select a Site:"),
             	selectInput("site", label = NULL,
      			 choices = names(studysites)),
      		selectInput("SETtype", label = NULL,
      			 	    choices = c("Rod SET", "Shallow SET")),
      		h4("Select a SET type:"),
      		
      		actionButton("exclude_toggle", label = "Toggle excluded data points:"), 
      		actionButton("exclude_reset", label = "Reset Exclusions"),
      		h4("Drag and double-click an area to zoom"),
      		verbatimTextOutput("brush_info")
      		)
      			       			 
             ),
      
      # Show a plot of the generated distribution
      column(12,
             plotOutput("plotgg", 
             	   height = 650,
             	   click = "plotgg_click",
             	   dblclick = "plotgg_dblclick",
             	   # Brushing options #-
             	   brush = brushOpts(
             	   	id = "plotgg_brush",
             	   	resetOnNew = TRUE,
             	   	opacity = 0.5,
             	   	fill = 'green'
             	   )
             	  )
      )
   )
))

### SERVER ###

server <- shinyServer(function(input, output) {
	
	vals <- reactiveValues(
		keeprows = rep(TRUE, nrow(intervalSET))
	)
		
	tmpdata <- reactive({ 
		intervalSET %>%
		filter(Site_Name == input$site) %>%
		filter(SET_Type == input$SETtype)
	})
	
	ranges <- reactiveValues(x = NULL, y = NULL)

output$plotgg <- renderPlot({
	
	keep <- tmpdata()[vals$keeprows, ,drop = FALSE]
	exclude <- tmpdata()[!vals$keeprows, , drop = FALSE]

		if (!is.null(ranges$x)) {
		ranges$x <- as.Date(ranges$x, origin = "1970-01-01")
	}
	keep %>% 
		ggplot(aes(x = Date, y = beta))+
		geom_point(size = 0.75, alpha = 0.1)+
		geom_path(size = 0.5, alpha = 0.1) +
		geom_smooth(size = 1, fill = "#BEC1D4", color = "#023FA5", alpha = 0.7)+
		geom_smooth(method = lm, color = "#8E063B", fill = "#D6BCC0", alpha = 0.7) +
		theme_bw() +
		geom_point(data = exclude, shape = 21, alpha = 0.25, size = 2) + 
		labs(y = "Change in elevation (mm/year)", x = NULL) + 
		coord_cartesian(xlim = ranges$x, ylim = c(-20, 20)) 
		
		
	
})		

# When a double-click happens, check if there's a brush on the plot.
# If so, zoom to the brush bounds; if not, reset the zoom.
observeEvent(input$plotgg_dblclick, {
	brush <- input$plotgg_brush
	if (!is.null(brush)) {
		ranges$x <- c(brush$xmin, brush$xmax)
		ranges$y <- c(brush$ymin, brush$ymax)
		
	} else {
		ranges$x <- NULL
		ranges$y <- NULL
	}
})

# Toggle points that are clicked
observeEvent(input$plotgg_click, {
	res <- nearPoints(tmpdata(), input$plotgg_click, allRows = TRUE)
	
	vals$keeprows <- xor(vals$keeprows, res$selected_)
})

# Toggle points that are brushed, when button is clicked
observeEvent(input$exclude_toggle, {
	res <- brushedPoints(tmpdata(), input$plotgg_brush, allRows = TRUE)
	
	vals$keeprows <- xor(vals$keeprows, res$selected_)
})

# Reset all points
observeEvent(input$exclude_reset, {
	vals$keeprows <- rep(TRUE, nrow(tmpdata()))
})

	
output$brush_info <- renderPrint({
	cat("Selected Points:\n",
	    "Average of selected points:\n",
	mean(brushedPoints(tmpdata(), input$plotgg_brush)$beta),"\n",
	"Variance of selected points:\n",
	var(brushedPoints(tmpdata(), input$plotgg_brush)$beta),"\n",
	"Max of selected points:\n",
	max(brushedPoints(tmpdata(), input$plotgg_brush)$beta),"\n",
	"Minimum of selected points:\n",
	min(brushedPoints(tmpdata(), input$plotgg_brush)$beta))

})

})



# Run the application 
shinyApp(ui = ui, server = server)
