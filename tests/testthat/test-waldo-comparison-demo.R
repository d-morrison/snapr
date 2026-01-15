# Demonstration: Verifying waldo::compare produces human-readable output
#
# This file demonstrates how to verify that expect_snapshot_object() with
# RDS files uses waldo::compare and produces human-readable output when
# snapshots differ.
#
# STEPS TO VERIFY HUMAN-READABLE OUTPUT:
# =======================================
#
# 1. Run the test below to create the initial snapshot:
#    testthat::test_file("tests/testthat/test-waldo-comparison-demo.R")
#
# 2. Modify the test by changing the mean value (e.g., from 5 to 7):
#    result <- t.test(rnorm(10, mean = 7))  # changed from 5
#
# 3. Run the test again - it will fail showing waldo's comparison in console:
#    testthat::test_file("tests/testthat/test-waldo-comparison-demo.R")
#
#    The console output will show waldo's field-by-field comparison.
#    A *.waldo_diff.txt file will also be created with the comparison output.
#
# 4. Note: testthat::snapshot_review() shows RDS file content (binary),
#    not the comparison. To see the waldo comparison:
#    - Check the console output when tests fail
#    - Look for the *.waldo_diff.txt file created alongside the snapshot
#
# EXPECTED OUTPUT IN CONSOLE:
# ============================
# When the snapshot differs, you'll see output like:
#
#   Snapshot mismatch detected. Waldo comparison:
#   `old$statistic` is a double vector (5.123)
#   `new$statistic` is a double vector (7.456)
#
#   `old$p.value` is a double vector (0.001)
#   `new$p.value` is a double vector (0.0001)
#
#   Diff also saved to: demo_htest.waldo_diff.txt
#
# This is much more informative than binary comparison which would only
# report "files differ" without showing what actually changed.

test_that("htest snapshot demonstrates waldo human-readable output", {
  # Create a reproducible t-test result
  withr::local_seed(123)
  result <- t.test(rnorm(10, mean = 5))
  
  # Snapshot using RDS format (uses waldo::compare via compare_rds)
  expect_snapshot_object(
    result,
    name = "demo_htest",
    variant = platform_variant()
  )
  
  # To see waldo's output:
  # 1. Change the mean above (e.g., to 7)
  # 2. Re-run this test
  # 3. Check console output for detailed, field-by-field comparison
  # 4. Check for *.waldo_diff.txt file with the waldo comparison
})
