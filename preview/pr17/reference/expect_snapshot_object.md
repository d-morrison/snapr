# Snapshot testing for R objects

A flexible wrapper around
[`testthat::expect_snapshot_file()`](https://testthat.r-lib.org/reference/expect_snapshot_file.html)
that allows snapshotting any R object, not just data.frames. This
function provides a convenient interface for snapshot testing with
sensible defaults for serialization.

When using RDS format (the default), snapshots are compared using
[`diffobj::diffObj()`](https://rdrr.io/pkg/diffobj/man/diffObj.html)
which provides rich, visual diffs in
[`testthat::snapshot_review()`](https://testthat.r-lib.org/reference/snapshot_accept.html).
This makes it much easier to review changes to complex R objects.

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
  extension added automatically)

- writer:

  [function](https://rdrr.io/r/base/function.html) Function to write the
  object to a file. Default is
  [`save_rds()`](https:/d-morrison.github.io/snapr/preview/pr17/reference/save_rds.md).
  Other options include
  [`save_json()`](https:/d-morrison.github.io/snapr/preview/pr17/reference/save_json.md),
  [`save_deparse()`](https:/d-morrison.github.io/snapr/preview/pr17/reference/save_deparse.md),
  [`save_csv()`](https:/d-morrison.github.io/snapr/preview/pr17/reference/save_csv.md),
  [`save_diffobj()`](https:/d-morrison.github.io/snapr/preview/pr17/reference/save_diffobj.md).
  Custom writer functions should accept `x` and return a file path.

- ...:

  Arguments passed on to
  [`testthat::expect_snapshot_file`](https://testthat.r-lib.org/reference/expect_snapshot_file.html)

  `binary`

  :   **\[deprecated\]** Please use the `compare` argument instead.

  `cran`

  :   Should these expectations be verified on CRAN? By default, they
      are not, because snapshot tests tend to be fragile because they
      often rely on minor details of dependencies.

  `compare`

  :   A function used to compare the snapshot files. It should take two
      inputs, the paths to the `old` and `new` snapshot, and return
      either `TRUE` or `FALSE`. This defaults to `compare_file_text` if
      `name` has extension `.r`, `.R`, `.Rmd`, `.md`, or `.txt`, and
      otherwise uses `compare_file_binary`.

      `compare_file_binary()` compares byte-by-byte and
      `compare_file_text()` compares lines-by-line, ignoring the
      difference between Windows and Mac/Linux line endings.

  `transform`

  :   Optionally, a function to scrub sensitive or stochastic text from
      the output. Should take a character vector of lines as input and
      return a modified character vector as output.

  `variant`

  :   If not-`NULL`, results will be saved in
      `_snaps/{variant}/{test}/{name}`. This allows you to create
      different snapshots for different scenarios, like different
      operating systems or different R versions.

      Note that there's no way to declare all possible variants up front
      which means that as soon as you start using variants, you are
      responsible for deleting snapshot variants that are no longer
      used. (testthat will still delete all variants if you delete the
      test.)

## Value

[NULL](https://rdrr.io/r/base/NULL.html) (from
[`testthat::expect_snapshot_file()`](https://testthat.r-lib.org/reference/expect_snapshot_file.html))

## Details

When using RDS format (the default), snapshots can vary across R
versions and platforms even with fixed serialization versions. Consider
using `variant = platform_variant()` for RDS snapshots to handle these
differences, or use text-based formats like JSON or deparse for more
stable snapshots across platforms and versions.

The RDS comparison uses
[`diffobj::diffObj()`](https://rdrr.io/pkg/diffobj/man/diffObj.html)
internally, which provides rich visual diffs in
[`testthat::snapshot_review()`](https://testthat.r-lib.org/reference/snapshot_accept.html).
This is particularly useful for complex objects like models, nested
lists, or data structures where byte-level comparison would be difficult
to interpret.

## Examples

``` r
if (FALSE) { # \dontrun{
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

# Snapshot with str() format (optimal for diffobj visualization)
expect_snapshot_object(
  list(a = 1:5, b = letters[1:3]), name = "complex_list",
  writer = save_diffobj
)
} # }
```
