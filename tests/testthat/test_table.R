context("table")

test_that("d3_table works with 1 var", {
  expect_identical(
    d3_table(UCBAdmissions,"Admit"),
    list(
      nodes=structure(
        data.frame(
          name = c("Admitted","Rejected","UCBAdmissions"),
          weight = c(1755,2771,4526),
          stringsAsFactors = FALSE
        ),
        row.names = as.character(1:3)
      ),
      links = data.frame(
        source = c(2,2),
        target = c(0,1),
        weight = c(1755, 2771),
        stringsAsFactors = FALSE
      )
    )
  )
})

test_that("d3_table works with > 1 var", {
  expect_identical(
    d3_table(Titanic, c("Age","Sex")),
    list(
      nodes = structure(
        data.frame(
          name = c("Child","Adult","Male","Female","Titanic"),
          weight = c(109,2092,1731,470,2201),
          stringsAsFactors = FALSE
        ),
        row.names = as.character(seq_len(5))
      ),
      links = data.frame(
        source = c(0,1,0,1,4,4),
        target = c(2,2,3,3,0,1),
        weight = c(64,1667,45,425,109,2092),
        stringsAsFactors = FALSE
      )
    )
  )
})
