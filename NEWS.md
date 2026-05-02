# snapr 0.1.0

* Initial release.
* `expect_snapshot_data()`: snapshot testing for data frames (saves as CSV).
* `expect_snapshot_object()`: snapshot testing for any R object (RDS, JSON, deparse, or CSV formats).
* `compare_file_object()`: compare RDS files by deserializing and comparing the underlying R objects.
* `save_rds()`, `save_json()`, `save_deparse()`, `save_csv()`: writer helpers for `expect_snapshot_object()`.
* `system_os()`, `darwin_variant()`, `platform_variant()`: helper functions for creating platform-specific snapshot variants.
