# pilot inverse distance weighting process

# dependencies

## tidyverse
library(dplyr)
library(tibble)

## spatial
library(tigris)
library(spdep)
library(sf)

# focal counties
focal_counties <- c("099", "183", "189")

# download and re-project Missouri tracts; remove City of St. Louis tracts
tracts_MO <- tracts(state = 29, class = "sf") %>%
  st_transform(crs = 26915) %>%
  filter(COUNTYFP != 510) %>%
  filter(COUNTYFP %in% focal_counties == TRUE) %>%
  select(GEOID)

# focal counties
focal_counties <- c("119", "133", "163")

# download and re-project Illinois tracts
tracts_IL <- tracts(state = 17, class = "sf") %>%
  st_transform(crs = 26915) %>%
  filter(COUNTYFP %in% focal_counties == TRUE) %>%
  select(GEOID)

# download county geometry for the City of St. Louis
stl <- counties(state = 29, class = "sf") %>%
  st_transform(crs = 26915) %>%
  filter(COUNTYFP == 510) %>%
  select(GEOID)

# combine data
data <- rbind(tracts_MO, tracts_IL)
data <- rbind(stl, data)

# create shed
shed <- mv_create_shed(data, primary = 29510, radius = 20, power = .5)

# preview
mapview::mapview(shed, zcol = "idw")
