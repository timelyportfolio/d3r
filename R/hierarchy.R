### Work In Progress function
###  to create nested d3 hierarchy
### will make s3 with some iteration

#' Change Column Name of Children to "id"
#'
#' @param x \code{data.frame} or \code{data.frame} derivative, such
#'         as \code{tibble}
#'
#' @return \code{data.frame}
change_to_id <- function(x, column=1){
  dplyr::mutate(x, children = lapply(
    children,
    function(y) dplyr::rename_(y,id=colnames(y)[column])
  ))
}

#' Convert a \code{data.frame} to a 'd3.js' Hierarchy
#'
#' @param data \code{data.frame} or \code{data.frame} derivative, such
#'                as \code{tibble}
#' @param value_cols \code{character} vector with the names of the
#'                columns to use as data
#' @param root \code{character} name of the root level of the hierarchy
#'
#' @return nested \code{data.frame}
#' @export
#'
#' @example ./inst/examples/example_table.R
#' @example ./inst/examples/example_treemap.R
d3_nest <- function(
  data=NULL,
  value_cols=character(),
  root = "root"
) {
  stopifnot(!is.null(data), inherits(data, "data.frame"))
  nonnest_cols <- dplyr::setdiff(colnames(data),value_cols)

  data_nested <- change_to_id(
    tidyr::nest_(
      data=data,
      nest_cols=c(nonnest_cols[length(nonnest_cols)], value_cols),
      key_col="children"
    )
  )

  for(x in rev(colnames(data_nested)[-ncol(data_nested)])){
    data_nested <- change_to_id(
      tidyr::nest_(
        data_nested,
        nest_cols = c(x,"children"),
        key_col = "children"
      )
    )
  }
  data_nested$id = root
  return(data_nested)
}
