# Copilot Instructions for snapr Package

## Roxygen2 Cross-Reference Syntax

When documenting R functions with roxygen2, use the `[]` syntax to
create cross-references to other documentation:

### Basic Syntax

- `[function_name()]` - Link to a function in the same package
- `[pkg::function_name()]` - Link to a function in another package
- `[topic]` - Link to a topic/object in the same package
- `[pkg::topic]` - Link to a topic/object in another package

### Important Examples

- `[NULL]` - Creates a cross-reference to the NULL object documentation
- `[data.frame]` - Creates a cross-reference to data.frame documentation
- `[testthat::expect_snapshot_file()]` - Links to testthat’s
  expect_snapshot_file function

### Usage in @returns Tag

Always use the cross-reference syntax for return values that are
documented objects:

``` r
#' @returns [NULL] (from [testthat::expect_snapshot_file()])
```

NOT:

``` r
#' @returns Invisible `NULL` (from ...)
```

The `[NULL]` syntax creates a proper link to the NULL documentation,
while backticks just format it as code without creating a link.

### Reference

- [Roxygen2 Cross-Reference
  Guide](https://roxygen2.r-lib.org/articles/index-crossref.html)

## Package Documentation Standards

This package uses roxygen2 with markdown enabled (see `DESCRIPTION`
file: `Roxygen: list(markdown = TRUE)`).

This means you can use: - Markdown formatting in documentation - `[]`
for cross-references - `` ` `` for inline code - Markdown lists,
headers, etc.
