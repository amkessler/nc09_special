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
