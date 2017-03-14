## @knitr Tables

library(xtable)

Table.1 <- xtable(SummaryTable, 
                  caption="SET-MH monitoring sites across Long Island", 
                  digits=2)

Table.1
