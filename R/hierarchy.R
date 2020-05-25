#' Change Column Name in Children to "name"
#'
#' @param x \code{data.frame} or \code{data.frame} derivative, such
#'         as \code{tibble}
#' @param column column to convert
#'
#' @return \code{data.frame}
change_to_name <- function(x, column=1){
  child_list <- lapply(
    x$children,
    function(y) {
      y <- dplyr::mutate(y, "colname" = colnames(y)[column])
      dplyr::rename(y,"name" = colnames(y)[column])
    }
  )
  dplyr::mutate(x, children = child_list)
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
  na_child_loc <- which(is.na(x$children[[1]]$name))

  # promote all non-d3r columns to top level
  if(length(na_child_loc)){
    na_child <- x$children[[1]][na_child_loc,]
    x <- dplyr::bind_cols(
      x,
      na_child[1,setdiff(colnames(na_child),c("name","children","colname"))]
    )

    # eliminate na child
    x$children[[1]] <- x$children[[1]][-na_child_loc,]
    x
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
  #by_row now deprecated
  #purrr::by_row(x, promote_na_one)$.out
  lapply(
    seq_len(nrow(x)),
    function(row){promote_na_one(x[row,])}
  )
}

#' Convert a \code{data.frame} to a 'd3.js' Hierarchy
#'
#' @param data \code{data.frame} or \code{data.frame} derivative, such
#'                as \code{tibble}
#' @param value_cols \code{character} vector with the names of the
#'                columns to use as data
#' @param root \code{character} name of the root level of the hierarchy
#' @param json \code{logical} to return as \code{JSON}
#'
#' @return nested \code{data.frame}
#' @export
#'
#' @example ./inst/examples/example_table.R
#' @example ./inst/examples/example_treemap.R
d3_nest <- function(
  data=NULL,
  value_cols=character(),
  root = "root",
  json = TRUE
) {
  stopifnot(!is.null(data), inherits(data, "data.frame"))
  nonnest_cols <- dplyr::setdiff(colnames(data),value_cols)

  # looks like new tidyr requires tibble to nest correctly
  data <- dplyr::as_tibble(data)

  # convert factor to character
  data <- dplyr::mutate_if(data, is.factor, as.character)

  # syntax changed in tidyr > 0.8.3
  if(utils::packageVersion("tidyr") > "0.8.3") {
    data_nested <- dplyr::bind_rows(promote_na(
      change_to_name(
        tidyr::nest(
          .data=data,
          children = dplyr::one_of(c(nonnest_cols[length(nonnest_cols)], value_cols))
        )
      )
    ))
  } else {
    data_nested <- dplyr::bind_rows(promote_na(
      change_to_name(
        tidyr::nest(
          data=data,
          dplyr::one_of(c(nonnest_cols[length(nonnest_cols)], value_cols)),
          .key="children"
        )
      )
    ))
  }

  for(x in rev(
    colnames(data_nested)[
      -which(colnames(data_nested) %in% c("children","colname",value_cols))
    ]
  )){
    if(utils::packageVersion("tidyr") > "0.8.3") {
      data_nested <- dplyr::bind_rows(promote_na(
        change_to_name(
          tidyr::nest(
            .data = data_nested,
            children = dplyr::one_of(colnames(data_nested)[colnames(data_nested) %in% c(x,"children",value_cols)])
          )
        )
      ))
    } else {
      data_nested <- dplyr::bind_rows(promote_na(
        change_to_name(
          tidyr::nest(
            data_nested,
            dplyr::one_of(colnames(data_nested)[colnames(data_nested) %in% c(x,"children",value_cols)]),
            .key = "children"
          )
        )
      ))
    }
  }
  data_nested$name = root
  if(json){
    d3_json(data_nested,strip=TRUE)
  } else {
    data_nested
  }
}
