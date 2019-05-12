#' Reformat
#'
#' @export
mv_reformat <- function(.data, statistic, format, output = "long"){

  if (statistic == "Stops" | statistic == "Stop Rate"){
    out <- mv_reformat_stops(.data, format = format)
  }

  if (output == "long"){
    out <- tidyr::gather(out, key = cat, value = value, Asian:White)
  }

  # return output
  return(out)

}

# Reformat Stop Data
mv_reformat_stops <- function(.data, format){

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
