###
# SET Elevation trend calculator using dplyr and broom packages


a <- SET.data.Melt %>% 
	group_by(Position_ID, variable) %>% 
	do(tidy(lm(Raw ~ DecYear, data = .))) %>% 
	full_join(meanslope.Pin) %>% 
	mutate(diff = estimate - slope) %>% 
	filter(term == "DecYear")