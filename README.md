# snapr

<!-- badges: start -->
[![R-CMD-check](https://github.com/d-morrison/snapr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/d-morrison/snapr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of snapr is to export the `expect_snapshot_data()` function from `https://github.com/bcgov/ssdtools`, 
to test functions in other projects, without having to import the entire `ssdtools` package.

See <https://github.com/bcgov/ssdtools/issues/379#issuecomment-2372581429>.


## Installation

You can install the development version of snapr from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("d-morrison/snapr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(snapr)
## basic example code
```
