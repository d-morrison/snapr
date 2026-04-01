# Compare RDS files using diffobj for better snapshot review

This comparison function loads RDS files and compares the deserialized R
objects rather than raw bytes. This enables better visualization in
snapshot_review() by comparing the actual object structure rather than
binary serialization.

For meaningful diffs in testthat's snapshot_review(), which uses diffobj
internally, this function compares the R objects after deserialization.

## Usage

``` r
compare_file_object(old, new, print = FALSE, ...)
```

## Arguments

- old:

  Path to the old (reference) RDS file

- new:

  Path to the new RDS file to compare

- print:

  [logical](https://rdrr.io/r/base/logical.html) whether to print
  [waldo::compare](https://waldo.r-lib.org/reference/compare.html)
  output to R console; can become very long for complex objects like
  [lm](https://rdrr.io/r/stats/lm.html)s

- ...:

  Arguments passed on to
  [`waldo::compare`](https://waldo.r-lib.org/reference/compare.html)

  `x,y`

  :   Objects to compare. `x` is treated as the reference object so
      messages describe how `y` is different to `x`.

  `x_arg,y_arg`

  :   Name of `x` and `y` arguments, used when generated paths to
      internal components. These default to "old" and "new" since it's
      most natural to supply the previous value then the new value.

  `tolerance`

  :   If non-`NULL`, used as threshold for ignoring small floating point
      difference when comparing numeric vectors. Using any non-`NULL`
      value will cause integer and double vectors to be compared based
      on their values, not their types, and will ignore the difference
      between `NaN` and `NA_real_`.

      It uses the same algorithm as
      [`all.equal()`](https://rdrr.io/r/base/all.equal.html), i.e.,
      first we generate `x_diff` and `y_diff` by subsetting `x` and `y`
      to look only locations with differences. Then we check that
      `mean(abs(x_diff - y_diff)) / mean(abs(y_diff))` (or just
      `mean(abs(x_diff - y_diff))` if `y_diff` is small) is less than
      `tolerance`.

  `max_diffs`

  :   Control the maximum number of differences shown. The default shows
      10 differences when run interactively and all differences when run
      in CI. Set `max_diffs = Inf` to see all differences.

  `ignore_srcref`

  :   Ignore differences in function `srcref`s? `TRUE` by default since
      the `srcref` does not change the behaviour of a function, only its
      printed representation.

  `ignore_attr`

  :   Ignore differences in specified attributes? Supply a character
      vector to ignore differences in named attributes. By default the
      `"waldo_opts"` attribute is listed in `ignore_attr` so that
      changes to it are not reported; if you customize `ignore_attr`,
      you will probably want to do this yourself.

      For backward compatibility with
      [`all.equal()`](https://rdrr.io/r/base/all.equal.html), you can
      also use `TRUE`, to all ignore differences in all attributes. This
      is not generally recommended as it is a blunt tool that will
      ignore many important functional differences.

  `ignore_encoding`

  :   Ignore string encoding? `TRUE` by default, because this is R's
      default behaviour. Use `FALSE` when specifically concerned with
      the encoding, not just the value of the string.

  `ignore_function_env,ignore_formula_env`

  :   Ignore the environments of functions and formulas, respectively?
      These are provided primarily for backward compatibility with
      [`all.equal()`](https://rdrr.io/r/base/all.equal.html) which
      always ignores these environments.

  `list_as_map`

  :   Compare lists as if they are mappings between names and values.
      Concretely, this drops `NULL`s in both objects and sorts named
      components.

  `quote_strings`

  :   Should strings be surrounded by quotes? If `FALSE`, only
      side-by-side and line-by-line comparisons will be used, and
      there's no way to distinguish between `NA` and `"NA"`.

## Value

[logical](https://rdrr.io/r/base/logical.html) TRUE if objects are
identical, FALSE otherwise

## Examples

``` r
if (FALSE) { # \dontrun{
# This is used internally by expect_snapshot_object
# when comparing RDS files
old_obj <- list(a = 1, b = 2)
new_obj <- list(a = 1, b = 3)
old_path <- tempfile(fileext = ".rds")
new_path <- tempfile(fileext = ".rds")
saveRDS(old_obj, old_path)
saveRDS(new_obj, new_path)
compare_file_object(old_path, new_path)
} # }
```
