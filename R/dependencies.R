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
    src <- c(href="https://unpkg.com/d3@4.12.0/build/")
  }

  htmltools::htmlDependency(
    name = "d3",
    version = "4.12.0",
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
    src <- c(href="https://unpkg.com/d3@3.5.17/")
  }
  htmltools::htmlDependency(
    name = "d3",
    version = "3.5.17",
    src = src,
    script = "d3.min.js"
  )
}

#' 'd3.js' Dependency for Version 4 Jetpack
#'
#' d3-jetpack is a set of nifty convenience wrappers that speed up
#' your daily work with d3.js. Must be included after \code{d3_dep_v4()}.
#' Learn more by reading \href{https://github.com/gka/d3-jetpack}{d3-jetpack}
#' or by watching this \href{https://www.youtube.com/watch?v=_5ky0AYq_Dg&t=4s}{YouTube}.
#'
#' @param offline \code{logical} to specify whether to use
#'         a local copy of d3.js (\code{TRUE}) or use cdn (\code{FALSE})
#' @return \code{htmltools::htmlDependency}
#' @export
#' @example ./inst/examples/example_d3_jetpack.R
#'
d3_dep_jetpack <- function(offline=TRUE){

  if(offline) {
    src <- c(file=system.file("www/d3/d3-jetpack/dist", package="d3r"))
  } else {
    src <- c(href="https://unpkg.com/d3-jetpack@2.0.9/build/")
  }

htmltools::htmlDependency(
    name = "d3-jetpack",
    version = "2.0.9",
    src = src,
    script = "d3-jetpack.js"
  )
}
