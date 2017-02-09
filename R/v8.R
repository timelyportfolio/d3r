#' Create V8 Context with D3
#'
#' @param ... arguments passed to \code{v8()}
#'
#' @return \code{v8} context with d3.js sourced
#' @export

d3_v8 <- function(...) {
  if(!requireNamespace("V8")) {
    stop("The V8 package must be installed for this function.  Please install.packages('V8').")
  }

  d3dep <- d3_dep_v4()

  ctx <- v8(...)
  ctx$source(
    file.path(
      d3dep$src,
      d3dep$script
    )
  )
  return(ctx)
}
