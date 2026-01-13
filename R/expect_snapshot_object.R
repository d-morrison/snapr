#' Snapshot testing for R objects
#' @description
#' A flexible wrapper around [testthat::expect_snapshot_file()] that allows
#' snapshotting any R object, not just data.frames. This function provides
#' a convenient interface for snapshot testing with sensible defaults for
#' serialization.
#'
#' @param x An R object to snapshot. Can be any R object including lists,
#'   models, data.frames, vectors, etc.
#' @param name [character] snapshot name (file extension will be added automatically)
#' @param writer [function] Function to write the object to a file. Default is [save_rds()].
#'   Other options include [save_json()], [save_deparse()], [save_csv()].
#'   Custom writer functions should accept `x` and return a file path.
#' @inheritDotParams testthat::expect_snapshot_file -path -name
#' @returns Invisible `NULL` (from [testthat::expect_snapshot_file()])
#' @export
#' @examples
#' \dontrun{
#' # Snapshot a list (using RDS format by default)
#' expect_snapshot_object(list(a = 1, b = 2, c = "text"), name = "config")
#'
#' # Snapshot a model
#' model <- lm(mpg ~ wt, data = mtcars)
#' expect_snapshot_object(model, name = "model")
#'
#' # Snapshot with JSON format (for human-readable diffs)
#' expect_snapshot_object(iris[1:5, ], name = "iris_sample", writer = save_json)
#'
#' # Snapshot with deparse format
#' expect_snapshot_object(list(x = 1:5), name = "simple_list", writer = save_deparse)
#' }
expect_snapshot_object <- function(x, name, writer = save_rds, ...) {
  path <- writer(x)
  # Get file extension from the path returned by writer
  ext <- tools::file_ext(path)
  # Determine comparison method based on file extension
  # Text-based formats use line-by-line comparison (ignores line-ending differences)
  # Binary formats use byte-by-byte comparison
  text_extensions <- c("txt", "json", "R", "csv", "md", "yml", "yaml", "xml")
  compare <- if (ext %in% text_extensions) {
    testthat::compare_file_text
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
