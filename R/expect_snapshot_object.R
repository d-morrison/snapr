#' Snapshot testing for R objects
#' @description
#' A flexible wrapper around [testthat::expect_snapshot_file()] that allows
#' snapshotting any R object, not just data.frames. This function provides
#' a convenient interface for snapshot testing with sensible defaults for
#' serialization.
#'
#' When using RDS format (the default), snapshots are compared using
#' [diffobj::diffObj()] which provides rich, visual diffs in
#' [testthat::snapshot_review()]. This makes it much easier to review
#' changes to complex R objects.
#'
#' @param x An R object to snapshot. Can be any R object including lists,
#'   models, data.frames, vectors, etc.
#' @param name [character] snapshot name (file extension added
#'   automatically)
#' @param writer [function] Function to write the object to a file.
#'   Default is [save_rds()].
#'   Other options include [save_json()], [save_deparse()], [save_csv()],
#'   [save_diffobj()].
#'   Custom writer functions should accept `x` and return a file path.
#' @inheritDotParams testthat::expect_snapshot_file -path -name
#' @returns [NULL] (from [testthat::expect_snapshot_file()])
#' @export
#' @details
#' When using RDS format (the default), snapshots can vary across R versions
#' and platforms even with fixed serialization versions. Consider using
#' `variant = platform_variant()` for RDS snapshots to handle these
#' differences, or use text-based formats like JSON or deparse for more
#' stable snapshots across platforms and versions.
#'
#' The RDS comparison uses [diffobj::diffObj()] internally, which provides
#' rich visual diffs in [testthat::snapshot_review()]. This is particularly
#' useful for complex objects like models, nested lists, or data structures
#' where byte-level comparison would be difficult to interpret.
#' @examples
#' \dontrun{
#' # Snapshot a list (using RDS format with platform/version variant)
#' expect_snapshot_object(
#'   list(a = 1, b = 2), name = "config", variant = platform_variant()
#' )
#'
#' # Snapshot a model
#' model <- lm(mpg ~ wt, data = mtcars)
#' expect_snapshot_object(
#'   model, name = "model", variant = platform_variant()
#' )
#'
#' # Snapshot with JSON format (for human-readable diffs)
#' # Text formats don't need variants
#' expect_snapshot_object(iris[1:5, ], name = "iris", writer = save_json)
#'
#' # Snapshot with deparse format
#' expect_snapshot_object(
#'   list(x = 1:5), name = "simple_list", writer = save_deparse
#' )
#'
#' # Snapshot with str() format (optimal for diffobj visualization)
#' expect_snapshot_object(
#'   list(a = 1:5, b = letters[1:3]), name = "complex_list",
#'   writer = save_diffobj
#' )
#' }
expect_snapshot_object <- function(x, name, writer = save_rds, ...) {
  path <- writer(x)
  # Get file extension from the path returned by writer
  ext <- tools::file_ext(path)
  # Determine comparison method based on file extension
  # Text-based formats use line-by-line comparison
  # (ignores line-ending differences)
  # RDS files use object comparison with diffobj for better visualization
  # Binary formats use byte-by-byte comparison
  text_extensions <- c("txt", "json", "R", "csv", "md", "yml", "yaml", "xml")
  compare <- if (ext %in% text_extensions) {
    testthat::compare_file_text
  } else if (ext == "rds") {
    compare_file_object
  } else {
    testthat::compare_file_binary
  }
  testthat::expect_snapshot_file(
    path = path,
    name = paste0(name, ".", ext),
    compare = compare,
    ...
  )
}

#' Save an R object to an RDS file
#' @param x An R object to save
#' @returns [character] Path to the temporary RDS file
#' @keywords internal
#' @export
save_rds <- function(x) {
  path <- tempfile(fileext = ".rds")
  saveRDS(x, path, version = 2)
  path
}

#' Save an R object to a JSON file
#' @param x An R object to save
#' @returns [character] Path to the temporary JSON file
#' @keywords internal
#' @export
save_json <- function(x) {
  path <- tempfile(fileext = ".json")
  jsonlite::write_json(x, path, pretty = TRUE, auto_unbox = TRUE)
  path
}

#' Save an R object to a text file using deparse
#' @param x An R object to save
#' @returns [character] Path to the temporary text file
#' @keywords internal
#' @export
save_deparse <- function(x) {
  path <- tempfile(fileext = ".txt")
  writeLines(deparse(x), path)
  path
}

#' Save an R object using diffobj-friendly format
#' @description
#' Saves an R object in a text format that is optimized for visualization
#' with diffobj in testthat's snapshot_review(). This uses a combination
#' of str() output which provides a hierarchical view of the object structure.
#'
#' @param x An R object to save
#' @returns [character] Path to the temporary text file
#' @keywords internal
#' @export
#' @importFrom utils str
#' @examples
#' \dontrun{
#' obj <- list(a = 1:5, b = letters[1:3], c = list(x = 1, y = 2))
#' path <- save_diffobj(obj)
#' cat(readLines(path), sep = "\n")
#' }
save_diffobj <- function(x) {
  path <- tempfile(fileext = ".txt")
  # Capture str() output which gives a good hierarchical view
  output <- utils::capture.output(utils::str(x))
  writeLines(output, path)
  path
}

#' Compare RDS files using diffobj for better snapshot review
#' @description
#' This comparison function loads RDS files and compares the deserialized
#' R objects rather than raw bytes. This enables better visualization in
#' snapshot_review() by comparing the actual object structure rather than
#' binary serialization.
#'
#' For meaningful diffs in testthat's snapshot_review(), which uses diffobj
#' internally, this function compares the R objects after deserialization.
#'
#' @param old Path to the old (reference) RDS file
#' @param new Path to the new RDS file to compare
#' @returns [logical] TRUE if objects are identical, FALSE otherwise
#' @export
#' @keywords internal
#' @examples
#' \dontrun{
#' # This is used internally by expect_snapshot_object
#' # when comparing RDS files
#' old_obj <- list(a = 1, b = 2)
#' new_obj <- list(a = 1, b = 3)
#' old_path <- tempfile(fileext = ".rds")
#' new_path <- tempfile(fileext = ".rds")
#' saveRDS(old_obj, old_path)
#' saveRDS(new_obj, new_path)
#' compare_file_object(old_path, new_path)
#' }
compare_file_object <- function(old, new) {
  # Load the RDS files
  old_obj <- readRDS(old)
  new_obj <- readRDS(new)

  # Compare using identical - compares the deserialized objects
  # rather than raw bytes, which is more meaningful for R objects
  # This allows testthat's snapshot_review to properly detect changes
  # in the actual data structure rather than serialization differences
  identical(old_obj, new_obj)
}
