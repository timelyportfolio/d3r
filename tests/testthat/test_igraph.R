context("igraph")

test_that("d3_igraph works",{
  skip_if_not_installed("igraph")

  library("igraph")

  bull <- graph.famous("Bull")
  data("karate", package="igraphdata")


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
  # with a more complicated network karate
  karate_d3 <- d3_igraph(karate, json=FALSE)
  expect_identical(names(karate_d3), c("nodes","links","attributes"))
  expect_equal(length(V(karate)),nrow(karate_d3$nodes))

  #d3_igraph converts node and edge attributes"
  bull_node_attr <- bull
  V(bull_node_attr)$color <- "blue"

  expect_identical(
    unclass(d3_igraph(bull_node_attr)),
    '{"nodes":[{"color":"blue","id":"0"},{"color":"blue","id":"1"},{"color":"blue","id":"2"},{"color":"blue","id":"3"},{"color":"blue","id":"4"}],"links":[{"source":"0","target":"1"},{"source":"0","target":"2"},{"source":"1","target":"2"},{"source":"1","target":"3"},{"source":"2","target":"4"}],"attributes":{"name":"Bull"}}'
  )

  # add edge attributes
  E(bull_node_attr)$weight <- 1:length(E(bull_node_attr))
  expect_identical(
    unclass(d3_igraph(bull_node_attr)),
    '{"nodes":[{"color":"blue","id":"0"},{"color":"blue","id":"1"},{"color":"blue","id":"2"},{"color":"blue","id":"3"},{"color":"blue","id":"4"}],"links":[{"source":"0","target":"1","weight":1},{"source":"0","target":"2","weight":2},{"source":"1","target":"2","weight":3},{"source":"1","target":"3","weight":4},{"source":"2","target":"4","weight":5}],"attributes":{"name":"Bull"}}'
  )
})

