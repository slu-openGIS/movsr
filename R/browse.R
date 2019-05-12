#' Open Browser
#'
#' @param browser Browser type to pass to \code{RSelenium::rdDrive}
#' @param chromever Chrome version to pass to \code{RSelenium::rdDrive}
#'
#' @importFrom RSelenium rsDriver
#'
#' @export
mv_browse <- function(browser = "chrome", chromever){

  rD <- RSelenium::rsDriver(browser= browser, chromever= chromever)
  out <- rD[["client"]]

}
