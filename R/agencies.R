#' St. Louis City and County Police Departments
#'
#' @description A tibble containing agency names, id numbers,
#'     and the county that they serve.
#'
#' @docType data
#'
#' @usage data(agencies)
#'
#' @format A data frame with 79 rows and 5 variables:
#' \describe{
#'   \item{id}{agency id number}
#'   \item{name}{agency name}
#'   \item{valid}{did agency make any traffic stops in 2017?}
#'   \item{countyfp}{county FIPS code}
#'   \item{namelsad}{county name}
#'   }
#'
#' @source Missouri Attorney General's Office
#'
#' @examples
#' str(agencies)
#' head(agencies)
#'
"agencies"
