## 
#  Not sure where this was going....
#
###
# Calculate the mean change across the site for each visit
SiteMeanIncrementalChangeCalc <- function(){
MeanChange <- ddply(.data= SET.data.Melt, 
		    .(SET_Type, 
		      Site_Name,
		      Plot_Name,
		      Stratafication, 
		      Position_ID, 
		      Location_ID, 
		      Date),  
		       summarize, 
		       meanChange= round(mean(change,na.rm=TRUE),digits= 2))
MeanChange <- ddply(.data= MeanChange, 
		    .(SET_Type, 
		      Site_Name,
		      Plot_Name,
		      Stratafication, 
		      Location_ID,
		      Date), 
		    summarize, 
		    meanChange= round(mean(meanChange,na.rm=TRUE),digits= 2))

MeanChange <<- ddply(.data= MeanChange, 
		    .(SET_Type, 
		      Site_Name,
		      Stratafication, 
		      Date), 
		    summarize, 
		    meanChange= round(mean(meanChange,na.rm=TRUE),digits= 2))

}


SiteMeanIncrementalChangeCalc()

#######

# SET_Plot_overlay2 <- function(SET_Type = 'Rod SET', highlightSite = NULL, title)
# {
# 	require(ggplot2)
# 	require(ggthemes)
# 	require(plyr)
# 	require(reshape2)
# 	
# 	title <- title
# 	#data <- SET.data.M[(SET.data.M$SET_Type == SET_Type),] # Subset the data type
# 	
# 	# Add control structure to ensure Site is available to select.
# 	
# 	data$highlight <-  data$Site_Name == highlightSite
# 	
	SET_Plot <- ggplot(data= MeanChange, aes(x= Site_Name, fill= strftime(MeanChange$Date, "%Y/%m"), y = meanChange)) 
		
	
	SET_Plot + geom_bar(stat = "identity") + 
		facet_wrap(Stratafication ~ SET_Type) + 
		theme(legend.position= "right", axis.text.x  = element_text(angle=90, vjust=0.5, size=10))



	SET_Plot2 <- ggplot(data= MeanChange, aes(x= Site_Name, y = meanChange)) 
	
SET_Plot2 + 
	geom_point(position = "jitter", aes(color= strftime(MeanChange$Date, "%Y/%m"))) + 
	
		  	facet_wrap(Stratafication ~ SET_Type)
	
