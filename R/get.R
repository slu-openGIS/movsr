#' Download Agency Data
#'
#' @description Download a single agency's data from the Missouri Attorney
#'     General's Office.
#'
#' @details The statistics that can be downloaded for each agency are as follows:
#'
#' \describe{
#'     \item{\code{"Disparity"}}{}
#'     \item{\code{"Stops"}}{}
#'     \item{\code{"Searches"}}{}
#'     \item{\code{"Arrests"}}{}
#'     \item{\code{"Contraband"}}{}
#' }
#'
#' @return A tibble in 'long' format containing vehicle stop statistics for the
#'     requested agency. Data may need additional formatting - see \code{\link{mv_reformat}}.
#'
#' @param browser Name of a browser binding created with \code{RSelenium}
#' @param agency An agency name (for St. Louis City and County agencies) or id number
#'     (for agencies statewide).
#' @param statistic The statistic to download
#' @param pause Number of seconds to pause while pages load - adjust as
#'     needed depending on internet connection
#' @param add_agency Append agency name to returned data; set to \code{FALSE} if you
#'     are downloading data outside of St. Louis City or County
#'
#' @importFrom dplyr mutate rename
#' @importFrom rvest html_nodes html_table
#' @importFrom tidyr gather
#' @importFrom xml2 read_html
#'
#' @export
mv_get_agency <- function(browser, agency, statistic, pause = 3, add_agency = TRUE){

  # global bindings
  `2000` = year = NULL

  # get agency id
  if (is.numeric(agency) == FALSE){

    # return id
    ag <- mv_agency_id(agency = agency)

    # ensure id is not 'NULL'
    if (is.null(ag) == TRUE){
      stop("Agency name not found. Use the 'agency' object to find valid names, or provide an id number.")
    }

  } else if (is.numeric(agency) == TRUE){
    ag <- agency
  }

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
  } else if (statistic == "Contraband" | statistic == "Contraband Hit Rate" | statistic == "Hit Rate"){
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
  tables <- rvest::html_table(tables, fill = TRUE)
  df <- tables[[1]]

  # get name of last column
  x <- rev(names(df))[1]

  # pivot to long
  out <- tidyr::gather(df, key = "year", value = "value", `2000`:x)

  # tidy
  out <- dplyr::rename(out, cat = "")
  out <- dplyr::mutate(out, cat = ifelse(cat == "Native American", "Native", cat))
  out <- dplyr::mutate(out, cat = ifelse(cat == "Totals", "Total", cat))
  out <- dplyr::arrange(out, cat)
  out <- dplyr::mutate(out, year = as.numeric(year))

  # optionally add agency name
  if (add_agency == TRUE){

    # get name
    name <- mv_agency_name(agency = ag)

    # add name
    out <- dplyr::mutate(out, agency = name)
    out <- dplyr::select(out, agency, dplyr::everything())

  }

  # convert to tibble
  out <- dplyr::as_tibble(out)

  # return output
  return(out)

}

# return agency id number
mv_agency_id <- function(agency){

  # global bindings
  agencies = name = NULL

  # load data
  data <- agencies

  # subset
  data <- dplyr::filter(data, name == agency)

  # return output
  if (nrow(data) == 1){
    out <- data[[1]]
  } else if (nrow(data) == 0){
    out <- NULL
  }


}

# return agency name
mv_agency_name <- function(agency){

  # global bindings
  agencies = id = NULL

  # subset
  data <- dplyr::filter(movsr::agencies, id == agency)

  # return id
  out <- data[[2]]

}

#' Batch Agency Downloads
#'
#' @description Designed to be including in a \code{purrr} call. This wraps
#'     \code{\link{mv_get_agency}}, \code{\link{mv_reformat}}, and \code{\link{mv_filter}}.
#'
#' @usage mv_batch_agency(browser, agency, statistic, format, category, year, pause = 3)
#'
#' @return A tibble with the formatted and subset data.
#'
#' @param browser Name of a browser binding created with \code{RSelenium}
#' @param agency An agency name (for St. Louis City and County agencies) or id number
#'     (for agencies statewide).
#' @param statistic The statistic to download (see \code{\link{mv_get_agency}})
#' @param format Style to reformat raw data (see \code{\link{mv_reformat}})
#' @param category Category to extract (see \code{\link{mv_filter}})
#' @param year Year to extract (see \code{\link{mv_filter}})
#' @param pause Number of seconds to pause while pages load - adjust as
#'     needed depending on internet connection
#'
#' @export
mv_batch_agency <- function(browser, agency, statistic, format, category, year, pause = 3){

  # issues with year argument
  x <- as.character(year)

  # pull data
  data <- mv_get_agency(browser = browser, agency = agency, statistic = statistic, pause = pause)

  # reformat
  if (statistic == "Stops" & format != "count"){
    formatted_data <- mv_reformat(data, statistic = statistic, format = format)
  }

  # subset
  out <- mv_filter(data, category = category, year = x)

  # return output
  return(out)

}
