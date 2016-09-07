context("dependencies")

v3 <- d3_dep_v3()
v4 <- d3_dep_v4()

test_that("d3_dep-* returns html_dependency", {
  expect_is(v3, "html_dependency")
  expect_is(v4, "html_dependency")
})

test_that("d3_dep-* src href is a valid url", {
  is_valid_url <- function(u){
    !httr::http_error(u)
  }
  expect_true(is_valid_url(file.path(v3$src$href,v3$script)))
  expect_true(is_valid_url(file.path(v4$src$href,v4$script)))
})

test_that("d3_dep-* src file is a valid file", {
  expect_true(file.exists(file.path(v3$src$file,v3$script)))
  expect_true(file.exists(file.path(v4$src$file,v4$script)))
})


test_that("d3_dep_v4 on latest d3 release", {
  # skip on travis??
  skip_on_travis()

  expect_identical(
    sprintf("v%s",v4$version),
    github::get.latest.release("d3","d3")$content$tag_name
  )
})


