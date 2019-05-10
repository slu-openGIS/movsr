devtools::load_all()

x <- mv_browse(chromever = "74.0.3729.6")

y <- mv_agency(browser = x, agency = "SLMPD", statistic = "Stops")

library(ggplot2)
library(dplyr)
library(prener)
library(RColorBrewer)

y %>%
  ggplot(mapping = aes(x = as.numeric(year), y = value, color = cat)) +
  geom_line(size = 2) +
  scale_colour_brewer(palette = "Dark2", name = "Race") +
  labs(
    title = "Disparity Index for Traffic Stops",
    subtitle = "St. Louis Metropolitan Police Department",
    x = "Year",
    y = "Disparity Index",
    caption = "Data via the Missouri Attorney General's Office"
  ) +
  cp_sequoiaTheme(background = "white") -> plot

cp_plotSave(filename = "plot.png", preset = "lg")
