\dontrun{

  library(d3r)
  # from ?rpart
  data("kyphosis", package="rpart")
  d3_party(
    rpart::rpart(Kyphosis ~ Age + Number + Start, data = kyphosis)
  )

  # if you want the list instead of json
  d3_party(
    rpart::rpart(Kyphosis ~ Age + Number + Start, data = kyphosis),
    json = FALSE
  )

  # with ctree instead of rpart
  #  using example from ?ctree
  d3_party(partykit::ctree(Species ~ .,data = iris))


  #devtools::install_github("timelyportfolio/d3treeR")

  library(d3treeR)

  d3tree2(
    d3_party(
      rpart::rpart(Kyphosis ~ Age + Number + Start, data = kyphosis)
    ),
    celltext = "rule",
    valueField = "n"
  )

}
