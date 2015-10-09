SET_Plot_overlay4 <- function(SET_Type = 'Rod SET', highlightSite = NULL, title= "ADD A TITLE!!")
{
	require(ggplot2)
	require(ggthemes)
	require(plyr)
	require(reshape2)
	
	title <- title
	data <- SET.data.Melt[(SET.data.Melt$SET_Type == SET_Type),] # Subset the data by SET type
	
	# Add control structure to ensure Site is available to select.
	
#	data$highlight <-  data$Site_Name == highlightSite
	
	SET_Plot2 <- ggplot(data= data, aes(y = change, 
					    x = Date)
					    )
	
	SET_Plot2 + 
		theme_bw(base_family="serif") +
		geom_line(stat = "summary") +
		#annotate("text", y= 10, label = "Some text")+
		#geom_point(alpha = 0.1) +
		#geom_line(alpha = 0.1) +
		#facet_wrap( ~ Site_Name) +
		labs(list(title = title,
			  y = "Relative change in elevation of marsh surface (mm)", 
			  x = "Years from start of monitoring")) +
		#xlim(-0.25, 1) +
		theme(legend.position= "none")
	
	
}

SET_Plot_overlay4(SET_Type = "Rod SET", highlightSite = c("North Greensedge - West Hempstead", "Lawrence Marsh"), title = "Marsh elevation changes across LI")
