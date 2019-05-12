agencies <- dplyr::tibble(
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
         583, 585, 587, 589, 612,
         622),
  name = c("ballwin", "bel-nor", "bel-ridge", "bella villa", "bellefontaine neighbors",
           "berkeley", "beverly hills", "breckenridge hills", "brentwood", "bridgeton",
           "calverton", "charlack", "chesterfield", "clarkson valley", "clayton",
           "cool valley", "country club hills", "crestwood", "creve coeur", "dellwood",
           "des peres", "edmundson", "edmundson", "eureka", "furguson",
           "florissant", "frontenac", "glen echo park", "glendale", "hazelwood",
           "hillsdale", "jennings", "kinloch", "kirkwood", "ladue",
           "lakeshire", "lambert airport", "manchester", "maplewood", "maryland heights",
           "meramec college", "moline acres", "normandy", "northwoods", "olivette",
           "pagedale", "riverview", "rock hill", "shrewsbury", "st. ann",
           "st. george", "st. john", "st. louis city", "st. louis county", "sunset hills",
           "town and country")
)

usethis::use_data(agencies)
