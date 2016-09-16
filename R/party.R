# convert rpart / partykit to d3
# some help from http://stackoverflow.com/questions/34196611/converting-rpart-output-into-json-format-in-r/38469619?noredirect=1#comment65954307_38469619
# method in sankeytree

#' Convert partykit to d3.js hierarchy
#'
#' This thing is not even close to being done, so please help
#' with ideas and contributions.
#'
#' @param tree \code{partykit} object to be converted
#' @param json \code{logical} to return \code{list} or \code{json}
#'
#' @return \code{list} or \code{json} depending on \code{json} arg
#'
#' @example ./inst/examples/example_rpart.R
#'
#'
#' @export
d3_party = function (tree=NULL, json=TRUE) {

  stopifnot(!is.null(tree), requireNamespace("partykit"))

  # Checking the decision tree object
  if(!inherits(tree, c("constparty","party"))){
    tree_pk <- partykit::as.party(tree)
  } else {
    tree_pk <- tree
  }

  data <- rapply(tree_pk$node, unclass, how="list")

  #fill in information at the root level for now
  #that might be nice to provide to our interactive graph
  data$info <- rapply(
    unclass(tree_pk)[-1]
    ,function(l){
      l = unclass(l)
      if( class(l) %in% c("terms","formula","call")) {
        l = paste0(as.character(l)[-1],collapse=as.character(l)[1])
      }
      attributes(l) <- NULL
      return(l)
    }
    ,how="replace"
  )

  #get all the other meta data we need and merge it in to the list

  ## changed pattern from [1-9] to [0-9] because we were missing node 10
  tree_text <- invisible( utils::capture.output( print(tree_pk) ) )
  tree_text <- tree_text[grep( x = tree_text, pattern = "(\\[)([0-9]*)(\\])")]
  tree_text <- strsplit( tree_text, "[\\[\\|\\]]" , perl = T)
  tree_text <- lapply(
    seq.int(1,length(tree_text)),
    function(i){
      x <- tree_text[[i]]
      tail_data <- utils::tail(x,2)
      data.frame(
        "id" = as.numeric(tail_data[1])
        , description = tail_data[2]
        , stringsAsFactors = F
      )
    }
  )
  tree_text <- do.call(rbind, tree_text)


  # terminal nodes have descriptive stats in their names, so I stripped these out
  # so the final plot wouldn't have duplicate data
  tree_text$description <- sapply(strsplit(tree_text[,2], ":"), "[", 1)

  # add rules
  tree_text$rule <- sapply(partykit::nodeids(tree_pk),function(n){partykit:::.list.rules.party(tree_pk,n)})

  # if frame data (rpart, maybe others) then add
  # binding the node names from rpk with more of the relevant meta data from rp
  # i don't think that partykit imports this automatically for the inner nodes, so i did it manually
  if("frame" %in% names(tree)){
    tree_text <- cbind(tree_text, tree$frame)
    # rounding the mean DV value
    tree_text$yval <- round(tree_text$yval, 2)
  }

  # now try to add size / count information
  #  rpart easy and will have n but other more difficult
  if(
    "fitted" %in% names(unclass(tree_pk)) &&
    !("(weights)" %in% names(tree_pk$fitted))
  ){
    tree_pk$fitted$weights <- 1
  }

  counts <- data.frame(
    xtabs(`(weights)`~`(fitted)`+`(response)`,tree_pk$fitted),
    stringsAsFactors=FALSE
  )
  colnames(counts) <- c("fitted", "response", "freq")
  counts <- dplyr::mutate(counts, fitted = as.numeric(as.character(fitted)))
  counts <- tidyr::nest(counts, response, freq, .key="size")
  # would use dplyr join here, but nested data.frame
  #   flattened on join;  this does not happen with nested
  #   tibble, but dont' want to add another depedency


  # do the merge of tree_text with data by
  # walking the tree and joining by id
  join_data <- function(l){
    l <- unclass(l)
    l <- utils::modifyList(l,subset(tree_text,`id`==l$id))
    l$size <- subset(counts, `fitted`==l$id)
    l
  }

  merge_data <- function(l){
    l <- join_data(l)
    if("kids" %in% names(l) && length(l$kids)>0){
      lapply(
        1:length(l$kids),
        function(n){
          l$kids[[n]] <<- merge_data(l$kids[[n]])
        }
      )
    } else if("kids" %in% names(l) && length(l$kids)==0) {
      l$kids <- NULL
    }
    l
  }

  hier <- rapply(merge_data(data), unclass, how="list")

  hier <- recurse(hier, rename_children)

  if(json){
    d3_json(hier, strip=FALSE)
  } else {
    hier
  }
}

#' @keywords internal
rename_children <- function(l, old_name="kids", new_name="children") {
  if(length(names(l))>0) {
    names(l)[which(names(l)==old_name)] <- new_name
  }
  l
}

#' @keywords internal
recurse <- function(l, func, ...) {
  l <- func(l, ...)
  if(is.list(l) && length(l)>0){
    lapply(
      l,
      function(ll){
        recurse(ll, func, ...)
      }
    )
  } else {
    l
  }
}
