/*notes only:

This class will start with the communal builting of the tree calculation.
//-----------------------------Trees and Boilers----------------------------------

Materials to estimate carbon capture for #4,#6 oils and engage the tree count of NY are in folder"tree-carbon conversion"

Note that an emission factor is a representative value that attempts to relate the quantity of a pollutant 
released to the atmosphere with an activity associated with the release of that pollutant. These factors are usually 
expressed as the weight of pollutant divided by a unit weight, volume, distance, or duration of the activity emitting 
the pollutant (e. g., kilograms of particulate emitted per megagram of coal burned). Such factors facilitate 
estimation of emissions from various sources of air pollution. In most cases, these factors are simply averages of 
all available data of acceptable quality, and are generally assumed to be representative of long-term averages for 
all facilities in the source category (i. e., a population average). 

See- c01s03- Table 1.3-1. for factors in lb/10^3 gallons (5lb for #4 and #6)
See- Fuel and energy- for internal conversion-1 Gal of #6 Fuel Oil 150,000 Btu’s
See- Norwak and Crane- 20,800 tC for 5,212,000 trees- net sequestration

For each zipcode- would want to find total sum of Btu, convert into gallons and find emissions factor
Next find the per tree storage factor and total tree count by zip, check difference, surplus, 
or gap in tree capture vs. emissions factor...

Visualization decisions. . . . another chart above pie, a simple bar, a circle behind the bar?

//----------------------------------Simple JSON--------------------------------------------
After this review we'll look at grabbing simple, live data from the web...

Example 1-refuse types and tonnages from NYC, json01_trash
Example 2-examination of Weather Underground, weather_alts as variation on live grab... sourcing alt data

Example 3- to develop this we'll want to return to json01_trash and see how it develops with additional json inputs
in particular, how we might combine different tables/types and convert between data forms....

//----------------------------------Copy and Edit------------------------------------------
Working with the idea of trash origin and transfer, total volumes and recycled volumes, we'll look at how we might
convert from a simple network graph to a more intelligent form...

Example 4-fry_edgenodes



