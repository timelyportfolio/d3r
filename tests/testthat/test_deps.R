context("dependencies")

v3 <- d3_dep_v3()
v3_offline <- d3_dep_v3(offline=FALSE)

v4 <- d3_dep_v4()
v4_offline <- d3_dep_v4(offline=FALSE)

v5 <- d3_dep_v5()
v5_offline <- d3_dep_v5(offline=FALSE)


jetpack <- d3_dep_jetpack()
jetpack_offline <- d3_dep_jetpack(offline=FALSE)

test_that("d3_dep-* returns html_dependency", {
  expect_is(v3, "html_dependency")
  expect_is(v4, "html_dependency")
  expect_is(v5, "html_dependency")
  expect_is(jetpack, 'html_dependency')
})

test_that("d3_dep-* src href is a valid url", {
  skip_if_not_installed("httr")
  is_valid_url <- function(u){
    !httr::http_error(u)
  }
  expect_true(is_valid_url(file.path(v3_offline$src$href,v3$script)))
  expect_true(is_valid_url(file.path(v4_offline$src$href,v4$script)))
  expect_true(is_valid_url(file.path(v5_offline$src$href,v5$script)))
  expect_true(is_valid_url(file.path(jetpack_offline$src$href,jetpack$script)))
})

test_that("d3_dep-* src file is a valid file", {
  expect_true(file.exists(file.path(v3$src$file,v3$script)))
  expect_true(file.exists(file.path(v4$src$file,v4$script)))
  expect_true(file.exists(file.path(v5$src$file,v5$script)))
  expect_true(file.exists(file.path(jetpack$src$file, jetpack$script)))
})

test_that("d3_dep_v4 on latest d3 release", {
  skip_if_not_installed("github")

  expect_identical(
    sprintf("v%s",v4$version),
    github::get.latest.release("d3","d3")$content$tag_name
  )
})

test_that("d3-jetpack on latest release", {
  skip_on_cran()
  skip_on_travis()

  expect_identical(
    jetpack$version,
    gsub(
      x=github::get.latest.release("gka","d3-jetpack")$content$tag_name,
      pattern="v",
      replacement=""
    )
  )
})
