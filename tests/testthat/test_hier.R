context("hierarchy")

hier <- data.frame(
  lvl1 = c(rep("A",4), rep("B",3)),
  lvl2 = c(rep("A.1",2),rep("A.2",2),"B.1","B.2","B.3"),
  lvl3 = c(NA,"A.1.a","A.1.b","A.1.c","B.1.a",NA,"B.1.b"),
  size = c(1,2,3,4,5,6,7),
  stringsAsFactors=FALSE
)

test_that("d3_nest works as json", {
  # default as json
  expect_identical(
    unclass(d3_nest(hier, value_cols="size")),
    '{"children":[{"id":"A","children":[{"id":"A.1","children":[{"id":"A.1.a","size":"2"}],"size":"1"},{"id":"A.2","children":[{"id":"A.1.b","size":"3"},{"id":"A.1.c","size":"4"}]}]},{"id":"B","children":[{"id":"B.1","children":[{"id":"B.1.a","size":"5"}]},{"id":"B.2","children":[],"size":"6"},{"id":"B.3","children":[{"id":"B.1.b","size":"7"}]}]}],"id":"root"}'
  )

  # json = FALSE
  expect_identical(
    d3_nest(hier, value_cols="size", json=FALSE),
    structure(
      list(
        children = list(
          structure(
            list(
              id = c("A", "B"),
              children = list(
                structure(
                  list(
                    id = c("A.1", "A.2"),
                    children = list(
                      structure(
                        list(
                          id = "A.1.a", size = "2"
                        ),
                        .Names = c("id", "size"),
                        row.names = c(NA, -1L),
                        class = c("tbl_df", "tbl", "data.frame")
                      ),
                      structure(
                        list(
                          id = c("A.1.b", "A.1.c"),
                          size = c("3", "4")
                        ),
                        row.names = c(NA, -2L),
                        class = c("tbl_df", "tbl", "data.frame"),
                        .Names = c("id", "size")
                      )
                    ),
                    size = c("1",NA)
                  ),
                  row.names = c(NA, -2L),
                  class = c("tbl_df", "tbl", "data.frame"),
                  .Names = c("id", "children", "size")
                ),
                structure(
                  list(
                    id = c("B.1","B.2", "B.3"),
                    children = list(
                      structure(
                        list(id = "B.1.a", size = "5"),
                        row.names = c(NA, -1L),
                        class = c("tbl_df", "tbl", "data.frame"),
                        .Names = c("id", "size")
                      ),
                      structure(
                        list(id = character(0), size = character(0)),
                        .Names = c("id","size"),
                        row.names = integer(0),
                        class = c("tbl_df", "tbl", "data.frame")
                      ),
                      structure(
                        list(id = "B.1.b", size = "7"),
                        row.names = c(NA,-1L),
                        class = c("tbl_df", "tbl", "data.frame"),
                        .Names = c("id","size")
                      )
                    ),
                    size = c(NA, "6", NA)
                  ),
                  row.names = c(NA, -3L),
                  class = c("tbl_df", "tbl", "data.frame"),
                  .Names = c("id", "children", "size")
                )
              )
            ),
            row.names = c(NA,-2L),
            class = c("tbl_df", "data.frame"),
            .Names = c("id", "children")
          )
        ),
        id = "root"
      ),
      .Names = c("children", "id"),
      row.names = c(NA, -1L),
      class = c("tbl_df", "data.frame")
    )
  )
})
