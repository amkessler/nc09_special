library(tidyverse)
library(janitor)
library(lubridate)
library(reshape2)
library(writexl)
options(scipen = 999)

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

#save result to file
saveRDS(midterm_2018, "processed_data/midterm_2018.rds")


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
    dem19 = DEM,
    lib19 = LIB,
    gop19 = REP,
    gre19 = GRE
  )

#calculate total and percentages for each candidate
special_2019 <- special_2019 %>% 
  mutate(
    total19 = (dem19 + lib19 + gop19 + gre19),
    dem19pct = round_half_up((dem19/total19)*100, 1),
    gop19pct = round_half_up((gop19/total19)*100, 1),
    margin19 = abs(dem19pct - gop19pct)
  )

#save result to file
saveRDS(special_2019, "processed_data/special_2019.rds")




### JOIN TOGETHER AND COMPARE #### ----------------------------------

joined_allcols <- inner_join(midterm_2018, special_2019)

joined_allcols 

names(joined_allcols)

#select just the columns needed for the pct comparisons
joined <- joined_allcols %>% 
  select(
    county,
    precinct,
    dem18,
    gop18,
    dem18pct,
    gop18pct,
    margin18,
    dem19,
    gop19,
    dem19pct,
    gop19pct,
    margin19
  )

#create derived columns to use for analysis
joined <- joined %>% 
  mutate(
    winner18 = if_else(dem18pct > gop18pct, "D", "R"),
    winner19 = if_else(dem19pct > gop19pct, "D", "R"),
    flip = if_else(winner18 == winner19, "N", "Y"),
    dem_change = dem19pct - dem18pct,
    dem_vote_change = dem19 - dem18,
    dem_updown = if_else(dem_change < 0, "down", "up"),
    dem_updown = if_else(dem_change == 0, "none", dem_updown),
    gop_change = gop19pct - gop18pct,
    gop_vote_change = gop19 - gop18,
    gop_updown = if_else(gop_change < 0, "down", "up"),
    gop_updown = if_else(gop_change == 0, "none", gop_updown),
    margin_tot_change = round_half_up(margin19 - margin18, 1),
    vote_change_ratio_dem = round_half_up(dem_vote_change/gop_vote_change, 2),
    vote_change_ratio_gop = round_half_up(gop_vote_change/dem_vote_change, 2)
  )

#save to file
saveRDS(joined, "processed_data/joined.rds")
write_xlsx(joined, "processed_data/joined.xlsx")




# ANALYSIS #### ----------------------------------------------

joined

#flips
joined %>% 
  count(flip)

joined %>% 
  filter(flip == "Y") %>% 
  count(flip, winner19, county)

#up or down
joined %>% 
  count(dem_updown)

joined %>% 
  count(gop_updown)


#which counties
joined %>% 
  count(county)



# ROBESON 

robeson <- joined %>% 
  filter(county == "ROBESON")

#flips
robeson %>% 
  count(flip)

robeson %>% 
  filter(flip == "Y") %>% 
  count(flip, winner19)


#up or down
robeson %>% 
  count(dem_updown)

robeson %>% 
  count(gop_updown)



