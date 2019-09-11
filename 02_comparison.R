library(tidyverse)
library(janitor)
library(lubridate)
library(reshape2)

#load 2018 results from step 00
nc2018_house9 <- readRDS("processed_data/nc2018_house9.rds")

#remove precincts not marked as real
midterm_2018 <- nc2018_house9 %>% 
  filter(real_precinct == "Y")

names(midterm_2018)

midterm_2018 <- midterm_2018 %>% 
  select(county, precinct, choice_party, total_votes)


#reshape to get candidate votes going across
midterm_2018 <- midterm_2018 %>% 
  dcast(county + precinct ~ choice_party, value.var = "total_votes", sum) %>% 
  as_tibble()

#rename columns
midterm_2018 <- midterm_2018 %>% 
  rename(
    dem18 = DEM,
    lib18 = LIB,
    gop18 = REP
  )

#calculate total and percentages for each candidate
midterm_2018 <- midterm_2018 %>% 
  mutate(
    total18 = (dem18 + lib18 + gop18),
    dem18pct = round_half_up((dem18/total18)*100, 1),
    gop18pct = round_half_up((gop18/total18)*100, 1),
    margin18 = abs(dem18pct - gop18pct)
  )



#load 2019 special election results from step 00 #### -------------------------------------

nc2019_house9 <- readRDS("processed_data/nc2019_house9.rds")

#remove precincts not marked as real
special_2019 <- nc2019_house9 %>% 
  filter(real_precinct == "Y")

names(special_2019)

special_2019 <- special_2019 %>% 
  select(county, precinct, choice_party, total_votes)


#reshape to get candidate votes going across
special_2019 <- special_2019 %>% 
  dcast(county + precinct ~ choice_party, value.var = "total_votes", sum) %>% 
  as_tibble()

#rename columns
special_2019 <- special_2019 %>% 
  rename(
    dem18 = DEM,
    lib18 = LIB,
    gop18 = REP,
    gre18 = GRE
  )

#calculate total and percentages for each candidate
special_2019 <- special_2019 %>% 
  mutate(
    total18 = (dem18 + lib18 + gop18 + gre18),
    dem18pct = round_half_up((dem18/total18)*100, 1),
    gop18pct = round_half_up((gop18/total18)*100, 1),
    margin18 = abs(dem18pct - gop18pct)
  )







