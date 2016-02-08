library(shiny)
library(plotly)
library(leaflet)
library(sp)

source('setup.R')

function(input, output, session) {
  
  county_frame <- reactive({
    
    if (input$radio == 1) {
      
      d <- filter(df, county_name == input$county)
      
      return(format_data(d))
      
    } else if (input$radio == 2) {
      
      d <- filter(df, county_name == input$county)
      
      return(format_white(d))
      
    } else if (input$radio == 3) {
      
      d <- filter(df, county_name == input$county)
      
      return(format_black(d))
      
    } else if (input$radio == 4) {
      
      d <- filter(df, county_name == input$county)
      
      return(format_hispanic(d))
      
    }
    
  })
  
  
  
  selected_county <- reactive({
    
    b <- boundaries[boundaries$name_long == input$county, ]
    
    return(b)
    
  })
  
  plot_colors <- reactive({
    
    if (input$radio == 1) {
      
      return(c('red', 'navy'))
      
    } else if (input$radio == 2) {
      
      return(c('#aec7e8', '#1f77b4'))
      
    } else if (input$radio == 3) {
      
      return(c('#ffbb78', '#ff7f0e'))
      
    } else if (input$radio == 4) {
      
      return(c('#98df8a', '#2ca02c'))
      
    }
    
  })
   
  output$pyramid <- renderPlotly({
    
    d <- county_frame()
    
    vals <- c(-1 * max_pop(county_frame()), -1 * (max_pop(county_frame()) / 2), 0, 
              max_pop(county_frame()) / 2, max_pop(county_frame()))
    
    year_data <- county_frame() %>% filter(year == input$year)
    
    plot_ly(year_data, x = population, y = age_groups, color = gender, type = 'bar', orientation = 'h', 
            hoverinfo = 'y+text+name', text = abs_pop, colors = plot_colors()) %>%
      layout(title = paste0(input$county, ', ', input$year), 
             bargap = 0.3, barmode = 'overlay', 
             xaxis = list(tickmode = 'array', tickvals = vals, ticktext = ticks(vals), 
                          title = "Population", 
                          range = c(min(d$population) + min(d$population) / 6, 
                                    max(d$population) + max(d$population) / 6)), 
             yaxis = list(title = "")) 
             # autosize = FALSE, width = 800, height = 600)
    
  })
  
  output$map <- renderLeaflet({
    
    tx <- texas_map() %>%
      addPolygons(data = selected_county(), fill = FALSE, color = '#FFFF00', 
                  opacity = 1, layerId = 'sel_cty') %>%
      fitBounds(lng1 = bbox(selected_county())[1], 
                lat1 = bbox(selected_county())[2], 
                lng2 = bbox(selected_county())[3], 
                lat2 = bbox(selected_county())[4])
    
    tx
      
    
  })
  
  county_click <- eventReactive(input$map_shape_click, {
    
    x <- input$map_shape_click
    
    y <- x$id
    
    return(y)
    
  })
  
  observe({
    
    updateSelectInput(session, 'county', selected = county_click())
    
  })
  
  observe({
    
    tx <- leafletProxy('map', session) %>%
      removeShape('sel_cty') %>%
      addPolygons(data = selected_county(), fill = FALSE, color = '#FFFF00', 
                  opacity = 1, layerId = 'sel_cty') %>%
      fitBounds(lng1 = bbox(selected_county())[1], 
                lat1 = bbox(selected_county())[2], 
                lng2 = bbox(selected_county())[3], 
                lat2 = bbox(selected_county())[4])
      
    
    
  })
  
}
