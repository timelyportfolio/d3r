#' 'd3.js' Dependency for Version 4
#'
#' @return \code{htmltools::htmlDependency}
#' @export
#' @examples
#' library(d3r)
#' library(htmltools)
#'
#' attachDependencies(tagList(),d3_dep_v4())
d3_dep_v4 <- function(){
  htmltools::htmlDependency(
    name = "d3",
    version = "4.2.3",
    src = c(
      file = system.file("www/d3/v4/dist", package="d3r"),
      href = "https://d3js.org/"
    ),
    script = "d3.v4.min.js"
  )
}

#' 'd3.js' Dependency for Version 3
#'
#' @return \code{htmltools::htmlDependency}
#' @export
#' @examples
#' library(d3r)
#' library(htmltools)
#'
#' attachDependencies(tagList(),d3_dep_v3())
d3_dep_v3 <- function(){
  htmltools::htmlDependency(
    name = "d3",
    version = "3.5.17",
    src = c(
      file = system.file("www/d3/v3/dist", package="d3r"),
      href = "https://d3js.org/"
    ),
    script = "d3.v3.min.js"
  )
}
