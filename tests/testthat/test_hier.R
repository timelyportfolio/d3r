context("hierarchy")

hier <- data.frame(
  lvl1 = c(rep("A",4), rep("B",3)),
  lvl2 = c(rep("A.1",2),rep("A.2",2),"B.1","B.2","B.3"),
  lvl3 = c(NA,"A.1.a","A.1.b","A.1.c","B.1.a",NA,"B.1.b"),
  size = c(1,2,3,4,5,6,7),
  stringsAsFactors=FALSE
)

test_that("d3_nest works as json", {

  skip_on_cran()
  skip_on_travis()

  # default as json
  expect_identical(
    unclass(d3_nest(hier, value_cols="size")),
    '{"children":[{"id":"A","children":[{"id":"A.1","children":[{"id":"A.1.a","size":2,"colname":"lvl3"}],"size":1,"colname":"lvl2"},{"id":"A.2","children":[{"id":"A.1.b","size":3,"colname":"lvl3"},{"id":"A.1.c","size":4,"colname":"lvl3"}],"colname":"lvl2"}],"colname":"lvl1"},{"id":"B","children":[{"id":"B.1","children":[{"id":"B.1.a","size":5,"colname":"lvl3"}],"colname":"lvl2"},{"id":"B.2","children":[],"size":6,"colname":"lvl2"},{"id":"B.3","children":[{"id":"B.1.b","size":7,"colname":"lvl3"}],"colname":"lvl2"}],"colname":"lvl1"}],"id":"root"}'
  )

  # json = FALSE
  expect_identical(
    d3_nest(hier, value_cols="size", json=FALSE),
structure(list(children = list(structure(list(id = c("A", "B"
), children = list(structure(list(id = c("A.1", "A.2"), children = list(
structure(list(id = "A.1.a", size = 2, colname = "lvl3"), .Names = c("id",
"size", "colname"), row.names = c(NA, -1L), class = c("tbl_df",
"tbl", "data.frame")), structure(list(id = c("A.1.b", "A.1.c"
), size = c(3, 4), colname = c("lvl3", "lvl3")), .Names = c("id",
"size", "colname"), class = c("tbl_df", "tbl", "data.frame"
), row.names = c(NA, -2L))), size = c(1, NA), colname = c("lvl2",
"lvl2")), .Names = c("id", "children", "size", "colname"), class = c("tbl_df",
"tbl", "data.frame"), row.names = c(NA, -2L)), structure(list(
id = c("B.1", "B.2", "B.3"), children = list(structure(list(
id = "B.1.a", size = 5, colname = "lvl3"), .Names = c("id",
"size", "colname"), class = c("tbl_df", "tbl", "data.frame"
), row.names = c(NA, -1L)), structure(list(id = character(0),
 size = numeric(0), colname = character(0)), .Names = c("id",
"size", "colname"), row.names = integer(0), class = c("tbl_df",
"tbl", "data.frame")), structure(list(id = "B.1.b", size = 7,
colname = "lvl3"), .Names = c("id", "size", "colname"
), class = c("tbl_df", "tbl", "data.frame"), row.names = c(NA,
-1L))), size = c(NA, 6, NA), colname = c("lvl2", "lvl2",
"lvl2")), .Names = c("id", "children", "size", "colname"), class = c("tbl_df",
"tbl", "data.frame"), row.names = c(NA, -3L))), colname = c("lvl1",
"lvl1")), .Names = c("id", "children", "colname"), class = c("tbl_df",
"tbl", "data.frame"), row.names = c(NA, -2L))), id = "root"), .Names = c("children",
"id"), row.names = c(NA, -1L), class = c("tbl_df", "tbl", "data.frame"
))
  )
})
