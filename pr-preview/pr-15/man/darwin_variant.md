1.  [Reference](https://d-morrison.github.io/snapr/pr-preview/pr-15/man/darwin_variant.md)
2.  [darwin_variant](https://d-morrison.github.io/snapr/pr-preview/pr-15/man/darwin_variant.md)

## Get darwin snapshot variant for macOS

### Description

Returns "darwin" for macOS, NULL for other platforms (Linux/Windows).

### Usage

``` R
darwin_variant()
```

### Details

This is a specialized variant function for cases where only macOS
produces different results while Linux and Windows are identical. Use
this instead of
[`system_os()`](https://d-morrison.github.io/snapr/reference/system_os.html)
when:

- macOS produces unique output (e.g., platform-specific math libraries)

- Linux and Windows produce identical results

- You want to maintain a single snapshot for Linux/Windows

Common use cases:

- JAGS MCMC output (macOS uses different floating-point arithmetic)

- Platform-specific numerical computations

### Value

"darwin" on macOS, NULL on other platforms

### Examples

Code

``` r
library("snapr")

# Use with expect_snapshot_file when only macOS differs
expect_snapshot_object(
  mcmc_result, name = "test", variant = darwin_variant()
)
```
