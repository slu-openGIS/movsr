
ggplot(race, mapping = aes(x = prop, y = disp)) +
  geom_hline(yintercept = 1, color = "#ff0000", alpha = .5, size = 1.5) +
  geom_point(size = 2) +
  scale_y_continuous(breaks=c(1,3,5,7,9,11,13,15)) +
  labs(
    title = "Race and the Disparity Index for Vehicle Stops",
    subtitle = "St. Louis City and County Departments",
    x = "African American Proportion of Total Stops",
    y = "Disparity Index",
    caption = "Plot by Christopher Prener, Ph.D.\nData via the Missouri Attorney General's Office"
  ) +
  cp_sequoiaTheme(base_size = 24, background = "white") -> plot

cp_plotSave(plot, filename = "plot1.png", preset = "lg")

ggplot(race, mapping = aes(x = prop, y = disp)) +
  geom_point(size = 2) +
  gghighlight(disp > 10, label_key = agency) +
  scale_y_continuous(breaks=c(1,3,5,7,9,11,13,15)) +
  labs(
    title = "Extreme Disparity Index for Vehicle Stops",
    subtitle = "St. Louis City and County Departments",
    x = "African American Proportion of Total Stops",
    y = "Disparity Index",
    caption = "Plot by Christopher Prener, Ph.D.\nData via the Missouri Attorney General's Office"
  ) +
  cp_sequoiaTheme(base_size = 24, background = "white") -> plot

cp_plotSave(plot, filename = "plot2.png", preset = "lg")

ggplot(race, mapping = aes(x = prop, y = disp)) +
  geom_point(size = 2) +
  gghighlight(prop >= .75, disp > 1.2, label_key = agency) +
  scale_y_continuous(breaks=c(1,3,5,7,9,11,13,15)) +
  labs(
    title = "Very High Proportion for Vehicle Stops",
    subtitle = "St. Louis City and County Departments",
    x = "African American Proportion of Total Stops",
    y = "Disparity Index",
    caption = "Plot by Christopher Prener, Ph.D.\nData via the Missouri Attorney General's Office"
  ) +
  cp_sequoiaTheme(base_size = 24, background = "white") -> plot

cp_plotSave(plot, filename = "plot3.png", preset = "lg")

ggplot(race, mapping = aes(x = prop, y = disp)) +
  geom_point(size = 2) +
  gghighlight(prop >= .2, disp >= 2, label_key = agency) +
  scale_y_continuous(breaks=c(1,3,5,7,9,11,13,15)) +
  labs(
    title = "High Proportion and Disparity Index for Vehicle Stops",
    subtitle = "St. Louis City and County Departments",
    x = "African American Proportion of Total Stops",
    y = "Disparity Index",
    caption = "Plot by Christopher Prener, Ph.D.\nData via the Missouri Attorney General's Office"
  ) +
  cp_sequoiaTheme(base_size = 24, background = "white") -> plot

cp_plotSave(plot, filename = "plot4.png", preset = "lg")
