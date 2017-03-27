SET-MH
======

SET-MH data tool
Early phase of migrating SET-MH data analysis steps into GIT for sharing and collaboration



## TO DO:
-- maps.R needs repairing.  
 * create leaflet map of all sites, popup of summart stats.  
 * create static maps for reports etc.  
-- Summaries.R needs review. 
	* has it been fully replaced with the 'alternativeTechniques.R' code?
 
 
### DB to do's:
 - add GPS coords to AH1-3 shallow, PN1-6 shallow, HC1-3 shallow
 
###Immediate Actions:

- Move towards functional programming using 
- Create a function that saves objects needed in external apps and analysis (running regression analysis)



Needs:
-Add cast functions to post tables of site and station 'attributes' like number of positions measured etc.
-Reshape the Shallow SET data summary to have column of shallow elevation changes, deep elevation changes and surface accretion. This will allow parsing out the unique elevation changes to each 'part' of the marsh.

-Fix bug in /graphs/Plotting_Tool doPlot function

-Add the database file path (SET.DB.path) to the report output to allow for tracking that the correct file was pulled in.

-Adapt the munge and ID field creation to accomodate the shallow SETs
  -strategy 1- subset and remove shallow stations to a new dataframe
  -strategy 2- modify the ID field to add one layer on top of the stations

-Need to enter GPS coords in database
-Clean up Locations datatable to remove NA's


Wishes and Ideas:

- Add a warning() message that lets user know if the numbers of levels in Position_ID is  not equal (!==) to Location_ID/4 asking to pick up if there's potentially missing data from a SET arm direction (or other)


