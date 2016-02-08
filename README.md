# texas_pyramids
Shiny application to explore Texas county demographics
https://walkerke.shinyapps.io/texas_pyramids/

This repository stores the source code for the Shiny application "Demographics of Texas Counties, 2010-2050," produced by the [TCU Center for Urban Studies](http://urbanstudies.tcu.edu/).  The application displays population pyramids for all 254 counties in Texas by race and ethnicity, as well as projected future pyramids under a scenario of 50 percent of the 2000-2010 net migration rate.  Data for the application come from the [2014 Texas Population Projections Program](http://osd.texas.gov/Data/TPEPP/Projections/), Office of the Texas State Demographer.  

The application is fully reproducible with an MIT license, so please clone and adapt the code in your own applications.  To run the application locally: 

1. Install R from https://cran.r-project.org/
2. Install RStudio from https://www.rstudio.com/products/RStudio/
3. Install the following R packages: __shiny__, __plotly__, __leaflet__, __shinythemes__, __sp__, __dplyr__, and __tidyr__
4. Run the following command: `shiny::runGitHub('walkerke/texas_pyramids')`
