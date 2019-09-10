library(tidyverse)
library(janitor)
library(fs)
library(lubridate)


#load precinct data from step 00
combined2018 <- readRDS("processed_data/combined2018_precincts.rds")

glimpse(combined2018)

combined2018$group_vote_ct_adj <- as.numeric(combined2018$group_vote_ct_adj)
combined2018$group_vote_ct_adj <- combined2018$group_vote_ct_adj - 1 #adjustment per documentation: see READ_ME file


#pull out only results for NC-09 congressional district
nc09_precincts18 <- combined2018 %>% 
  filter(contest_title == "US HOUSE OF REPRESENTATIVES DISTRICT 09")

#pull grand totals by candidate
nc09_precincts18 %>% 
  filter(!candidate_name %in% c("OVER VOTE", "UNDER VOTE")) %>% 
  group_by(candidate_name, candidate_party_lbl) %>% 
  summarise(cnt = n(), sum(group_vote_ct_adj))

#pull grand totals by candidate
nc09_grpby_county <- nc09_precincts18 %>% 
  filter(!candidate_name %in% c("OVER VOTE", "UNDER VOTE"),
         county_desc %in% c("UNION",
                              "MECKLENBURG",
                               "ANSON",
                               "RICHMOND",
                               "SCOTLAD",
                               "ROBESON",
                               "BLADEN",
                               "CUMBERLAND",
                               "HOKE")
         ) %>% 
  group_by(county_desc, candidate_name, candidate_party_lbl) %>% 
  summarise(cnt = n(), sum(group_vote_ct_adj))

#save output file
write_csv(nc09_grpby_county, "output/nc09_grpby_county.csv")
write_csv(nc09_precincts18, "output/nc09_precincts18.csv")



#### 2016 PRESIDENTIAL ####

#load saved version from step 00
nc2016_prez <- readRDS("processed_data/nc2016_prez.rds")





