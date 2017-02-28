context("V8context")

test_that("d3_v8 has d3", {

  skip_on_cran()
  skip_on_travis()

  # d3_v8 works returns v8 context with d3 installed
  expect_identical(
    d3_v8()$get("global.d3.version"),
    d3_dep_v4()$version
  )

})
