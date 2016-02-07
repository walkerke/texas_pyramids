library(shiny)
library(plotly)
library(leaflet)
library(shinythemes)

source('setup.R')

navbarPage('Demographics of Texas Counties, 2010-2050', theme = shinytheme('spacelab'), 
           
  sidebarLayout(
    sidebarPanel(
       selectInput("county",
                   "Select a county:",
                   choices = county_choices,
                   selected = 'Tarrant County'), 
       sliderInput("year", 
                   "Select a year:", 
                   min = 2010, 
                   max = 2050, 
                   value = 2016, 
                   animate = animationOptions(interval = 500, loop = TRUE), 
                   sep = ''), 
       radioButtons('radio', label = 'Select a group:', inline = TRUE, 
                    choices = list("Total" = 1, "White" = 2, 
                                   'Black' = 3, 'Hispanic' = 4), 
                    selected = 1), 
       leafletOutput("map")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotlyOutput("pyramid", height = '600px', width = '800px'), 
       br(), 
       p('Data source: ', a('Texas Population Projections Program, Office of the Texas State Demographer', 
                            href = 'http://osd.texas.gov/Data/TPEPP/Projections/')), 
       p('Produced by the ', a('Center for Urban Studies at Texas Christian University', 
                               href = 'http://urbanstudies.tcu.edu/'))
    )
  ), 
  
  navbarMenu('About the app',
             tabPanel(a('Blog post', href = ' http://urbanstudies.tcu.edu/tx-county-demographics-post/', target = '_blank')), 
             tabPanel(a('Source code', href = 'http://urbanstudies.tcu.edu/blog/', target = '_blank')), 
             tabPanel(a('Population projection methodology', 
                        href = 'http://osd.texas.gov/Data/TPEPP/Projections/Methodology.pdf', target = '_blank'))
  ) 
)
