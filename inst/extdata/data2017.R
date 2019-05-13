# script for creating the 2017 cross sectional data set

# dependencies
library(dplyr)      # data wrangling
library(movsr)      # tools for scraping and cleaning vehicle stop reports
library(purrr)      # iteration
library(RSelenium)  # headless browsing

# connect to headless browswer, which must be started in terminal (see Get started)
remDr <- remoteDriver(port=4445L, browserName = "firefox")
remDr$open()

# create vector of agency ids to iterate over
# focus only on agencies that had 2017 stop data
depts <- filter(agencies, valid == TRUE)
depts <- depts$id

# download stop data and calculate proportions
depts %>%
  map_df(~ mv_batch_agency(browser = remDr, agency = .x, statistic = "Stops", format = "prop",
                           category = "Black", year = 2017, pause = 1)) %>%
  rename(prop = value) -> blackProp

# download stop data and retain counts
depts %>%
  map_df(~ mv_batch_agency(browser = remDr, agency = .x, statistic = "Stops", format = "count",
                           category = "Black", year = 2017, pause = 1)) %>%
  select(agency, value) %>%
  rename(count = value) -> blackCount

# download disparity data and clean
depts %>%
  map_df(~ mv_batch_agency(browser = remDr, agency = .x, statistic = "Disparity", format = "index",
                           category = "Black", year = 2017, pause = 1)) %>%
  select(agency, value) %>%
  rename(disp = value) -> blackDisp

# combine data sets
data2017 <- left_join(blackProp, blackCount, by = "agency")
data2017 <- left_join(data2017, blackDisp, by = "agency")

# save data
save(data2017, file = "inst/extdata/data2017.rda")
