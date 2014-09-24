
library(dplyr)
library(ggvis)

SET.data.M %>%
 	group_by(Site_Name, Stratafication, Plot_Name) %>%
	