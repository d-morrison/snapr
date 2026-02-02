# Save an R object using diffobj-friendly format

Saves an R object in a text format that is optimized for visualization
with diffobj in testthat's snapshot_review(). This uses a combination of
str() output which provides a hierarchical view of the object structure.

## Usage

``` r
save_diffobj(x)
```

## Arguments

- x:

  An R object to save

## Value

[character](https://rdrr.io/r/base/character.html) Path to the temporary
text file

## Examples

``` r
if (FALSE) { # \dontrun{
obj <- list(a = 1:5, b = letters[1:3], c = list(x = 1, y = 2))
path <- save_diffobj(obj)
cat(readLines(path), sep = "\n")
} # }
```
