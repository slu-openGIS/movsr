#' Create Ticket Shed
#'
#' @description Creates an object with all census tracts whose centroids fall
#'     within the specified radius of the primary feature. This primary feature
#'     must be the first feature listed in the input data object. Euclidean distance
#'     is used for this calculation. Once the relevant tracts are selected, a weight
#'     is calculated for each using inverse distance weighting. The power argument
#'     should be used to control this calculation process.
#'
#' @param .data A sf object
#' @param primary \code{GEOID} value of the municipality that the ticket shed is for
#' @param radius Euclidean distance in miles from the primary feature's centroid
#'     that defines the size of the ticket shed.
#' @param power Power value for inverse distance weighting
#'
#' @return An \code{sf} object with the tracts contained within the ticket shed as
#'     well as the distance in kilometers from the primary feature's centriod
#'     and the weight for each tract.
#'
#' @importFrom dplyr filter left_join mutate select
#' @importFrom measurements conv_unit
#' @importFrom sf st_as_sf st_crs st_transform
#' @importFrom sp coordinates
#' @importFrom spdep nbdists dnearneigh
#' @importFrom tibble rowid_to_column
#'
#' @export
mv_create_shed <- function(.data, primary, radius, power = 1){

  # verify primary feature is first observation
  if (.data$GEOID[[1]] != primary){
    stop("Primary feature must be the first observation in '.data'. Re-order the data to meet this condition.")
  }

  # store current projection
  proj <- sf::st_crs(.data)

  # verify projection
  if (proj$epsg != 26915){
    .data <- sf::st_transform(.data, crs = 26915)
  }

  # convert to sp object
  if ("sf" %in% class(.data)){
    .data <- as(data, 'Spatial')
  }

  # define radius in kilometers
  radiusKM <- measurements::conv_unit(radius, from = "mi", to = "m")

  # identify all tracts within perscribed radius
  neighbors <- spdep::dnearneigh(sp::coordinates(.data), d1 = 0, d2 = radiusKM)

  # calculate distance between neighbors
  dists <- spdep::nbdists(neighbors, sp::coordinates(.data))

  # convert meters to kilometers in dists
  dists <- lapply(dists, function(x) x/1000)

  # calculate inverse distance
  idw <- lapply(dists, function(x) 1/(x^power))

  # convert to data frame
  nb <- data.frame(
    ids = neighbors[[1]],
    dists = dists[[1]],
    idw = idw[[1]],
    stringsAsFactors = FALSE
  )

  # convert data back to sf
  .data <- sf::st_as_sf(.data)

  # add row numbers to original data
  .data <- tibble::rowid_to_column(.data, var = "ids")

  # join and prepare object to be returned
  out <- dplyr::left_join(.data, nb, by = "ids")
  out <- dplyr::filter(out, ids == 1 | is.na(dists) == FALSE)
  out <- dplyr::mutate(out, idw = ifelse(ids == 1, 0, idw))
  out <- dplyr::select(out, -ids)

  # return output
  return(out)

}
