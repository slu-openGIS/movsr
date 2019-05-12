devtools::load_all()

x <- mv_browse(chromever = "74.0.3729.6")

y <- mv_get_agency(browser = x, agency = 589, statistic = "Stops")
y <- mv_reformat(y, statistic = "Stops", format = "prop")
y <- mv_filter(y, category = "Black", date = 2017)

y2 <- mv_agency(browser = x, agency = "SLMPD", statistic = "Stops")

library(ggplot2)
library(dplyr)
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
