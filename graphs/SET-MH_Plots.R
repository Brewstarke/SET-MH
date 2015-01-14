

SET-MH_Plot_overlayvert <- function(plot_title)
{
	require(ggplot2)
	require(ggthemes)
	require(plyr)
	require(reshape2)
	require(scales)
	
	plot_title <- plot_title
	data <- SET.data.M[(SET.data.M$SET_Type == "Rod SET"),] # Subset the data type - removed to add faceting on this variable
	#data <- join(x = SET.data.M, y= SA.data.M, by = c("Site_Name", "Stratafication", "Plot_Name", "Start_Date"))
	data_01 <- SA.data.M
	data_01 <- plyr::rename(x = data_01, replace = c("Start_Date" = "Date", "Accretion" = "change"))
	SiteOrder <- unique(SET.data.M$Site_Name)[c(9,8,1:2, 4, 6, 7, 3, 5)]
	data$Site_Name <- factor(data$Site_Name, levels= SiteOrder) 
	
	# Add control structure to ensure Site is available to select.
	#data$highlight <-  as.factor(data$Site_Name != highlightSite)
	
	SET_Plot2 <- ggplot()
	
	SET_Plot2A <- SET_Plot2 + 		
		stat_smooth(data= data, # SET data
			    aes(y = change,
			        x = as.Date(Date),
			        color= interaction(Site_Name, 
				    		   Stratafication, sep = " "),
			        group= interaction(Site_Name, 
				    		   Stratafication,
				    		   sep= " ")),
			    method = glm,
			    se = FALSE, 
			    size = 1,
			    linetype= "dotted") + 
	    	stat_smooth(data= data_01, # SA data 
	    		    aes(y = change,
	    		        x = as.Date(Date),
	    		        color= interaction(Site_Name, 
	    		        		   Stratafication, sep = " "),
	    		        group= interaction(Site_Name,
	    		        		   Stratafication,
	    		        		   sep= " ")),
	    		    linetype= "solid",
	    		    size= 1,
	    		    method = glm,
	    		    se = FALSE) + 
		
		facet_wrap( ~ Site_Name, ncol = 3) +
		scale_x_date(breaks = "6 months", 
			     labels=date_format("%Y"), 
			     limits = as.Date(c('2011-10-01','2014-10-01'))) +
		theme_bw(base_family="serif") + 
		theme(legend.position= "none") +
		labs(list(title = plot_title, 
			  y = "Relative Elevation of marsh surface (mm)", 
			  x = "Date"))+
		scale_linetype_identity(name= "Monitoring Type", 
					guide= "legend", 
					labels = c("Overall Elevation", "Surface Accretion"))
	
	SET_Plot2A
}

#####

##

SET-MH_Plot_overlayvert(plot_title = "Marsh Elevation Changes Across LI")

#------------------------------------------------------------------------------------------


