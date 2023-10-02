# d3r 1.1.0

* update d3 version [`7.8.5`](https://github.com/d3/d3/releases/tag/v7.8.5) dependency function `d3_dep_v7()`

# d3r 1.0.1

* update d3 version [`7.8.2`](https://github.com/d3/d3/releases/tag/v7.8.2) dependency function `d3_dep_v7()`
* fix CRAN test errors

# d3r 1.0.0

* add d3 version [`7.0.0`](https://github.com/d3/d3/releases/tag/v7.0.0) dependency function `d3_dep_v7()`
* update d3 version [`6.7.0`](https://github.com/d3/d3/releases/tag/v6.7.0) in dependency function `d3_dep_v6()`

# d3r 0.9.1

* add d3 version [`6.2.0`](https://github.com/d3/d3/releases/tag/v6.2.0) dependency function `d3_dep_v6()`

# d3r 0.9.0

* remove use of `nest_` in `d3_party` 
* upgrade d3v5 to [`5.16.0`](https://github.com/d3/d3/releases/tag/v5.16.0)

# d3r 0.8.7

* work with new and old `tidyr` syntax
* upgrade d3v5 to [`5.10.0`](https://github.com/d3/d3/releases/tag/v5.10.0)

# d3r 0.8.6

* update d3v5 to [`5.9.7`](https://github.com/d3/d3/releases/tag/v5.9.7)

# d3r 0.8.5

* update d3v5 to [`5.8.0`](https://github.com/d3/d3/releases/tag/v5.8.0)

# d3r 0.8.4

* update d3v5 to [`5.7.0`](https://github.com/d3/d3/releases/tag/v5.7.0)

# d3r 0.8.3

* fix extra slash in offline dependencies

# d3r 0.8.2

* update d3v5 to [`5.5.0`](https://github.com/d3/d3/releases/tag/v5.5.0)
* add httr to Suggests to resolve CRAN issue

# d3r 0.8.1

* add d3v5 for d3 [`5.1.0`](https://github.com/d3/d3/releases/tag/v5.1.0)

# d3r 0.8.0

* add d3v5 for d3 [`5.0.0-rc4`](https://github.com/d3/d3/releases/tag/v5.0.0)
* update d3v4 to [`4.13.0`](https://github.com/d3/d3/releases/tag/v4.13.0)


# d3r 0.7.1

* update d3v4 to [`4.12.0`](https://github.com/d3/d3/releases/tag/v4.12.0)

# d3r 0.7.0

* update d3v4 to [`4.11.0`](https://github.com/d3/d3/releases/tag/v4.11.0)
* update d3-jetpack to 2.0.9

# d3r 0.6.9

### Updates

* modify `d3_nest()` to work with new tidyr.

# d3r 0.6.8

### Updates

* `d3_dep_jetpack()` added. Essentially the same as d3_dep_v4(), but with a number of convenience functions added. Learn more by checking out the [d3-jetpack github page](https://github.com/gka/d3-jetpack). 

* update d3v4 to [`4.10.0`](https://github.com/d3/d3/releases/tag/v4.10.0)

# d3r 0.6.7

### API Changes

* **(BREAKING)** d3_table weight column is now named value to be consistent with the newest d3-sankey plugin [commit](https://github.com/timelyportfolio/d3r/commit/65b913322f1a6c71db21496f158bb0bed645a1f6).

* Use unpkg.com for online dependencies

# d3r 0.6.6

### Updates

* add d3_table() function to convert R table into list of a nodes data.frame and a links data.frame modelled after [example](https://gist.github.com/timelyportfolio/3616869996703d48a981)

# d3r 0.6.5

### Updates

* update d3v4 to [`4.9.1`](https://github.com/d3/d3/releases/tag/v4.9.1)

# d3r 0.6.4

### Bug Fix

* d3_nest would fail with certain hierarchies that had multiple NA level; fix only takes first na_child since non-first children will be duplicates (see [commit](https://github.com/timelyportfolio/d3r/commit/1529acad5230207e3b4711202509bc5e9411076b))

# d3r 0.6.3

### Updates

* update d3v4 to [`4.8.0`](https://github.com/d3/d3/releases/tag/v4.8.0)
* test with development `dplyr`

# d3r 0.6.2

### Updates

* update d3v4 to [`4.6.0`](https://github.com/d3/d3/releases/tag/v4.6.0)
* add `d3_v8()` convenience function to return `V8` context with d3.js loaded

# d3r 0.6.1

### Updates

* update d3v4 to [`4.4.4`](https://github.com/d3/d3/releases/tag/v4.4.4)

# d3r 0.6.0

### Updates

* add `colname` to return value (see [commit](https://github.com/timelyportfolio/d3r/commit/5787e03a6b59c89b367a88f16e9c5a899482a8d3))

* improve `NA` child promotion for deeply nested hierarchies

### API Changes

* **(BREAKING)** change `id` to `name` (see [issue]( https://github.com/timelyportfolio/d3r/issues/10))

# d3r 0.5.0

### Updates

* update d3 to [4.4.0](https://github.com/d3/d3/releases/tag/v4.4.0)

### API Changes

* (non-breaking) add offline argument to d3_dep_v3 and d3_dep_v4


# d3r 0.4.2

* CRAN release

