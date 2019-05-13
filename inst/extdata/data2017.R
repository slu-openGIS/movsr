# script for creating the 2017 cross sectional data set
# make sure Docker is up and running before starting

# dependencies
library(dplyr)
library(movsr)
library(purrr)
library(RSelenium)

# connect to headless browswer
remDr <- remoteDriver(port=4445L, browserName = "firefox")
remDr$open()

# create vector of agency ids to iterate over
# focus only on agencies that had 2017 stop data
depts <- filter(agencies, valid == TRUE)
depts <- depts$id

# download stop data and clean
depts %>%
  map_df(~ mv_batch_agency(browser = remDr, agency = .x, statistic = "Stops", format = "prop",
                           category = "Black", year = 2017, pause = 1)) %>%
  rename(prop = value) -> blackProp

# download disparity data and clean
depts %>%
  map_df(~ mv_batch_agency(browser = remDr, agency = .x, statistic = "Disparity",
                           category = "Black", year = 2017, pause = 1)) %>%
  select(agency, value) %>%
  rename(disp = value) -> blackDisp

# combine data sets
data2017 <- left_join(blackProp, blackDisp, by = "agency")

# save data
save(data2017, file = "inst/extdata/data2017.rda")
