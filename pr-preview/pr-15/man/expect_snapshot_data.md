1.  [Reference](https://d-morrison.github.io/snapr/pr-preview/pr-15/man/darwin_variant.md)
2.  [expect_snapshot_data](https://d-morrison.github.io/snapr/pr-preview/pr-15/man/expect_snapshot_data.md)

## Snapshot testing for data.frames

### Description

copied from <https://github.com/bcgov/ssdtools> with permission
(<https://github.com/bcgov/ssdtools/issues/379>)

### Usage

``` R
expect_snapshot_data(x, name, digits = 6, ...)
```

### Arguments

[TABLE]

### Value

NULL (from
[`testthat::expect_snapshot_file()`](https://testthat.r-lib.org/reference/expect_snapshot_file.html))

### Examples

Code

``` r
library("snapr")

expect_snapshot_data(iris, name = "iris")
```
