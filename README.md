
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/d3r)](https://cran.r-project.org/package=d3r)
[![R-CMD-check](https://github.com/timelyportfolio/d3r/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/timelyportfolio/d3r/actions/workflows/R-CMD-check.yaml)

### Installing d3r

`d3r` is on CRAN, so install with `install.packages("d3r")` or for the
absolute latest use `devtools`.

    devtools::install_github("timelyportfolio/d3r")

### d3 Dependency Functions

`d3r` makes `d3.js` dependency injection in R easy with `d3_dep_v3()`,
`d3_dep_v4()`, `d3_dep_v5()`, `d3_dep_v6()`, and the newest
`d3_dep_v7()`. These functions work well with `htmltools::tags`.

    library(htmltools)
    library(d3r)

    # check web developer tools to see d3 is available
    browsable(
      attachDependencies(
        tagList(),
        d3_dep_v7()
      )
    )

    # or include directly in a taglist; I prefer this method.
    browsable(
      tagList(
        h1("I have d3 version ", span(id="version")),
        tags$script("d3.select('#version').text(d3.version)"),
        d3_dep_v7()
      )
    )

Also, I will commit to keeping `d3r` up-to-date with `d3.js`, so you’ll
no longer need multiple copies of `d3.js` for your `htmlwidgets`. If you
are a `htmlwidget` author, you will no longer need to worry every time
`d3.js` gets a new release. See `treebar`
[lines](https://github.com/timelyportfolio/treebar/blob/master/R/treebar.R#L66-L74)
for an example of using `d3r` with your `htmlwidget`.

### d3 Hierarchy from data.frame

Building `d3.js` hierarchies can be very difficult. `d3r::d3_nest()`
will convert `table` and `data.frame` to a nested `d3.js` hierarchy
ready for work with
[`d3-hierarchy`](https://github.com/d3/d3-hierarchy).

    d3_nest(as.data.frame(Titanic))

As another example, let’s go from `treemap` to `d3.js`.

    library(treemap)
    library(d3r)

    d3_nest(
      treemap::random.hierarchical.data(),
      value_cols = "x"
    )

### d3 Hierarchy from partykit / rpart

`rpart` and similar objects in `R` are very difficult to convert but
make perfect subjects for `d3` hierarchical layouts. `d3_party` helps
convert these objects for easy usage with `d3.js`.

    #devtools::install_github("timelyportfolio/d3treeR")

    library(d3treeR)
    library(d3r)

    # example from ?rpart
    data("kyphosis", package="rpart")
    rp <-  rpart::rpart(
      Kyphosis ~ Age + Number + Start,
      data = kyphosis
    )

    # get the json hierarchy
    d3_party(tree=rp)

    # interactive plot with d3treeR
    d3tree2(
      d3_party(tree=rp),
      celltext="description",
      valueField="n"
    )

### d3 Network from igraph

`igraph` to `d3.js` network of `nodes` and `links` is a very common
conversion. `d3r::d3_igraph` will do this for you.

    library(igraph)
    library(d3r)

    d3_igraph(igraph::watts.strogatz.game(1, 50, 4, 0.05))

### Todo

I have a whole lot of ideas. Please let me know yours, and let’s make
this package great.

### Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](https://github.com/timelyportfolio/d3r/blob/master/CONDUCT.md).
By participating in this project you agree to abide by its terms.
