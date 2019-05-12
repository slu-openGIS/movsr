#' Subset Data
#'
#' @param .data A tbl
#' @param category
#'
#' @export
mv_filter <- function(.data, category, date){

  # subset
  .data <- dplyr::filter(.data, cat == category & year == date)

  # return output
  return(.data)

}
