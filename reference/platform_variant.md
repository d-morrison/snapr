# Get platform variant including OS and R version

Returns a variant string combining OS and R major.minor version. This is
useful for RDS snapshots that vary by both platform and R version.

## Usage

``` r
platform_variant()
```

## Value

A character string like "linux-4.4", "darwin-4.5", or "windows-4.4"

## Details

RDS files can produce different binary output across R versions even
when using the same serialization version. This function creates variant
strings like "linux-4.4", "darwin-4.5", "windows-4.4" to handle these
differences.

Use this function with
[`testthat::expect_snapshot_file()`](https://testthat.r-lib.org/reference/expect_snapshot_file.html)
when testing RDS files or other formats that vary by both OS and R
version.

## Examples

``` r
if (FALSE) { # \dontrun{
# Use with expect_snapshot_file for RDS snapshots
expect_snapshot_object(
  my_object, name = "test", variant = platform_variant()
)
} # }
```
