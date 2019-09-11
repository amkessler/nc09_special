library(tidyverse)
library(janitor)
library(fs)
library(lubridate)


#combine BOE 2018 precinct results into one ####

#set directory location
data_dir <- "raw_data/2018precincts"

#list files in directory
fs::dir_ls(data_dir)

#limit to csv files
csv_files <- fs::dir_ls(data_dir, regexp = "\\.csv$")
csv_files

#start with one file
test <- read_csv(csv_files[1], col_types = cols(.default = "c"))

#now we'll read in all the files and combine into one
combined2018 <- csv_files %>% 
  map_dfr(read_csv, col_types = cols(.default = "c"))

#save result
saveRDS(combined2018, "processed_data/combined2018_precincts.rds")


#load 2016 results #####
nc2016 <- read_tsv("raw_data/precinct_sort_statewide_at_large_contests_no_admin_precincts_20161108.txt")

nc2016 <- nc2016 %>% 
  clean_names()

#filter just for presidential race
nc2016_prez <- nc2016 %>% 
  filter(contest_name == "US PRESIDENT")

#remove NAs (under- and over-vote records)
nc2016_prez <- nc2016_prez %>% 
  filter(!is.na(choice_party))

#save result
saveRDS(nc2016_prez, "processed_data/nc2016_prez.rds")



### use NC BOE full txt file for 2018 ####

#load 2018 results
nc2018 <- read_tsv("raw_data/results_pct_20181106.txt")

nc2018 <- nc2018 %>% 
  clean_names()

#filter for NC-09 only
nc2018_house9 <- nc2018 %>% 
  filter(contest_name == "US HOUSE OF REPRESENTATIVES DISTRICT 09")

#save result
saveRDS(nc2018_house9, "processed_data/nc2018_house9.rds")

nc2018_house9 %>% 
  count(choice_party)

nc2018_house9 %>% 
  count(county)


# load 2019 special election results from BOE text file ####
nc2019 <- read_tsv("raw_data/results_pct_20190910.txt")

nc2019 <- nc2019 %>% 
  clean_names()

#filter for NC-09 only
nc2019_house9 <- nc2019 %>% 
  filter(contest_name == "US HOUSE OF REPRESENTATIVES DISTRICT 09")

#save result
saveRDS(nc2019_house9, "processed_data/nc2019_house9.rds")

nc2019_house9 %>% 
  count(choice_party)


