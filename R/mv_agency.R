#' Download Agency Data
#'
#' @param browser A browser binding created with \link{mv_browse}
#' @param agency An agency name (currently only supports \code{"SLMPD"})
#' @param statistic The statistic to download
#' @param pause Number of seconds to pause while pages load - adjust as
#'     needed depending on internet connection
#'
#' @importFrom dplyr mutate rename
#' @importFrom rvest html_nodes html_table
#' @importFrom tidyr gather
#' @importFrom xml2 read_html
#'
#' @export
mv_agency <- function(browser, agency, statistic, pause = 3){

  # global bindings
  `2000` = `2017` = NULL

  # get agency id
  ag <- mv_get_agency(agency = agency)

  # navigate browser
  browser$navigate(paste0("https://ago.mo.gov/home/vehicle-stops-report?lea=", ag))

  # pause
  Sys.sleep(pause)

  # menu option
  if (statistic == "Disparity" | statistic == "Disparity Index"){
    option <- browser$findElement(using = 'xpath', "//*/option[@value = 'disparityIndex']")
  } else if (statistic == "Stops" | statistic == "Stop Rate"){
    option <- browser$findElement(using = 'xpath', "//*/option[@value = 'totalStops']")
  } else if (statistic == "Searches" | statistic ==  "Search Rate"){
    option <- browser$findElement(using = 'xpath', "//*/option[@value = 'totalStopsSearches']")
  } else if (statistic == "Arrests" | statistic == "Arrest Rate"){
    option <- browser$findElement(using = 'xpath', "//*/option[@value = 'driversArrested']")
  } else if (statistic == "Contraband" | statistic == "Contraband Hit Rate"){
    option <- browser$findElement(using = 'xpath', "//*/option[@value = 'totalStopsDiscovery']")
  }

  # select menu item
  option$clickElement()

  # pause
  Sys.sleep(pause)

  # download page
  pg <- xml2::read_html(browser$getPageSource()[[1]])

  # get table
  tables <- rvest::html_nodes(pg, "table")
  tables <- rvest::html_table(tables)
  df <- tables[[1]]

  # pivot to long
  out <- tidyr::gather(df, key = "year", value = "value", `2000`:`2017`)
  out <- dplyr::rename(out, cat = "")
  out <- dplyr::mutate(out, cat = ifelse(cat == "Native American", "Native", cat))
  out <- dplyr::mutate(out, cat = ifelse(cat == "Totals", "Total", cat))

  # return output
  return(out)

}

mv_get_agency <- function(agency){

  ag <- tolower(agency)

  if (ag == "slmpd" | agency == "st. louis city police dept" | agency == "st. louis city police dept" | agency == "st. louis metropolitan police department"){
    out <- 587
  }

}
