SET-MH
======

SET-MH data tool
Early phase of migrating SET-MH data analysis steps into GIT for sharing and collaboration



## TO DO:
- Insert mechanism to manage NA's in SET pin measures. Currently throwing errors in lm()functions
- Maps.R needs repairing.  
	* create leaflet map of all sites, popup of summart stats.  
 	* create static maps for reports etc.  
 	* Fix bug in /graphs/Plotting_Tool doPlot function
- Summaries.R needs review. 
	* has it been fully replaced with the 'alternativeTechniques.R' code?
- Add functions to post tables of site and station 'attributes' like number of positions measured etc.Start date, last read. For use in maps and summary documents.
- Reshape the Shallow SET data summary to have column of shallow elevation changes, deep elevation changes and surface accretion. This will allow parsing out the unique elevation changes to each 'part' of the marsh.

 
### DB to do's:
 - add GPS coords to AH1-3 shallow, PN1-6 shallow, HC1-3 shallow
 
- Clean up Locations datatable to remove NA's

### Future Actions:

- Move towards functional programming 
- Create a function that saves objects needed in external apps and analysis (running regression analysis)

- Adapt the munge and ID field creation to accomodate the shallow SETs
  - strategy 1- subset and remove shallow stations to a new dataframe
  - strategy 2- modify the ID field to add one layer on top of the stations
- Explore purrr and summary generation. 

### Wishes and Ideas:

- Add a warning() message that lets user know if the numbers of levels in Position_ID is  not equal (!==) to Location_ID/4 asking to pick up if there's potentially missing data from a SET arm direction (or other)


