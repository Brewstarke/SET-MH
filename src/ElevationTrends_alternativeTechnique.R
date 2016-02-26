###
# SET Elevation trend calculator using dplyr and broom packages

# SET SLOPE SUMMARY AND ANALYSIS CODE
# Statistical Methods by Philippe Hensel and Penelope Pooler
# Last edited on 12/19/2012
###
# Progromatic Methods Modified by Adam Starke - 
# Specifically for use along side SET Database v. 2.94 links found in ~/data/SET_data_imports.R
# 
# Picks up from 'munge/Data_munge.R' to analyze 'cleaned' data
#
# user  system elapsed 
# 4.16    0.01    4.20 


a <- SET.data.long %>% # Start with the munged and tidy dataframe (long format)
	group_by(pin_ID) %>% # Group by the full dataset by individual pin
	do(tidy(lm(Raw ~ DecYear, data = .))) %>% # apply a linear regression model of pin height against time (decimal year) 
	filter(term == 'DecYear') %>% 
	right_join(SET.data.long)

