# snapr

<!-- badges: start -->
[![R-CMD-check](https://github.com/d-morrison/snapr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/d-morrison/snapr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of snapr is to provide convenient snapshot testing functions for R packages:

- `expect_snapshot_data()` - for data.frames (adapted with permission from `https://github.com/bcgov/ssdtools`)
- `expect_snapshot_object()` - for any R object

See <https://github.com/bcgov/ssdtools/issues/379#issuecomment-2372581429>.


## Installation

You can install the development version of snapr from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("d-morrison/snapr")
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

# Snapshot a list
test_that("config object is correct", {
  config <- list(
    name = "my_app",
    version = "1.0.0",
    settings = list(debug = TRUE, timeout = 30)
  )
  expect_snapshot_object(config)
})

# Snapshot a model
test_that("model structure is correct", {
  model <- lm(mpg ~ wt, data = mtcars)
  expect_snapshot_object(model, style = "serialize")
})
```
