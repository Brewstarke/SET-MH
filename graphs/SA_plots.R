## @knitr SA_Plots
# Plots for Surface Accretion.

SA_PlotData <- SA.data.M %>% 
	filter(Site_Name == "North Greensedge - West Hempstead" | Site_Name == "Lawrence Marsh" | Site_Name == "Mashomack Point" | Site_Name == "Cedar Beach") %>% 
	droplevels()

SA_PlotData$SiteNameF <- factor(PlotData$Site_Name, levels = c("North Greensedge - West Hempstead" , "Lawrence Marsh", "Mashomack Point", "Cedar Beach"))

SA_Plot2 <- ggplot(data=SA_PlotData, aes(y = Accretion, x = as.Date(Start_Date))) 

SA_Plot2 + 
  theme_bw(base_family="serif")  + 
  theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=11), legend.position= "right") +
	scale_x_date(breaks = "6 month", labels=date_format("%b %Y")) +
  geom_point(alpha= 0.05) +
  facet_wrap(~Site_Name) +
  stat_smooth(method="lm", color = "mediumblue", size = 1, alpha = .7) + 
	stat_smooth(color = "brown1", size = 1, alpha = 0.7)+
  labs(list(title = "Marsh Accretion- Long Island Sites\nlinear (blue) and polynomial(red) fits", y = "Cumulative Accretion (mm)", x = "Date")) +
  ylim(-15,40) +
  geom_path(by=SA.data.M$ID, alpha=.05) 



