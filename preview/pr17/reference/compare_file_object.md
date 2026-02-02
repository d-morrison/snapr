# Compare RDS files using diffobj for better snapshot review

This comparison function loads RDS files and compares the deserialized R
objects rather than raw bytes. This enables better visualization in
snapshot_review() by comparing the actual object structure rather than
binary serialization.

For meaningful diffs in testthat's snapshot_review(), which uses diffobj
internally, this function compares the R objects after deserialization.

## Usage

``` r
compare_file_object(old, new)
```

## Arguments

- old:

  Path to the old (reference) RDS file

- new:

  Path to the new RDS file to compare

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
