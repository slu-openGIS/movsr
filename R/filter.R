#' Subset Data
#'
#' @description Subset data to extract a single category and time point for cross
#'     sectional comparisons between departments.
#'
#' @usage mv_filter(.data, category, year)
#'
#' @return A tibble containing the subset data.
#'
#' @param .data A tbl created with \code{\link{mv_get_agency}}
#' @param category Category to extract
#' @param year Year to extract
#'
#' @export
mv_filter <- function(.data, category, year){

  # subset
  .data <- dplyr::filter(.data, cat == category & year == year)

  # return output
  return(.data)

}
