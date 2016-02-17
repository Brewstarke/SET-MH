# figure out tidyr----

library(dplyr)
library(tidyr)

df <- data.frame(Site = rep(c("Site1", "Site2", "Site3"),10), 
                 Pin1 = rnorm(30, 100, 20), 
                 Pin1_Notes = rep(c("OK", NA, NA, "good", NA),6), 
                 Pin2 = rnorm(30, 50, 20),
                 Pin2_Notes = rep(c(NA, NA, NA, NA, "good"),6))

df %>% gather(pin, Raw, Pin1, Pin2) %>% gather(pin_note, note, Pin1_Notes, Pin2_Notes) %>% head()
