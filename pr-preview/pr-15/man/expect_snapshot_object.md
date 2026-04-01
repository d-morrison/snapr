1.  [Reference](https://d-morrison.github.io/snapr/pr-preview/pr-15/man/darwin_variant.md)
2.  [expect_snapshot_object](https://d-morrison.github.io/snapr/pr-preview/pr-15/man/expect_snapshot_object.md)

## Snapshot testing for R objects

### Description

A flexible wrapper around
[`testthat::expect_snapshot_file()`](https://testthat.r-lib.org/reference/expect_snapshot_file.html)
that allows snapshotting any R object, not just data.frames. This
function provides a convenient interface for snapshot testing with
sensible defaults for serialization.

### Usage

``` R
expect_snapshot_object(x, name, writer = save_rds, ...)
```

### Arguments

[TABLE]

### Details

When using RDS format (the default), snapshots can vary across R
versions and platforms even with fixed serialization versions. Consider
using `variant = platform_variant()` for RDS snapshots to handle these
differences, or use text-based formats like JSON or deparse for more
stable snapshots across platforms and versions.

### Value

NULL (from
[`testthat::expect_snapshot_file()`](https://testthat.r-lib.org/reference/expect_snapshot_file.html))

### Examples

Code

``` r
library("snapr")

# Snapshot a list (using RDS format with platform/version variant)
expect_snapshot_object(
  list(a = 1, b = 2), name = "config", variant = platform_variant()
)

# Snapshot a model
model <- lm(mpg ~ wt, data = mtcars)
expect_snapshot_object(
  model, name = "model", variant = platform_variant()
)

# Snapshot with JSON format (for human-readable diffs)
# Text formats don't need variants
expect_snapshot_object(iris[1:5, ], name = "iris", writer = save_json)

# Snapshot with deparse format
expect_snapshot_object(
  list(x = 1:5), name = "simple_list", writer = save_deparse
)
```
