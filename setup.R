library(dplyr)
library(plotly)
library(tidyr)
library(leaflet)

load('texas.rds')

load('tx_counties.rds')

groups <- c('0-4', '5-9', '10-14', '15-19', '20-24', '25-29', '30-34', '35-39', '40-44', 
            '45-49', '50-54', '55-59', '60-64', '65-69', '70-74', '75-79', '80-84', '85+')

breaks <- seq(0, 90, 5)

county_choices <- unique(df$county_name)[-1]

max_pop <- function(x) {
  if (max(x$abs_pop) >= 10000) {
    return(plyr::round_any(max(x$abs_pop), 10000))
  } else if (max(x$abs_pop) >= 1000 & max(x$abs_pop < 10000)) {
    return(plyr::round_any(max(x$abs_pop), 1000))
  } else {
    return(plyr::round_any(max(x$abs_pop), 100))
  }
}

ticks <- function(v) {
  u <- sapply(v, function(x) {
    if (abs(x) > 999) {
      x <- paste0(as.character(abs(x / 1000)), 'K')
    } else {
      x <- as.character(abs(x))
    }
  })
  
  return(u)
  
}

format_data <- function(input_df) {
  
  county <- input_df %>% 
    select(Male = total_male, Female = total_female, age = age_in_yrs_num, year) %>%
    mutate(Male = -1 * Male) %>%
    gather(gender, population, -age, -year) %>%
    mutate(abs_pop = abs(population), 
           age_groups = cut(age, breaks = breaks, labels = groups, 
                            include.lowest = TRUE, right = FALSE)) %>%
    group_by(age_groups, gender, year) %>%
    summarize(population = sum(population), abs_pop = sum(abs_pop)) 
  
  return(county)
  
}

format_white <- function(input_df) {
  
  county <- input_df %>% 
    select(Male = anglo_male, Female = anglo_female, age = age_in_yrs_num, year) %>%
    mutate(Male = -1 * Male) %>%
    gather(gender, population, -age, -year) %>%
    mutate(abs_pop = abs(population), 
           age_groups = cut(age, breaks = breaks, labels = groups, 
                            include.lowest = TRUE, right = FALSE)) %>%
    group_by(age_groups, gender, year) %>%
    summarize(population = sum(population), abs_pop = sum(abs_pop)) 
  
  return(county)
  
} 

format_black <- function(input_df) {
  
  county <- input_df %>% 
    select(Male = black_male, Female = black_female, age = age_in_yrs_num, year) %>%
    mutate(Male = -1 * Male) %>%
    gather(gender, population, -age, -year) %>%
    mutate(abs_pop = abs(population), 
           age_groups = cut(age, breaks = breaks, labels = groups, 
                            include.lowest = TRUE, right = FALSE)) %>%
    group_by(age_groups, gender, year) %>%
    summarize(population = sum(population), abs_pop = sum(abs_pop)) 
  
  return(county)
  
} 

format_hispanic <- function(input_df) {
  
  county <- input_df %>% 
    select(Male = hispanic_male, Female = hispanic_female, age = age_in_yrs_num, year) %>%
    mutate(Male = -1 * Male) %>%
    gather(gender, population, -age, -year) %>%
    mutate(abs_pop = abs(population), 
           age_groups = cut(age, breaks = breaks, labels = groups, 
                            include.lowest = TRUE, right = FALSE)) %>%
    group_by(age_groups, gender, year) %>%
    summarize(population = sum(population), abs_pop = sum(abs_pop)) 
  
  return(county)
  
} 



texas_map <- function() {
  
  leaflet(boundaries) %>%
    addProviderTiles('CartoDB.Positron') %>%
    addPolygons(weight = 1, smoothFactor = 0.2, color = '#00008B', 
                fillColor = '#00008B', label = ~name_long, 
                layerId = ~name_long)
  
}

# Old stuff

# build_pyramid <- function(input_df) {
#   
#   county <- input_df %>% 
#     select(Male = total_male, Female = total_female, age = age_in_yrs_num) %>%
#     mutate(Male = -1 * Male) %>%
#     gather(gender, population, -age) %>%
#     mutate(abs_pop = abs(population), 
#            age_groups = cut(age, breaks = breaks, labels = groups, 
#                             include.lowest = TRUE, right = FALSE)) %>%
#     group_by(age_groups, gender) %>%
#     summarize(population = sum(population), abs_pop = sum(abs_pop)) 
#   
#   vals <- c(-1 * max_pop(county), -1 * (max_pop(county) / 2), 0, max_pop(county) / 2, max_pop(county))
#   
#   
#   plot_ly(county, x = population, y = age_groups, color = gender, type = 'bar', orientation = 'h', 
#           hoverinfo = 'y+text+name', text = abs_pop, colors = c('navy', 'red')) %>%
#     layout(title = paste0(unique(input_df$county), ', ', unique(input_df$year)), 
#            bargap = 0.3, barmode = 'overlay', 
#            xaxis = list(tickmode = 'array', tickvals = vals, ticktext = ticks(vals), 
#                         title = "Population"), 
#            yaxis = list(title = ""))
#   
# }
