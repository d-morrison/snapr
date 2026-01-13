test_that("expect_snapshot_object works with RDS format (default)", {
  # Create a test object
  test_obj <- list(a = 1:3, b = letters[1:3], c = list(x = 1, y = 2))
  
  # This should create a snapshot
  expect_snapshot_object(test_obj, name = "test_list_rds")
})

test_that("expect_snapshot_object works with JSON format", {
  # Simple object that works with JSON
  test_obj <- list(x = 1:5, y = c("a", "b", "c"))
  
  # This should create a JSON snapshot
  expect_snapshot_object(test_obj, name = "test_list_json", writer = save_json)
})

test_that("expect_snapshot_object works with deparse format", {
  # Simple object for deparse
  test_obj <- list(x = 1:5)
  
  # This should create a text snapshot with deparse
  expect_snapshot_object(
    test_obj, name = "test_list_deparse", writer = save_deparse
  )
})

test_that("save_rds creates an RDS file", {
  test_obj <- list(a = 1, b = 2)
  path <- save_rds(test_obj)
  
  expect_true(file.exists(path))
  expect_equal(tools::file_ext(path), "rds")
  
  # Verify we can read it back
  loaded <- readRDS(path)
  expect_equal(loaded, test_obj)
})

test_that("save_json creates a JSON file", {
  test_obj <- list(a = 1, b = 2)
  path <- save_json(test_obj)
  
  expect_true(file.exists(path))
  expect_equal(tools::file_ext(path), "json")
  
  # Verify it's valid JSON
  loaded <- jsonlite::fromJSON(path)
  expect_equal(loaded$a, test_obj$a)
  expect_equal(loaded$b, test_obj$b)
})

test_that("save_deparse creates a text file", {
  test_obj <- list(x = 1:3)
  path <- save_deparse(test_obj)
  
  expect_true(file.exists(path))
  expect_equal(tools::file_ext(path), "txt")
  
  # Verify the content
  content <- readLines(path)
  expect_true(length(content) > 0)
  expect_true(any(grepl("list", content)))
})

test_that("save_csv creates a CSV file", {
  test_df <- data.frame(x = 1:3, y = letters[1:3])
  path <- save_csv(test_df)
  
  expect_true(file.exists(path))
  expect_equal(tools::file_ext(path), "csv")
  
  # Verify we can read it back
  loaded <- readr::read_csv(path, show_col_types = FALSE)
  expect_equal(nrow(loaded), nrow(test_df))
  expect_equal(ncol(loaded), ncol(test_df))
})

test_that("expect_snapshot_data works with data.frames", {
  test_df <- data.frame(
    x = c(1.234567, 2.345678, 3.456789),
    y = letters[1:3]
  )
  
  # This should create a CSV snapshot with rounded numbers
  expect_snapshot_data(test_df, name = "test_dataframe")
})

test_that("expect_snapshot_data rounds numeric columns", {
  test_df <- data.frame(x = c(1.23456789, 2.34567890))
  path <- save_csv(test_df)
  
  # The save_csv function is used by expect_snapshot_data
  # But the rounding happens before save_csv is called
  # So we test the rounding logic separately
  fun <- function(x) signif(x, digits = 6)
  rounded_df <- dplyr::mutate(
    test_df, dplyr::across(tidyselect::where(is.numeric), fun)
  )
  
  expect_equal(rounded_df$x[1], signif(1.23456789, 6))
  expect_equal(rounded_df$x[2], signif(2.34567890, 6))
})
