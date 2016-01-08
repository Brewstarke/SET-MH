## Reformatting script for arranging USGS-style data spreadsheet into shape used in IMPORTING to NPS SET-MH Database

library(readr)

NYSDEC_NEIWPCC_wide <- read_csv("T:/Coastal/Marsh-Wetlands/SET-MH_project/SET_Data/Partners_SETdata/LIS DEC stations/Hurricane Sandy SET MH spreadsheet_LIS_NYSDEC_VONeill_MASTER COPY.csv")

NYSDEC_NEIWPCC_long_SET <- NYSDEC_NEIWPCC_wide %>% 
	gather(pin, Raw_Data, `pin1 (mm)`:`pin9 (mm)`) %>% 
	rename(Position_Name = `SET Armature Position ID`, 
	       Site_Name = `SET Geographical Location`, 
	       Sample_Date = Date) %>% 
	mutate(Unit_Code = 'NULL', Pin_Notes = "NULL", Pin_Number = gsub("\\D+", "", pin)) %>% 
	select(Unit_Code, Site_Name, Plot_Name, Position_Name, Pin_Number, Sample_Date, Raw_Data, SET_reader, Pin_Notes)
	


View(NYSDEC_NEIWPCC_long_SET)


#  Reshape the feldspar data- taken from a 'long' format

NYSDEC_NEIWPCC_long_Accret <- read_csv("T:/Coastal/Marsh-Wetlands/SET-MH_project/SET_Data/Partners_SETdata/LIS DEC stations/Hurricane Sandy SET MH spreadsheet_LIS_NYSDEC_VONeill_MASTER COPY_Feldspar.csv")

NYSDEC_NEIWPCC_wide_Accret <- NYSDEC_NEIWPCC_long_Accret %>% 
	gather(Layer_Label, Measure, A:C) %>% 
	group_by(Plot_Name, Start_Date) %>% 
	spread(replicate, Measure) %>% 
	rename(Measure_1 = `1`, Measure_2 = `2`, Measure_3 = `3`, Measure_4 = `4`) %>% 
	select(-`Marker Horizon Notes`)


View(NYSDEC_NEIWPCC_wide_Accret)


library(xlsx)

# Export DEC SET data
NYSDEC_NEIWPCC_long_SET %>% 
	write.xlsx("T:/Coastal/Marsh-Wetlands/SET-MH_project/SET_Data/Partners_SETdata/LIS DEC stations/NYSDEC_SETdata_forImport.xlsx", 
		   sheetName="SET data", 
		   col.names=TRUE, 
		   row.names=TRUE, 
		   append = FALSE, 
		   showNA = TRUE)


# Export DEC Feldspar Data -- need to merge the sheets into one workbook.
NYSDEC_NEIWPCC_wide_Accret %>% 
	write.xlsx("T:/Coastal/Marsh-Wetlands/SET-MH_project/SET_Data/Partners_SETdata/LIS DEC stations/NYSDEC_SETdata_forImport.xlsx", 
		   sheetName="Feldspar",
		   col.names = TRUE, row.names = TRUE, append = TRUE, showNA = TRUE)
		   
		   
		   
