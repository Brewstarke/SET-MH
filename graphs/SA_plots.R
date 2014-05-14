## @knitr SA_Plots
# Plots for Surface Accretion.


SA_Plot2 <- ggplot(data=SA.data.M, aes(y = Accretion, x = Start_Date)) 

SA_Plot2 + 
  theme_bw(base_family="serif")  + 
  geom_point(alpha= 0.05) +
  facet_wrap(~Site_Name) +
  stat_smooth(method="lm", color = "mediumblue", size = 1, alpha = .7) + 
  labs(list(title = "Marsh Accretion- Long Island Sites", y = "Cumulative Accretion (mm)", x = "Date")) +
  ylim(-15,40) +
  geom_path(by=SET.data.M$ID, alpha=.05)

