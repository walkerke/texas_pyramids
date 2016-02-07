library(readr)
library(magrittr)
library(dplyr)
library(tigris)

df <- read_csv('2014allcntyindage/2014allcntyindage.csv') %>%
  filter(age_in_yrs_num != -1, migration_scenario_num == 0.5)

save(df, file = 'texas.rds')

boundaries <- counties('TX', cb = TRUE, resolution = '5m')

boundaries$name_long <- paste(boundaries$NAME, 'County')

save(boundaries, file = 'tx_counties.rds')
