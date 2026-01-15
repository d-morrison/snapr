#' Compare RDS files using waldo
#' @description
#' Custom comparison function for RDS files that compares the R objects
#' contained within, rather than the binary representation. This avoids
#' spurious test failures due to irrelevant differences in file metadata,
#' compression, or session info.
#' @param old Path to the old (expected) RDS file
#' @param new Path to the new (actual) RDS file
#' @returns TRUE if objects are equal, FALSE otherwise
#' @keywords internal
compare_rds <- function(old, new) {
  old_obj <- tryCatch(
    readRDS(old),
    error = function(e) {
      stop("Failed to read old RDS file: ", old, "\n  Error: ", e$message, call. = FALSE)
    }
  )
  new_obj <- tryCatch(
    readRDS(new),
    error = function(e) {
      stop("Failed to read new RDS file: ", new, "\n  Error: ", e$message, call. = FALSE)
    }
  )
  # waldo::compare returns a character vector of differences
  # Empty vector means no differences
  diff <- waldo::compare(old_obj, new_obj, x_arg = "old", y_arg = "new")
  
  if (length(diff) > 0) {
    # Print the human-readable diff so it appears in test output
    # Create a text file with the comparison for easier review
    diff_file <- paste0(tools::file_path_sans_ext(new), "_diff.txt")
    writeLines(c(
      "Waldo comparison of RDS snapshots:",
      "===================================",
      "",
      diff
    ), diff_file)
    
    message(
      "Snapshot mismatch detected. Waldo comparison:\n",
      paste(diff, collapse = "\n"),
      "\n\nDiff also saved to: ", diff_file
    )
    return(FALSE)
  }
  
  TRUE
}

#' Snapshot testing for R objects
#' @description
#' A flexible wrapper around [testthat::expect_snapshot_file()] that allows
#' snapshotting any R object, not just data.frames. This function provides
#' a convenient interface for snapshot testing with sensible defaults for
#' serialization.
#'
#' @param x An R object to snapshot. Can be any R object including lists,
#'   models, data.frames, vectors, etc.
#' @param name [character] snapshot name (file extension added
#'   automatically)
#' @param writer [function] Function to write the object to a file.
#'   Default is [save_rds()].
#'   Other options include [save_json()], [save_deparse()], [save_csv()].
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
#' }
expect_snapshot_object <- function(x, name, writer = save_rds, ...) {
  path <- writer(x)
  # Get file extension from the path returned by writer
  ext <- tools::file_ext(path)
  # Determine comparison method based on file extension
  # Text-based formats use line-by-line comparison
  # (ignores line-ending differences)
  # RDS files use waldo::compare for object-level comparison
  # Other binary formats use byte-by-byte comparison
  text_extensions <- c("txt", "json", "R", "csv", "md", "yml", "yaml", "xml")
  compare <- if (ext %in% text_extensions) {
    testthat::compare_file_text
  } else if (ext == "rds") {
    compare_rds
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
