## @knitr ElevPlot1
require(ggplot2)


SummaryTable$bgrate[SummaryTable$SubSurface_change >= 0]<- "pos"
SummaryTable$bgrate[SummaryTable$SubSurface_change < 0]<- "neg"

elevPlot1 <- ggplot (data= SummaryTable, 
                     aes(x = Mean_Accretion_Rate, y = Mean_elevation_change, 
                         shape= SummaryTable$bgrate, color= SummaryTable$SubSurface_change))

elevPlot1 + 
  ylim(0, 8) +
  xlim(0, 14) +
  scale_colour_continuous(low= 'red', high= 'blue') +
  geom_point(size = 10, 
             alpha= .4 ) +
  geom_point(size = 2, 
             color = "black") +
  geom_abline(slope = 1, 
              linetype='longdash', 
              color=0xFEE8C8) + 
  geom_vline(xintercept = 2.8, 
             color= "red", 
             alpha = .2, size = 3) + 
  geom_vline(xintercept = 2.8, 
             color= 'red') +
  geom_text(colour= "black", 
            label= interaction(SummaryTable$Stratafication, SummaryTable$Site_Name, sep="- "), 
            size=5, 
            hjust= 0) +  
  labs(y = "Average change in marsh elevation (mm/year)", 
       x = "Average surface accretion (mm/year)") + 
  annotate("text", x = 2.5, y = 5, 
           label = "10-yr average sea level rise trend", 
           angle = 90) +
#   annotate("text", x = 5, y= 5.1, 
#            label ="Change in surface elevation equal to surface accretion (without compaction)", 
#            angle = 27) +
  theme_bw(base_family="serif") +
  theme(legend.position = "none")



