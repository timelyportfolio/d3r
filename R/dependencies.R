#' 'd3.js' Dependency for Version 4
#'
#' @param offline \code{logical} to specify whether to use
#'         a local copy of d3.js (\code{TRUE}) or use cdn (\code{FALSE})
#' @return \code{htmltools::htmlDependency}
#' @export
#' @examples
#' library(d3r)
#' library(htmltools)
#'
#' attachDependencies(tagList(),d3_dep_v4())
d3_dep_v4 <- function(offline=TRUE){
  if(offline) {
    src = c(file=system.file("www/d3/v4/dist", package="d3r"))
  } else {
    src <- c(href="https://cdnjs.cloudflare.com/ajax/libs/d3/4.7.0/")
  }

  htmltools::htmlDependency(
    name = "d3",
    version = "4.7.0",
    src = src,
    script = "d3.min.js"
  )
}

#' 'd3.js' Dependency for Version 3
#'
#' @param offline \code{logical} to specify whether to use
#'         a local copy of d3.js (\code{TRUE}) or use cdn (\code{FALSE})
#' @return \code{htmltools::htmlDependency}
#' @export
#' @examples
#' library(d3r)
#' library(htmltools)
#'
#' attachDependencies(tagList(),d3_dep_v3())
d3_dep_v3 <- function(offline=TRUE){
  if(offline) {
    src = c(file=system.file("www/d3/v3/dist", package="d3r"))
  } else {
    src <- c(href="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.17/")
  }
  htmltools::htmlDependency(
    name = "d3",
    version = "3.5.17",
    src = src,
    script = "d3.min.js"
  )
}
