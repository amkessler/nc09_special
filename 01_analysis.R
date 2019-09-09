library(tidyverse)
library(janitor)
library(fs)
library(lubridate)


#load precinct data from step 00
combined2018 <- readRDS("processed_data/combined2018_precincts.rds")

glimpse(combined2018)

as.numeric(combined2018$group_vote_ct_adj)

#pull out only results for NC-09 congressional district
nc09_precincts18 <- combined2018 %>% 
  filter(contest_title == "US HOUSE OF REPRESENTATIVES DISTRICT 09")

nc09_precincts18 %>% 
  group_by(candidate_name, candidate_party_lbl) %>% 
  summarise(cnt = n(), )
