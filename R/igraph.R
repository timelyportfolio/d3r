#' Convert 'igraph' to 'd3.js'
#'
#' @param igrf \code{igraph}
#' @param json \code{logical} to return as \code{JSON}
#'
#' @return \code{list}
#' @export
#'
#' @example ./inst/examples/example_igraph.R

d3_igraph <- function(igrf = NULL, json=TRUE) {
  stopifnot(!is.null(igrf), inherits(igrf,"igraph"),requireNamespace("igraph"))
  network <- igraph::as_data_frame(
    igrf,
    what = "both"
  )

  nodes <- network$vertices

  # use rownames as id
  if(!("id" %in% colnames(nodes))){
    nodes <- dplyr::mutate(nodes, id=rownames(network$vertices))
  }
  links <- dplyr::rename_(
    network$edges,
    "source" = "from",
    "target" = "to"
  )

  # convert factor to character
  nodes <- dplyr::mutate_if(nodes, is.factor, as.character)
  links <- dplyr::mutate_if(links, is.factor, as.character)

  # not necessary but if ids are numeric use zero-based indexing
  #  and convert
  suppressWarnings(are_ids_numeric <- !any(is.na(as.numeric(nodes$id))))
  if(are_ids_numeric){
    nodes$id <- as.character(as.numeric(nodes$id) - 1)
    links$source <- as.character(as.numeric(links$source)-1)
    links$target <- as.character(as.numeric(links$target)-1)
  }

  if(json){
    d3_json(list(nodes=nodes,links=links),strip=FALSE)
  } else {
    list(nodes=nodes,links=links)
  }
}
