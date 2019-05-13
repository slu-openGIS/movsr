#' Reformat Data
#'
#' @description Converts raw counts to either percentage or proportion formats.
#'
#' @usage mv_reformat(.data, statistic, format, output = "long")
#'
#' @details The statistics that can be reformatted are as follows:
#'
#' \describe{
#'     \item{\code{"Stops"} or \code{"Stop Rate"}}{}
#'     \item{\code{"Searches"} or \code{"Search Rate"}}{}
#'     \item{\code{"Arrests"} or \code{"Arrest Rate"}}{}
#'     \item{\code{"Contraband"}, \code{"Hit Rate"}, or \code{"Contraband Hit Rate"}}{}
#' }
#'
#' @return A tibble with the reformatted data
#'
#' @param .data A tbl created with \code{\link{mv_get_agency}}
#' @param statistic The statistic to reformat
#' @param format Either \code{"pct"} for percentages or \code{"prop"} for propotions.
#' @param output Either \code{"long"} or \code{"wide"}
#'
#' @export
mv_reformat <- function(.data, statistic, format, output = "long"){

  # global bindings
  value = Asian = White = NULL

  # reformat statistic
  if (statistic == "Stops" | statistic == "Stop Rate"){
    out <- mv_reformat_stops(.data, format = format)
  }

  # convert back to long
  if (output == "long"){
    out <- tidyr::gather(out, key = cat, value = value, Asian:White)
  }

  # return output
  return(out)

}

# Reformat Stop Data
mv_reformat_stops <- function(.data, format){

  # global bindings
  Asian = Black = Hispanic = Native = Other = Total = White = value = NULL

  # convert to wide
  .data <- tidyr::spread(.data, key = cat, value = value)

  # format
  if (format == "pct"){
    .data <- dplyr::mutate(.data,
                         Asian = Asian/Total*100,
                         Black = Black/Total*100,
                         Hispanic = Hispanic/Total*100,
                         Native = Native/Total*100,
                         Other = Other/Total*100,
                         White = White/Total*100)
  } else if (format == "prop"){
    .data <- dplyr::mutate(.data,
                         Asian = Asian/Total,
                         Black = Black/Total,
                         Hispanic = Hispanic/Total,
                         Native = Native/Total,
                         Other = Other/Total,
                         White = White/Total)
  }

  # drop total
  .data <- dplyr::select(.data, -Total)

}
