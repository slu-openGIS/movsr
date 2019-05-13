devtools::load_all()
library(RSelenium)

remDr <- remoteDriver(port=4445L, browserName = "firefox")
remDr$open()

slmpd_stops <- mv_get_agency(browser = remDr, agency = 587, statistic = "Stops", pause = 1)

save(slmpd_stops, file = "inst/extdata/slmpd_stops.rda")
