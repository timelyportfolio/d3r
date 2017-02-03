context("igraph")

test_that("d3_igraph works",{
  skip_if_not_installed("igraph")
  skip_if_not_installed("jsonlite")
  library("igraph")

  bull <- graph.famous("Bull")

  # default as json
  expect_identical(
    unclass(d3_igraph(bull)),
    '{"nodes":[{"id":"0"},{"id":"1"},{"id":"2"},{"id":"3"},{"id":"4"}],"links":[{"source":"0","target":"1"},{"source":"0","target":"2"},{"source":"1","target":"2"},{"source":"1","target":"3"},{"source":"2","target":"4"}],"attributes":{"name":"Bull"}}'
  )
  # json=FALSE so list
  expect_identical(
    unclass(jsonlite::toJSON(
      d3_igraph(bull, json=FALSE),
      dataframe="rows",
      auto_unbox=TRUE
    )),
    '{"nodes":[{"id":"0"},{"id":"1"},{"id":"2"},{"id":"3"},{"id":"4"}],"links":[{"source":"0","target":"1"},{"source":"0","target":"2"},{"source":"1","target":"2"},{"source":"1","target":"3"},{"source":"2","target":"4"}],"attributes":{"name":"Bull"}}'
  )

  #d3_igraph converts node and edge attributes"
  bull_node_attr <- bull
  V(bull_node_attr)$color <- "blue"

  expect_identical(
    unclass(d3_igraph(bull_node_attr)),
    '{"nodes":[{"color":"blue","id":"0"},{"color":"blue","id":"1"},{"color":"blue","id":"2"},{"color":"blue","id":"3"},{"color":"blue","id":"4"}],"links":[{"source":"0","target":"1"},{"source":"0","target":"2"},{"source":"1","target":"2"},{"source":"1","target":"3"},{"source":"2","target":"4"}],"attributes":{"name":"Bull"}}'
  )

  # add edge attributes
  E(bull_node_attr)$weight <- 1:length(E(bull_node_attr))
  expect_equal(
    d3_igraph(bull_node_attr, json=FALSE),
    list(
      nodes = data.frame(
        "color" = rep("blue", 5),
        "id" = as.character(0:4),
        stringsAsFactors = FALSE
      ),
      links = data.frame(
        "source" = as.character(c(0,0,1,1,2)),
        "target" = as.character(c(1,2,2,3,4)),
        "weight" = 1:5,
        stringsAsFactors = FALSE
      ),
      "attributes" = list(name = "Bull")
    )
  )
})

