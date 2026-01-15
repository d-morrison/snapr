# Snapshot testing for R objects

A flexible wrapper around
[`testthat::expect_snapshot_file()`](https://testthat.r-lib.org/reference/expect_snapshot_file.html)
that allows snapshotting any R object, not just data.frames. This
function provides a convenient interface for snapshot testing with
sensible defaults for serialization.

## Usage

``` r
expect_snapshot_object(x, name, writer = save_rds, ...)
```

## Arguments

- x:

  An R object to snapshot. Can be any R object including lists, models,
  data.frames, vectors, etc.

- name:

  [character](https://rdrr.io/r/base/character.html) snapshot name (file
  extension will be added automatically)

- writer:

  [function](https://rdrr.io/r/base/function.html) Function to write the
  object to a file. Default is
  [`save_rds()`](https:/d-morrison.github.io/snapr/preview/pr11/reference/save_rds.md).
  Other options include
  [`save_json()`](https:/d-morrison.github.io/snapr/preview/pr11/reference/save_json.md),
  [`save_deparse()`](https:/d-morrison.github.io/snapr/preview/pr11/reference/save_deparse.md),
  [`save_csv()`](https:/d-morrison.github.io/snapr/preview/pr11/reference/save_csv.md).
  Custom writer functions should accept `x` and return a file path.

- ...:

  Arguments passed on to
  [`testthat::expect_snapshot_file`](https://testthat.r-lib.org/reference/expect_snapshot_file.html)

  `cran`

  :   Should these expectations be verified on CRAN? By default, they
      are not, because snapshot tests tend to be fragile because they
      often rely on minor details of dependencies.

  `compare`

  :   A function used to compare the old and new results. Defaults to
      `compare_file_text()` for text files. For RDS files, uses
      [`waldo::compare()`](https://waldo.r-lib.org/reference/compare.html)
      to compare objects. For other binary files, uses
      `compare_file_binary()`.

  `variant`

  :   If not-`NULL`, results will be saved in
      `_snaps/{variant}/{test}/{name}`. This allows you to create
      variants for experiments, or if the results are different on
      different operating systems. Snapshot variant is set by the
      [local_reproducible_output()](https://testthat.r-lib.org/reference/local_test_context.html)
      function and its friends. If you're developing a package you can
      set it in the `tests/testthat/helper.R` file.

## Value

\[NULL\] (from
[`testthat::expect_snapshot_file()`](https://testthat.r-lib.org/reference/expect_snapshot_file.html))

## Examples

``` r
if (FALSE) { # \dontrun{
# Snapshot a list (using RDS format by default)
expect_snapshot_object(list(a = 1, b = 2, c = "text"), name = "config")

# Snapshot a model
model <- lm(mpg ~ wt, data = mtcars)
expect_snapshot_object(model, name = "model")

# Snapshot with JSON format (for human-readable diffs)
expect_snapshot_object(iris[1:5, ], name = "iris_sample", writer = save_json)

# Snapshot with deparse format
expect_snapshot_object(list(x = 1:5), name = "simple_list", writer = save_deparse)
} # }
```
