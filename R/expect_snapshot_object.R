#' Snapshot testing for R objects
#' @description
#' A flexible wrapper around [testthat::expect_snapshot_value()] that allows
#' snapshotting any R object, not just data.frames. This function provides
#' a convenient interface for snapshot testing with sensible defaults for
#' serialization style.
#'
#' @param x An R object to snapshot. Can be any R object including lists,
#'   models, data.frames, vectors, etc.
#' @param style [character] Serialization style. One of:
#'   - `"json"` - Uses `jsonlite::toJSON` for readable output (simple objects only)
#'   - `"json2"` - Uses `jsonlite::serializeJSON` for more complex objects (default)
#'   - `"deparse"` - Uses R's `deparse()` for R code representation
#'   - `"serialize"` - Uses raw byte serialization (works for any object but not human-readable)
#' @inheritDotParams testthat::expect_snapshot_value -x -style
#' @returns Invisible `NULL` (from [testthat::expect_snapshot_value()])
#' @export
#' @examples
#' \dontrun{
#' # Snapshot a list
#' expect_snapshot_object(list(a = 1, b = 2, c = "text"))
#'
#' # Snapshot a model
#' model <- lm(mpg ~ wt, data = mtcars)
#' expect_snapshot_object(model, style = "serialize")
#'
#' # Snapshot a data.frame with JSON style
#' expect_snapshot_object(iris[1:5, ], style = "json")
#' }
expect_snapshot_object <- function(x, style = "json2", ...) {
  testthat::expect_snapshot_value(x = x, style = style, ...)
}
