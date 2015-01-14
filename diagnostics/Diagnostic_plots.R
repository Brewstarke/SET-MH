# Data exploration -diagnostics
require(ggplot2)
require(reshape2)
require(plyr)

SET.data.Melt <- plyr::rename(x= SET.data.M, replace= c(Raw = "value"))
dcast(data= SET.data.Melt, formula= Site_Name ~ SET_Type + Stratafication)
dcast(data= SET.data.Melt, formula= Site_Name + SET_Type ~ Stratafication)
d <- dcast(data= SET.data.Melt, formula= Site_Name ~ SET_Type, count(unique(SET.data.Melt$Position_ID)))
dcast(data= SET.data.Melt, formula= Position_ID ~ SET_Type + Stratafication)
dcast(data= SET.data.Melt, formula= Position_ID ~ Location_ID)

Shallows <- subset.data.frame(x= SET.data.M, subset= c(SET_Type == "Shallow SET"))
Shallows