# snapr

The goal of snapr is to provide convenient snapshot testing functions
for R packages:

- [`expect_snapshot_data()`](https:/d-morrison.github.io/snapr/preview/pr17/reference/expect_snapshot_data.md) -
  for data.frames (adapted [with
  permission](https://github.com/bcgov/ssdtools/issues/379) from the
  [`{ssdtools}`
  package](https://cran.r-project.org/web/packages/ssdtools/index.html))
- [`expect_snapshot_object()`](https:/d-morrison.github.io/snapr/preview/pr17/reference/expect_snapshot_object.md) -
  generalizes
  [`expect_snapshot_data()`](https:/d-morrison.github.io/snapr/preview/pr17/reference/expect_snapshot_data.md)
  for use with any R object

## Installation

You can install the development version of snapr from
[GitHub](https://github.com/) with:

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
