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



# presidential from 2016 #### -------------------------

nc2016_prez <- readRDS("processed_data/nc2016_prez.rds")

names(nc2016_prez)

prez_2016 <- nc2016_prez %>% 
  select(county, precinct, choice_party, total_votes)

#reshape to get candidate votes going across
prez_2016 <- prez_2016 %>% 
  dcast(county + precinct ~ choice_party, value.var = "total_votes", sum) %>% 
  as_tibble()

#rename columns
prez_2016 <- prez_2016 %>% 
  rename(
    dem16 = DEM,
    lib16 = LIB,
    gop16 = REP,
    non16 = NON
  )

#calculate total and percentages for each candidate
prez_2016 <- prez_2016 %>% 
  mutate(
    total16 = (dem16 + lib16 + gop16 + non16),
    dem16pct = round_half_up((dem16/total16)*100, 1),
    gop16pct = round_half_up((gop16/total16)*100, 1),
    margin16 = abs(dem16pct - gop16pct)
  )
