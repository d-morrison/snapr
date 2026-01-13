#' Snapshot testing for [data.frame]s
#' @description
#' copied from <https://github.com/bcgov/ssdtools>
#' with permission (<https://github.com/bcgov/ssdtools/issues/379>)
#'
#' @param x a [data.frame] to snapshot
#' @param name [character] snapshot name
#' @param digits [integer] passed to [signif()] for numeric variables
#' @inheritDotParams testthat::expect_snapshot_file -path -name -compare
#' @returns Invisible `NULL` (from [testthat::expect_snapshot_file()])
#' @export
#' @examples
#' \dontrun{
#' expect_snapshot_data(iris, name = "iris")
#' }
expect_snapshot_data <- function(x, name, digits = 6, ...) {
  fun <- function(x) signif(x, digits = digits)
  lapply_fun <- function(x) I(lapply(x, fun))
  x <- dplyr::mutate(x, dplyr::across(tidyselect::where(is.numeric), fun))
  x <- dplyr::mutate(x, dplyr::across(tidyselect::where(is.list), lapply_fun))
  expect_snapshot_object(x, name = name, writer = save_csv, ...)
}

#' Save a data.frame to a CSV file
#' @param x A data.frame to save
#' @returns [character] Path to the temporary CSV file
#' @keywords internal
#' @export
save_csv <- function(x) {
  path <- tempfile(fileext = ".csv")
  readr::write_csv(x, path)
  path
}
