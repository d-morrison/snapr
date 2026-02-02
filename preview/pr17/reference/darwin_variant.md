# Get darwin snapshot variant for macOS

Returns "darwin" for macOS, NULL for other platforms (Linux/Windows).

## Usage

``` r
darwin_variant()
```

## Value

"darwin" on macOS, NULL on other platforms

## Details

This is a specialized variant function for cases where only macOS
produces different results while Linux and Windows are identical. Use
this instead of
[`system_os()`](https:/d-morrison.github.io/snapr/preview/pr17/reference/system_os.md)
when:

- macOS produces unique output (e.g., platform-specific math libraries)

- Linux and Windows produce identical results

- You want to maintain a single snapshot for Linux/Windows

Common use cases:

- JAGS MCMC output (macOS uses different floating-point arithmetic)

- Platform-specific numerical computations

## Examples

``` r
if (FALSE) { # \dontrun{
# Use with expect_snapshot_file when only macOS differs
expect_snapshot_object(
  mcmc_result, name = "test", variant = darwin_variant()
)
} # }
```
