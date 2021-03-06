
library(dplyr)
library(ggvis)

SET.data.Melt %>%
 	group_by(Site_Name, Stratafication, Plot_Name) %>%
	summarise(change = slopeer(SET.data.Melt))
	

slopeer <- function(d) {
	if(nrow(d) < 2) {
		return(data.frame(intercept = NA, slope = NA))
	}else {
		p <-  coef(lm(Raw ~ DecYear, data = d))
		p <- data.frame(slope = round(p[2], digits= 4))
	}
}
