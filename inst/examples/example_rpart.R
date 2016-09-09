library(d3r)
# from ?rpart
d3_party(
  rpart(Kyphosis ~ Age + Number + Start, data = kyphosis)
)

# if you want the list instead of json
d3_party(
  rpart(Kyphosis ~ Age + Number + Start, data = kyphosis),
  json = FALSE
)

\dontrun{
  #devtools::install_github("timelyportfolio/d3treeR")

  library(d3treeR)

  d3tree2(
    d3_party(
      rpart(Kyphosis ~ Age + Number + Start, data = kyphosis)
    ),
    celltext = "rule",
    valueField = "n"
  )
}
