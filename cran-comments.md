## R CMD check results

0 errors | 0 warnings | 1 note

* checking CRAN incoming feasibility ... NOTE
  New submission

  The note also flagged the CRAN check-results URL in README.md as
  "(possibly) invalid"; this URL only becomes valid once snapr is
  accepted to CRAN and will resolve after publication.

## Test environments

* local: macOS Sequoia 15.7.4, R 4.6.0
* GitHub Actions: Ubuntu (release, devel, oldrel-1), macOS (release), Windows (release)
* win-builder: R-devel

## Resubmission notes

This is a resubmission of the first CRAN submission of snapr, addressing
reviewer feedback from the prior round and a check failure that was
introduced while addressing that feedback:

* Removed redundant "for R" from Title and Description fields.
* Replaced `\dontrun{}` with `\donttest{}` in examples for
  `expect_snapshot_data()` and `expect_snapshot_object()`, and wrapped
  those examples in `testthat::test_that()` with
  `testthat::local_edition(3)` so they run cleanly under
  `R CMD check --run-donttest` (they otherwise require a testthat
  snapshotter context). Unwrapped examples for `compare_file_object()`,
  `system_os()`, `darwin_variant()`, and `platform_variant()`, which are
  fully executable.
* Added `Depends: R (>= 4.1.0)` to DESCRIPTION because the package
  source uses the native pipe (`|>`).
* No academic references describe the methods in this package; the
  package provides testing infrastructure utilities.

## Reverse dependencies

There are no reverse dependencies on CRAN.
