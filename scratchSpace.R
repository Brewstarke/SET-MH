# Scratch space
### Example Viridis Plot

library(ggplot2)
library(viridis)
# install.packages('season')
# library(season)
library(gridExtra)
library(tidyverse)

SET.data.cleanV3 %>% 
	filter(Site_Name == 'Hubbard Creek') %>% 
	ggplot(aes(x = Date, y = incrementalChange, color = Arm_Direction)) + 
	geom_point() + 
	scale_fill_viridis(option="A") +
	# scale_y_continuous(breaks=1:12, labels=month.abb[1:12])+
	xlab("") + 
	ylab("") +
	ggtitle("SET Linearity Tool") +
	theme(
		plot.title = element_text(color="white",hjust=0,vjust=1, size=rel(2)),
		plot.background = element_rect(fill="gray20"),
		panel.background = element_rect(fill="gray20"),
		panel.border = element_rect(fill=NA,color="gray20", size=0.5, linetype="solid"),
		panel.grid.major = element_blank(),
		panel.grid.minor = element_blank(),
		axis.line = element_blank(),
		axis.ticks = element_blank(), 
		axis.text = element_text(color="white", size=rel(1.5)),
		axis.text.y  = element_text(hjust=1),
		legend.text = element_text(color="white", size=rel(1.3)),
		legend.background = element_rect(fill="gray20"),
		legend.position = "bottom",
		legend.title=element_blank()
	) +
	facet_grid(SET_Type ~ Plot_Name)


pb<-ggplot(schz, aes(year, month, fill = SczBroad)) + 
	geom_tile(colour="gray20", size=1.5, stat="identity") + 
	scale_fill_viridis(option="B") +
	scale_y_continuous(breaks=1:12, labels=month.abb[1:12])+
	xlab("") + 
	ylab("") +
	ggtitle("Total Australian Schizophrenics Born By Month and Year") +
	theme(
		plot.title = element_text(color="white",hjust=0,vjust=1, size=rel(2)),
		plot.background = element_rect(fill="gray20"),
		panel.background = element_rect(fill="gray20"),
		panel.border = element_rect(fill=NA,color="gray20", size=0.5, linetype="solid"),
		panel.grid.major = element_blank(),
		panel.grid.minor = element_blank(),
		axis.line = element_blank(),
		axis.ticks = element_blank(), 
		axis.text = element_text(color="white", size=rel(1.5)),
		axis.text.y  = element_text(hjust=1),
		legend.text = element_text(color="white", size=rel(1.3)),
		legend.background = element_rect(fill="gray20"),
		legend.position = "bottom",
		legend.title=element_blank()
	)


pc<-ggplot(schz, aes(year, month, fill = SczBroad)) + 
	geom_tile(colour="gray20", size=1.5, stat="identity") + 
	scale_fill_viridis(option="C") +
	scale_y_continuous(breaks=1:12, labels=month.abb[1:12])+
	xlab("") + 
	ylab("") +
	ggtitle("Total Australian Schizophrenics Born By Month and Year") +
	theme(
		plot.title = element_text(color="white",hjust=0,vjust=1, size=rel(2)),
		plot.background = element_rect(fill="gray20"),
		panel.background = element_rect(fill="gray20"),
		panel.border = element_rect(fill=NA,color="gray20", size=0.5, linetype="solid"),
		panel.grid.major = element_blank(),
		panel.grid.minor = element_blank(),
		axis.line = element_blank(),
		axis.ticks = element_blank(), 
		axis.text = element_text(color="white", size=rel(1.5)),
		axis.text.y  = element_text(hjust=1),
		legend.text = element_text(color="white", size=rel(1.3)),
		legend.background = element_rect(fill="gray20"),
		legend.position = "bottom",
		legend.title=element_blank()
	)


pd<-ggplot(schz, aes(year, month, fill = SczBroad)) + 
	geom_tile(colour="gray20", size=1.5, stat="identity") + 
	scale_fill_viridis(option="D") +
	scale_y_continuous(breaks=1:12, labels=month.abb[1:12])+
	xlab("") + 
	ylab("") +
	ggtitle("Total Australian Schizophrenics Born By Month and Year") +
	theme(
		plot.title = element_text(color="white",hjust=0,vjust=1, size=rel(2)),
		plot.background = element_rect(fill="gray20"),
		panel.background = element_rect(fill="gray20"),
		panel.border = element_rect(fill=NA,color="gray20", size=0.5, linetype="solid"),
		panel.grid.major = element_blank(),
		panel.grid.minor = element_blank(),
		axis.line = element_blank(),
		axis.ticks = element_blank(), 
		axis.text = element_text(color="white", size=rel(1.5)),
		axis.text.y  = element_text(hjust=1),
		legend.text = element_text(color="white", size=rel(1.3)),
		legend.background = element_rect(fill="gray20"),
		legend.position = "bottom",
		legend.title=element_blank()
	)