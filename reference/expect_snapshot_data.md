# Snapshot a data frame

Copied with permission:
<https://github.com/bcgov/ssdtools/issues/379#issuecomment-2372581429>

## Usage

``` r
expect_snapshot_data(x, name, digits = 6)
```

## Arguments

- x:

  a [data.frame](https://rdrr.io/r/base/data.frame.html)

- name:

  a [character](https://rdrr.io/r/base/character.html) name of the
  snapshot

- digits:

  a [numeric](https://rdrr.io/r/base/numeric.html) number of digits to
  round to

## Examples

``` r
if (FALSE) { # \dontrun{
iris |> expect_snapshot_data(name = "iris")
} # }
```
