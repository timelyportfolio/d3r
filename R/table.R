#' @keywords internal
links_get <- function(tB, vars=NULL, agg="Freq") {
  if(length(vars) == 1){
    return(data.frame())
  }

  #assume vars in order of source, target
  vars_df <- sapply(1:(length(vars)-1),function(v){c(vars[v],vars[v+1])})

  vars_df <- data.frame(
    t(vars_df),
    stringsAsFactors = FALSE
  )
  vars_df <-  apply(
    vars_df,
    MARGIN=1,
    function(c){
      paste0(as.vector(c),collapse="+")
    }
  )

  vars_df <- do.call(
    rbind,
    lapply(
      vars_df,
      function(f){
        structure(
          data.frame(stats::xtabs(paste0(agg,"~",f),tB)),
          names = c("source","target","value")
        )
      }
    )
  )

  colnames(vars_df) <- c("source","target","value")
  vars_df
}

#' @keywords internal
links_transform <- function(links=NULL, nodes=NULL, vars=NULL, agg=NULL, tB=NULL) {
  if (nrow(links) > 0) {

    links <- lapply(
      1:ncol(links),
      function(x){
        if (is.factor(links[,x])){
          as.character(links[,x])
        } else links[,x]
      }
    )

    links <- data.frame(links, stringsAsFactors = F)
    colnames(links) <- c("source","target","value")
  }

  links_tail <- data.frame(
    utils::tail(nodes,1),
    stats::xtabs(paste0(agg,"~",vars[1]),tB)
  )
  colnames(links_tail) <- c("source","target","value")

  links <- rbind(
    links,
    links_tail
  )


  links[,c(1,2)] <- lapply(
    links[,c(1,2)],
    function(x){
      match(as.character(x),nodes)-1
    }
  )

  links
}


#' Converts Table to 'd3' Nodes and Links
#'
#' @param tB \code{table} to convert
#' @param vars \code{character} vector of column names
#' @param agg \code{character} column name of aggregated value
#'
#' @return \code{list} of two \code{data.frames} - one for nodes and
#'           one for links of the network.  This structure is helpful
#'           when working with \code{networkD3} and \code{visNetwork}.
#' @examples
#' library(d3r)
#' d3_table(Titanic, c("Class","Sex"))
#'
#' @export
d3_table <- function( tB = NULL, vars = NULL, agg = "Freq" ) {
  stopifnot(!is.null(tB), inherits(tB, "table"))

  if(is.null(vars)){
    vars = names(dimnames(tB))
  }

  nodes <- unique(
    unlist(
      unname(
        dimnames(tB)[vars]
      )
    )
  )

  #  add name of table as root in nodes
  nodes[length(nodes)+1]= as.character(substitute(tB))


  links <- links_get(tB = tB, vars = vars, agg = agg)
  links_transformed <- links_transform(links, nodes, vars, agg, tB)


  # try to get size for nodes
  nodes_df <- data.frame(name=as.character(nodes),stringsAsFactors = F)

  nodes_df <- lapply(
    vars,
    function(v){
      stats::xtabs(paste0(agg,"~",v),tB)
    }
  )

  nodes_df <- data.frame(
    name = names(unlist(nodes_df)),
    value = as.vector(unlist(nodes_df)),
    stringsAsFactors = F
  )

  nodes_df <- rbind(
    nodes_df,
    data.frame(
      name = utils::tail(nodes,1),
      value = sum(tB)
    )
  )
  # not sure if this is necessary any more
  #  legacy of previous code
  rownames(nodes_df) <- sort(as.numeric(rownames(nodes_df)))

  return(
    list(
      nodes = nodes_df,
      links =  links_transformed
    )
  )
}
