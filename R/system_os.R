#' Get the current operating system
#'
#' @description
#' Returns the name of the current operating system in lowercase.
#' This is a simple wrapper around `Sys.info()[["sysname"]]`.
#'
#' @details
#' This function is used with testthat's `variant` parameter in
#' [testthat::expect_snapshot_file()] to create OS-specific snapshots
#' when file formats produce different output across platforms.
#'
#' Common use cases:
#' - RDS files: Binary serialization format that can differ across OS
#' - Platform-specific numeric computations (e.g., MCMC algorithms)
#' - Files with platform-specific line endings or encodings
#'
#' @returns A character string: "linux", "darwin" (macOS), or "windows"
#' @export
#' @examples
#' \dontrun{
#' # Use with expect_snapshot_file for OS-specific snapshots
#' expect_snapshot_object(my_object, name = "test", variant = system_os())
#' }
system_os <- function() {
  tolower(Sys.info()[["sysname"]])
}

#' Get darwin snapshot variant for macOS
#'
#' @description
#' Returns "darwin" for macOS, NULL for other platforms (Linux/Windows).
#'
#' @details
#' This is a specialized variant function for cases where only macOS
#' produces different results while Linux and Windows are identical.
#' Use this instead of [system_os()] when:
#' - macOS produces unique output (e.g., platform-specific math libraries)
#' - Linux and Windows produce identical results
#' - You want to maintain a single snapshot for Linux/Windows
#'
#' Common use cases:
#' - JAGS MCMC output (macOS uses different floating-point arithmetic)
#' - Platform-specific numerical computations
#'
#' @returns "darwin" on macOS, NULL on other platforms
#' @export
#' @examples
#' \dontrun{
#' # Use with expect_snapshot_file when only macOS differs
#' expect_snapshot_object(
#'   mcmc_result, name = "test", variant = darwin_variant()
#' )
#' }
darwin_variant <- function() {
  if (system_os() == "darwin") "darwin" else NULL
}

#' Get platform variant including OS and R version
#'
#' @description
#' Returns a variant string combining OS and R major.minor version.
#' This is useful for RDS snapshots that vary by both platform and R version.
#'
#' @details
#' RDS files can produce different binary output across R versions even when
#' using the same serialization version. This function creates variant strings
#' like "linux-4.4", "darwin-4.5", "windows-4.4" to handle these differences.
#'
#' Use this function with [testthat::expect_snapshot_file()] when testing
#' RDS files or other formats that vary by both OS and R version.
#'
#' @returns A character string like "linux-4.4", "darwin-4.5", or
#'   "windows-4.4"
#' @export
#' @examples
#' \dontrun{
#' # Use with expect_snapshot_file for RDS snapshots
#' expect_snapshot_object(
#'   my_object, name = "test", variant = platform_variant()
#' )
#' }
platform_variant <- function() {
  # Get R version as major.minor (e.g., "4.4" for R 4.4.3)
  # Patch versions shouldn't affect RDS serialization
  r_ver <- getRversion()
  r_version <- paste(r_ver$major, r_ver$minor, sep = ".")
  paste0(system_os(), "-", r_version)
}
