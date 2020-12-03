# load packages
# follow instruction on https://github.com/GL-Li/totalcensus to setup 
# totalcensus package
library(totalcensus)  
set_path_to_census("/Users/madeline.campbell/Documents/GitHub/tx_2020/data/my_census_data")
library(tidyverse)
library(leaflet)

# federal and state prison location and population
# search tables for tables of prison population
# search_tablecontents("decennial")
# PCT0200005 for federal prison
# PCT0200006 for state prison
# PCT0200007 for local jail

# read prison population data and format data
pris_pop <- read_decennial(
  year = 2010,
  states = "US",
  table_contents = c(
    "total = PCT0200003", 
    "fed_pris = PCT0200005", 
    "state_pris = PCT0200006",
    "local_jail = PCT0200007"
  ),
  summary_level = "county subdivision",
  show_progress = FALSE
) %>%
  # remove county subdivisions that has no prison popualation
  filter(fed_pris != 0 | state_pris != 0 | local_jail != 0) %>%
  mutate(fed_pris = ifelse(fed_pris == 0, NA, fed_pris)) %>%
  mutate(state_pris = ifelse(state_pris == 0, NA, state_pris)) %>%
  mutate(local_jail = ifelse(local_jail == 0, NA, local_jail)) %>%
  select(lon, lat, NAME, fed_pris, state_pris, local_jail) %>%
  gather(key = "type", value = "inmates", -c(lon, lat, NAME)) %>%
  filter(!is.na(inmates)) %>%
  mutate(type = factor(
    type, levels = c("local_jail", "state_pris", "fed_pris")
  )) %>%
  arrange(-inmates)


write.csv(pris_pop, '/Users/madeline.campbell/Documents/GitHub/tx_2020/data/us_prisons.csv')


pris_pop_tx <- read_decennial(
  year = 2010,
  states = "TX",
  table_contents = c(
    "total = PCT0200003", 
    "fed_pris = PCT0200005", 
    "state_pris = PCT0200006",
    "local_jail = PCT0200007"
  ),
  summary_level = "county subdivision",
  show_progress = FALSE
) %>%
  # remove county subdivisions that has no prison popualation
  filter(fed_pris != 0 | state_pris != 0 | local_jail != 0) %>%
  mutate(fed_pris = ifelse(fed_pris == 0, NA, fed_pris)) %>%
  mutate(state_pris = ifelse(state_pris == 0, NA, state_pris)) %>%
  mutate(local_jail = ifelse(local_jail == 0, NA, local_jail)) %>%
  select(lon, lat, NAME, fed_pris, state_pris, local_jail) %>%
  gather(key = "type", value = "inmates", -c(lon, lat, NAME)) %>%
  filter(!is.na(inmates)) %>%
  mutate(type = factor(
    type, levels = c("local_jail", "state_pris", "fed_pris")
  )) %>%
  arrange(-inmates)

write.csv(pris_pop_tx, '/Users/madeline.campbell/Documents/GitHub/tx_2020/data/tx_prisons.csv')

