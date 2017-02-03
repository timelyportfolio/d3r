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
    jsonlite::fromJSON(d3_igraph(bull_node_attr), simplifyVector=FALSE),
    list(
      nodes = list(
        list(color = "blue", id = "0"),
        list(color = "blue", id = "1"),
        list(color = "blue", id = "2"),
        list(color = "blue", id = "3"),
        list(color = "blue", id = "4")
      ),
      links = list(
        list(source = "0", target = "1", weight = 1),
        list(source = "0", target = "2", weight = 2),
        list(source = "1", target = "2", weight = 3),
        list(source = "1", target = "3", weight = 4),
        list(source = "2", target = "4", weight = 5)
      ),
      "attributes" = list(name = "Bull")
    )
  )
})

