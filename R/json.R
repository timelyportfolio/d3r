### convenience functions to use arguments to jsonlite::toJSON
###  that play nicely with d3.js

#' Create 'JSON' that 'd3.js' Expects
#'
#' @param x data, usually in the form of \code{data.frame} or \code{list}
#' @param strip \code{logical} to remove outer array.  Use \code{strip=TRUE}
#'           for hierarchies from \code{d3_nest}
#'
#' @return \code{string} of 'JSON' data
#' @export
d3_json <- function(x=NULL, strip=TRUE){
  xj <- jsonlite::toJSON(x, auto_unbox=TRUE, dataframe="rows")
  # remove array so only get first element as object
  if(strip){
    substr(xj,2,nchar(xj)-1)
  } else {
    xj
  }
}
