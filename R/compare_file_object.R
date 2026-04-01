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
#' @param print [logical] whether to print [waldo::compare] output to R console;
#' can become very long for complex objects like [lm]s
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
compare_file_object <- function(old, new, print = FALSE) {
  # Load the RDS files
  old_obj <- readRDS(old)
  new_obj <- readRDS(new)
  # Compare using identical - compares the deserialized objects
  # rather than raw bytes, which is more meaningful for R objects
  # This allows testthat's snapshot_review to properly detect changes
  # in the actual data structure rather than serialization differences
  comparison <- waldo::compare(
    old_obj,
    new_obj,
    x_arg = "actual",
    y_arg = "expected"
  )
  identical <- length(comparison) == 0 # c.f., `testthat:::expect_waldo_equal_`
  if (!identical && print) {
    c("\nDifferences:", comparison) |>
      paste(collapse = "\n") |>
      cat()
  }
  return(identical)
}
