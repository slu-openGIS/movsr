library(dplyr)

agencies_189 <- tibble(
  id = c(376, 382, 383, 385, 387,
         393, 397, 11, 13, 14,
         36, 62, 64, 76, 82,
         92, 97, 102, 103, 115,
         118, 140, 144, 149, 161,
         166, 179, 193, 194, 223,
         233, 268, 282, 284, 290,
         302, 304, 342, 344, 416,
         423, 440, 476, 479, 489,
         505, 509, 510, 564, 575,
         583, 585, 589, 612,
         622, 636, 637, 649, 668,
         670, 677, 678, 686, 689,
         698, 700, 710, 715, 744,
         767, 807, 816, 825, 860,
         817),
  name = c("Ballwin", "Bel-Nor", "Bel-Ridge", "Bella Villa", "Bellefontaine Neighbors",
           "Berkeley", "Beverly Hills", "Breckenridge Hills", "Brentwood", "Bridgeton",
           "Calverton", "Charlack", "Chesterfield", "Clarkson Valley", "Clayton",
           "Cool Valley", "Country Club Hills", "Crestwood", "Creve Coeur", "Dellwood",
           "Des Peres", "Edmundson", "Ellisville", "Eureka", "Furguson",
           "Florissant", "Frontenac", "Glen Echo Park", "Glendale", "Hazelwood",
           "Hillsdale", "Jennings", "Kinloch", "Kirkwood", "Ladue",
           "Lakeshire", "Lambert Airport", "Manchester", "Maplewood", "Maryland Heights",
           "Meramec College", "Moline Acres", "Normandy", "Northwoods", "Olivette",
           "Pagedale", "Riverview", "Rock Hill", "Shrewsbury", "St. Ann",
           "St. George", "St. John", "St. Louis County", "Sunset Hills",
           "Town and Country", "UMSL", "University City", "Pine Lawn", "Richmond Heights",
           "Velda City", "Vinita Park", "Vinita Terrace", "Warson Woods", "Washington University",
           "Webster Groves", "Wellston", "Winchester", "Woodson Terrace", "Pasadena Park",
           "Flordell Hills", "Westwood", "Oakland", "Uplands Park", "Sycamore Hills",
           "Norfolk Southern Railroad"),
  valid = c(TRUE, TRUE, TRUE, TRUE, TRUE,
            TRUE, FALSE, TRUE, TRUE, TRUE,
            TRUE, FALSE, TRUE, FALSE, TRUE,
            FALSE, TRUE, TRUE, TRUE, FALSE,
            TRUE, TRUE, TRUE, TRUE, TRUE,
            TRUE, TRUE, FALSE, TRUE, TRUE,
            TRUE, FALSE, FALSE, TRUE, TRUE,
            TRUE, FALSE, TRUE, TRUE, TRUE,
            FALSE, TRUE, TRUE, FALSE, TRUE,
            TRUE, TRUE, TRUE, TRUE, TRUE,
            FALSE, TRUE, TRUE, TRUE,
            TRUE, FALSE, TRUE, FALSE, TRUE,
            TRUE, TRUE, FALSE, TRUE, FALSE,
            TRUE, FALSE, FALSE, TRUE, FALSE,
            TRUE, FALSE, FALSE, FALSE, TRUE,
            FALSE)
)

agencies_189 %>%
  arrange(name) %>%
  mutate(countyfp = 189) %>%
  mutate(namelsad = "St. Louis County") -> agencies_189

agencies_510 <- tibble(
  id = c(587, 783, 846, 856),
  name = c("St. Louis City", "SLCC", "St. Louis Park Rangers", "Union Pacfic Railroad"),
  valid = c(TRUE, FALSE, FALSE, FALSE)
)

agencies_510 %>%
  arrange(name) %>%
  mutate(countyfp = 510) %>%
  mutate(namelsad = "St. Louis City") -> agencies_510

agencies <- bind_rows(agencies_189, agencies_510)

usethis::use_data(agencies, overwrite = TRUE)
