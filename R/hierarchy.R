### Work In Progress function
###  to create nested d3 hierarchy
### will make s3 with some iteration

#' Change Column Name of Children to "id"
#'
#' @param x \code{data.frame} or \code{data.frame} derivative, such
#'         as \code{tibble}
#' @param column column to convert
#'
#' @return \code{data.frame}
change_to_id <- function(x, column=1){
  dplyr::mutate(x, children = lapply(
    quote(children),
    function(y) dplyr::rename_(y,id=colnames(y)[column])
  ))
}


#' Promote NA to Top Level
#'
#' @param x \code{data.frame}
#'
#' @return \code{data.frame}
promote_na_one <- function(x){
  # find children that are na
  # expect this to only happen once, so only take first na
  #   to define values
  na_child <- dplyr::filter(x$children[[1]], is.na(id))[1,]
  na_child_loc <- which(is.na(x$children[[1]]$id))

  # promote all non-id columns to top level
  if(length(na_child_loc)){
    x <- dplyr::bind_cols(
      x,
      dplyr::select(na_child,-(match(colnames(na_child),c("id","children"))))
    )

    # eliminate na child
    dplyr::mutate(x,children=list(children[[1]][-na_child_loc,]))
  } else {
    x
  }
}


#' Apply `promote_na` to All Rows
#'
#' @param x \code{data.frame}
#'
#' @return \code{data.frame}
promote_na <- function(x){
  purrr:::by_row(x, promote_na_one)$.out
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

  # convert factor to character
  data <- dplyr::mutate_if(data, is.factor, as.character)

  data_nested <- dplyr::bind_rows(promote_na(
    change_to_id(
      tidyr::nest_(
        data=data,
        nest_cols=c(nonnest_cols[length(nonnest_cols)], value_cols),
        key_col="children"
      )
    )
  ))

  for(x in rev(
    colnames(data_nested)[
      -which(colnames(data_nested) %in% c("children",value_cols))
    ]
  )){
    data_nested <- dplyr::bind_rows(promote_na(
      change_to_id(
        tidyr::nest_(
          data_nested,
          nest_cols = colnames(data_nested)[colnames(data_nested) %in% c(x,"children",value_cols)],
          key_col = "children"
        )
      )
    ))
  }
  data_nested$id = root
  return(data_nested)
}
