# snapr

The goal of snapr is to export the
[`expect_snapshot_data()`](https://d-morrison.github.io/snapr/reference/expect_snapshot_data.md)
function from `https://github.com/bcgov/ssdtools`, to test functions in
other projects, without having to import the entire `ssdtools` package.

See
<https://github.com/bcgov/ssdtools/issues/379#issuecomment-2372581429>.

## Installation

You can install the development version of snapr from
[GitHub](https://github.com/) with:

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