SET_MH_Plot_smooth <- function(plot_title)
{
	require(ggplot2)
	require(ggthemes)
	require(plyr)
	require(reshape2)
	require(scales)
	
	plot_title <- plot_title
	data <- SET.data.M %>% filter(Site_Name == "Mashomack Point" |Site_Name == "Indian Island" | Site_Name =="Pine Neck")
	
	data_01 <- SA.data.M %>% filter(Site_Name == "Mashomack Point"|Site_Name == "Indian Island" |Site_Name == "Pine Neck")
	
	data_01 <- plyr::rename(x = data_01, replace = c("Start_Date" = "Date", "Accretion" = "change"))
	SiteOrder <- unique(SET.data.M$Site_Name)[c(9,8,1:2, 4, 6, 7, 3, 5)]
	data$Site_Name <- factor(data$Site_Name, levels= SiteOrder) 
# 	data_02 <- SET.data.M %>% filter(SET_Type == "Shallow SET" & Site_Name == "Indian Island" | SET_Type == "Shallow SET" & Site_Name == "Pine Neck")
# 	
	# Add control structure to ensure Site is available to select.
	#data$highlight <-  as.factor(data$Site_Name != highlightSite)
	
	SET_Plot2 <- ggplot()
	
	SET_Plot2A <- SET_Plot2 + 		
		stat_smooth(data= data, # SET data
								aes(y = change,
										x = as.Date(Date),
										color= interaction(Site_Name, Stratafication, SET_Type,  sep = " ")),
								method = loess,
								se = TRUE, 
								size = 1,
								linetype= 1) + 
		stat_smooth(data= data_01, # SA data 
								aes(y = change,
										x = as.Date(Date),
										color= interaction(Site_Name,Stratafication, sep = " ")),
										
								linetype= 6,
								size= 1,
								method = loess,
								se = TRUE) + 
# 		stat_smooth(data= data_02, # Shallow SET data
# 								 aes(y = change,
# 								 		x = as.Date(Date),
# 								 		color= interaction(Site_Name, SET_Type, Stratafication, sep = " ")),
# 								 		
# 								 method = loess,
# 								 se = TRUE, 
# 								 size = 2,
# 								 linetype= 1) +

		facet_wrap( ~ Site_Name) +
		scale_x_date(breaks = "6 months", 
								 labels=date_format("%m/%Y"), 
								 limits = as.Date(c('2011-3-01','2014-12-01'))) +
	theme(legend.position= "top") +	
	theme_bw(base_family="serif") + 
		#theme_update(legend.position=c(0.95, 0.95), legend.justification = c(1, 1))+
		labs(list(title = plot_title, 
							color= "SET type and Marsh area",
							y = "Relative Elevation of marsh surface (mm)", 
							x = "Date"))+
		scale_linetype_identity(name= "Monitoring Type", 
														guide= "legend", 
														labels = c("Overall Elevation", "Surface Accretion"))
	
	SET_Plot2A

}

#####

##

SET_MH_Plot_smooth(plot_title = "Marsh Elevation Changes Across LI")

#----------------------------------------------------------


SET_MH_Plot_line <- function(plot_title)
{
	require(ggplot2)
	require(ggthemes)
	require(plyr)
	require(reshape2)
	require(scales)
	
	plot_title <- plot_title
	data <- SET.data.M[(SET.data.M$SET_Type == "Rod SET" & SET.data.M$Site_Name == "Pine Neck" | SET.data.M$Site_Name == "Pine Neck"),] # Subset the data type - removed to add faceting on this variable
	#data <- join(x = SET.data.M, y= SA.data.M, by = c("Site_Name", "Stratafication", "Plot_Name", "Start_Date"))
	
	data_01 <- SA.data.M[(SA.data.M$Site_Name == "Pine Neck" | SA.data.M$Site_Name == "Pine Neck"),]
	data_01 <- plyr::rename(x = data_01, replace = c("Start_Date" = "Date", "Accretion" = "change"))
	SiteOrder <- unique(SET.data.M$Site_Name)[c(9,8,1:2, 4, 6, 7, 3, 5)]
	data$Site_Name <- factor(data$Site_Name, levels= SiteOrder) 
	data_02 <- SET.data.M %>% filter(SET_Type == "Shallow SET" & Site_Name == "Pine Neck" | SET_Type == "Shallow SET" & Site_Name == "Pine Neck")
	
	# Add control structure to ensure Site is available to select.
	#data$highlight <-  as.factor(data$Site_Name != highlightSite)
	
	SET_Plot2 <- ggplot()
	
	SET_Plot2A <- SET_Plot2 + 		
		stat_summary(data= data, # SET data
								aes(y = change,
										x = as.Date(Date),
										color= interaction(Site_Name, Stratafication, SET_Type, sep = " ")),
# 										group= interaction(Site_Name, Stratafication, SET_Type, sep= " ")),
								geom= "line",
								fun.y = "mean",
								size = 1,
								linetype= 1) + 
		stat_summary(data= data_01, # SA data 
								aes(y = change,
										x = as.Date(Date),
										color= interaction(Site_Name, Stratafication, sep = " ")),
# 										group= interaction(Site_Name, Stratafication, sep= " ")),
							geom= "line",
							fun.y = "mean",
							linetype= 6,
								size= 1,
								se = TRUE) + 
		stat_summary(data= data_02, # Shallow SET data
								aes(y = change,
										x = as.Date(Date),
										color= interaction(Site_Name, Stratafication,SET_Type, sep = " ")),
# 										group= interaction(Site_Name, Stratafication,SET_Type, sep= " ")),
								geom= "line",
								fun.y = "mean",
								se = TRUE, 
								size = 1,
								linetype= 1) +
		
		facet_wrap( ~ Site_Name, ncol = 3) +
		scale_x_date(breaks = "6 months", 
								 labels=date_format("%m/%Y"), 
								 limits = as.Date(c('2010-10-01','2014-12-01'))) +
		theme(legend.position= "top") +	
		theme_bw(base_family="serif") + 
		#theme_update(legend.position=c(0.95, 0.95), legend.justification = c(1, 1))+
		labs(list(title = plot_title, 
							y = "Relative Elevation of marsh surface (mm)", 
							x = "Date"))+
		scale_linetype_identity(name= "Monitoring Type", 
														guide= "legend", 
														labels = c("Overall Elevation", "Surface Accretion"))
	
	SET_Plot2A
}

