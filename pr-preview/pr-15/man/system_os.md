1.  [Reference](https://d-morrison.github.io/snapr/pr-preview/pr-15/man/darwin_variant.md)
2.  [system_os](https://d-morrison.github.io/snapr/pr-preview/pr-15/man/system_os.md)

## Get the current operating system

### Description

Returns the name of the current operating system in lowercase. This is a
simple wrapper around `Sys.info()[[“sysname”]]`.

### Usage

``` R
system_os()
```

### Details

This function is used with testthat’s `variant` parameter in
[`testthat::expect_snapshot_file()`](https://testthat.r-lib.org/reference/expect_snapshot_file.html)
to create OS-specific snapshots when file formats produce different
output across platforms.

Common use cases:

- RDS files: Binary serialization format that can differ across OS

- Platform-specific numeric computations (e.g., MCMC algorithms)

- Files with platform-specific line endings or encodings

### Value

A character string: "linux", "darwin" (macOS), or "windows"

### Examples

Code

``` r
library("snapr")

# Use with expect_snapshot_file for OS-specific snapshots
expect_snapshot_object(my_object, name = "test", variant = system_os())
```
