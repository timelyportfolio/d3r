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
    src <- c(href="https://unpkg.com/d3@4.9.1/build/")
  }

  htmltools::htmlDependency(
    name = "d3",
    version = "4.9.1",
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
#' d3-jetpack is a set of nifty convenience wrappers that speed up your daily work with d3.js. Must be included after `d3_dep_v4()`
#' Learn more by reading https://github.com/gka/d3-jetpack or by watching https://www.youtube.com/watch?v=_5ky0AYq_Dg&t=4s
#'
#' @param offline \code{logical} to specify whether to use
#'         a local copy of d3.js (\code{TRUE}) or use cdn (\code{FALSE})
#' @return \code{htmltools::htmlDependency}
#' @export
#' @examples
#'
#'
#' library(d3r)
#' library(htmltools)
#'
#' t <- tagList(tags$script(HTML(sprintf(
#' "
#' var x = 5;
#'
#' var svg = d3.select('body')
#'     .append('svg');
#'
#' svg.append('rect')
#'     .at({
  #'         x: 100,
  #'         y: 100,
  #'         width: 100,
  #'         height: 100
  #'     })
#'     .st({
  #'         fill: 'blue',
  #'         stroke: 'purple'
  #'     });
  #' "
#' ))), d3_dep_v4(), d3_dep_jetpack())
#' browsable(t)
#'
#'
#'
#' t <- tagList(tags$script(HTML(sprintf(
#'  "
#'  var svg = d3.select('body')
#'      .append('svg');
#'
#'  test_data = [{x: 250, y: 250}, {x: 300, y: 300}, {x: 300, y: 100}];
#'
#'  svg.appendMany(test_data, 'circle')
#'      .at({
#'          cx: function(d){return d.x},
#'          cy: function(d){return d.y},
#'          r: 50
#'      })
#'      .st({
#'          fill: 'purple',
#'          stroke: 'blue'
#'      });
#'  "
#' ))), d3_dep_v4(), d3_dep_jetpack())
#' browsable(t)
#'
d3_dep_jetpack <- function(offline=TRUE){

  if(offline) {
    src <- c(file=system.file("www/d3/d3-jetpack/dist", package="d3r"))
  } else {
    src <- c(href="https://unpkg.com/d3-jetpack@2.0.7/build/")
  }

htmltools::htmlDependency(
    name = "d3-jetpack",
    version = "2.0.7",
    src = src,
    script = "d3-jetpack.js"
  )
}