#####

##

SET_MH_Plot_line(plot_title = "Marsh Elevation Changes Across LI")

#--------------------------------




SET_MH_Plot_line_all <- function(plot_title)
{
	require(ggplot2)
	require(ggthemes)
	require(plyr)
	require(reshape2)
	require(scales)
	
	plot_title <- plot_title
	data <- SET.data.M
	data_01 <- SA.data.M
	data_01 <- plyr::rename(x = data_01, replace = c("Start_Date" = "Date", "Accretion" = "change"))
	
	data_02 <- SET.data.M 
	# Add control structure to ensure Site is available to select.
	#data$highlight <-  as.factor(data$Site_Name != highlightSite)
	
	SET_Plot2 <- ggplot()
	
	SET_Plot2A <- SET_Plot2 + 		
		stat_summary(data= data, # SET data
								 aes(y = change,
								 		x = as.Date(Date),
								 		color= interaction(Site_Name, Stratafication, SET_Type, sep = " ")),
# 								 		group= interaction(levels, sep= " ")),
								 geom= "line",
								 fun.y = "mean",
								 size = 1,
								 linetype= 1) + 
		stat_summary(data= data_01, # SA data 
								 aes(y = change,
								 		x = as.Date(Date),
								 		color= interaction(Site_Name, Stratafication, sep = " ")),
# 								 		group= interaction(Site_Name, Stratafication, sep= " ")),
								 geom= "line",
								 fun.y = "mean",
								 linetype= 6,
								 size= 1,
								 se = TRUE) + 
		stat_summary(data= data_02, # Shallow SET data
								 aes(y = change,
								 		x = as.Date(Date),
								 		color= interaction(Site_Name, Stratafication, SET_Type, sep = " ")),
# 								 		group= interaction(Site_Name, Stratafication, SET_Type, sep= " ")),
								 geom= "line",
								 fun.y = "mean",
								 se = TRUE, 
								 size = 1,
								 linetype= 1) +
		
		facet_wrap( ~ Site_Name, ncol = 3) +
		scale_x_date(breaks = "6 months", 
								 labels=date_format("%m/%Y"), 
								 limits = as.Date(c('2010-10-01','2014-12-01'))) +
		theme(legend.position= "top") +	
		theme_bw(base_family="serif") + 
		
		labs(list(title = plot_title, 
							y = "Relative Elevation of marsh surface (mm)", 
							x = "Date"))+
		scale_linetype_identity(name= "Monitoring Type", 
														guide= "legend", 
														labels = c("Overall Elevation", "Surface Accretion"))
	
	SET_Plot2A
}

#####

##

SET_MH_Plot_line_all(plot_title = "Marsh Elevation Changes Across LI")

