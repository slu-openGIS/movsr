devtools::load_all()

remDr <- remoteDriver(port=4445L, browserName = "chrome")
remDr$open()

y <- mv_get_agency(browser = remDr, agency = 193, statistic = "Stops")
y <- mv_reformat(y, statistic = "Stops", format = "prop")
y <- mv_filter(y, category = "Black", date = 2017)

mv_batch_agency(browser = x, agency = 589, statistic = "Stops", format = "prop", category = "Black", date = 2017)

library(ggplot2)
library(dplyr)
library(purrr)
library(prener)
library(RColorBrewer)

y %>%
  ggplot(mapping = aes(x = as.numeric(year), y = value, color = cat)) +
  geom_line(size = 2) +
  scale_colour_brewer(palette = "Dark2", name = "Race") +
  labs(
    title = "Racial Breakdown of Traffic Stops",
    subtitle = "St. Louis County Police Department",
    x = "Year",
    y = "Proportion of Total Stops",
    caption = "Plot by Christopher Prener, Ph.D.\nData via the Missouri Attorney General's Office"
  ) +
  cp_sequoiaTheme(background = "white") -> plot

cp_plotSave(filename = "plot.png", preset = "lg")

# create vector of agency ids to iterate over
depts <- filter(agencies, id != 193 & id != 282 & id != 423)
depts <- depts$id

# create subset due to httr timeout issues
depts1 <- depts[1:10]

# iterate over first 10
depts1 %>%
  map_df(~ mv_batch_agency(browser = x, agency = .x, statistic = "Stops", format = "prop",
                           category = "Black", date = 2017, pause = 1)) -> blackProp1

# create subset due to httr timeout issues
depts1 <- depts[11:20]

# iterate over next 10
depts1 %>%
  map_df(~ mv_batch_agency(browser = x, agency = .x, statistic = "Stops", format = "prop",
                           category = "Black", date = 2017, pause = 1)) -> blackProp2

# create subset due to httr timeout issues
depts1 <- depts[21:30]

# iterate over next 20
depts1 %>%
  map_df(~ mv_batch_agency(browser = x, agency = .x, statistic = "Stops", format = "prop",
                           category = "Black", date = 2017, pause = 1)) -> blackProp3

