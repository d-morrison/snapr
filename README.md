# snapr <img src="man/figures/logo.svg" align="right" height="139" alt="snapr hex sticker" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/d-morrison/snapr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/d-morrison/snapr/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/d-morrison/snapr/graph/badge.svg)](https://app.codecov.io/gh/d-morrison/snapr)
[![](https://www.r-pkg.org/badges/version/snapr?color=orange)](https://cran.r-project.org/package=snapr)
[![](http://cranlogs.r-pkg.org/badges/grand-total/snapr?color=blue)](https://cran.r-project.org/package=snapr)
[![CRAN checks](https://badges.cranchecks.info/summary/snapr.svg)](https://cran.r-project.org/web/checks/check_results_snapr.html)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://cran.r-project.org/web/licenses/MIT)
[![](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
<!-- badges: end -->

The goal of snapr is to provide convenient snapshot testing functions for R packages:

- `expect_snapshot_data()` - for data.frames (adapted [with permission](https://github.com/bcgov/ssdtools/issues/379) from the [`{ssdtools}` package](https://CRAN.R-project.org/package=ssdtools))
- `expect_snapshot_object()` - generalizes `expect_snapshot_data()` for use with any R object

## Installation

You can install the released version of snapr from [CRAN](https://cran.r-project.org/) with:

``` r
install.packages("snapr")
```

You can install the development version of snapr from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("d-morrison/snapr")
```

### Optional: enhanced RDS diffs with diffviewer

`snapr` works best with the [d-morrison/diffviewer](https://github.com/d-morrison/diffviewer)
fork of [diffviewer](https://github.com/r-lib/diffviewer), which wraps
[diffobj](https://github.com/brodieG/diffobj) to provide rich, visual diffs
when reviewing RDS snapshots via `testthat::snapshot_review()`. Install it
with:

``` r
pak::pak("d-morrison/diffviewer")
```

## Examples

### Snapshot data.frames

``` r
library(snapr)

# In a testthat test file:
test_that("iris data is correct", {
  expect_snapshot_data(iris[1:5, ], name = "iris_sample")
})
```

### Snapshot any R object

``` r
library(snapr)

# Snapshot a list (RDS format by default - works for any R object)
test_that("config object is correct", {
  config <- list(
    name = "my_app",
    version = "1.0.0",
    settings = list(debug = TRUE, timeout = 30)
  )
  expect_snapshot_object(config, name = "config")
})

# Snapshot with JSON format for human-readable diffs
test_that("simple data is correct", {
  data <- list(x = 1:5, y = letters[1:5])
  expect_snapshot_object(data, name = "simple_data", writer = save_json)
})

# Snapshot a model (use RDS for complex objects)
test_that("model structure is correct", {
  model <- lm(mpg ~ wt, data = mtcars)
  expect_snapshot_object(model, name = "model")
})
```
