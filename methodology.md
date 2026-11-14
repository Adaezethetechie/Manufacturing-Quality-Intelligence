# Methodology

1. **Source and grain:** supplied manufacturing defect CSV; one row per defect record.
2. **Schema:** `defect_id` primary key, typed date, nonnegative `repair_cost` constraint.
3. **Loading:** explicit SQL `INSERT` statements generated from CSV; no import wizard required.
4. **Validation:** compare row count, unique IDs, categories, date bounds, missingness, and cost totals.
5. **Analysis:** aggregate by defect type, severity, location, method, product and month; use window functions for ranking, comparisons and lagged values.
6. **Visualization:** charts created from the supplied CSV as an independent cross-check; verify against MySQL query outputs.
7. **Limitations:** no production denominator, total inspections, repair currency, product metadata, or verified root-cause data.
8. **Reproducibility:** MySQL 8.0.18+ recommended for `EXPLAIN ANALYZE`; run SQL files in numeric order. SQL setup is idempotent only for the table creation, **not** for reinserting the same IDs. For a clean rerun, drop the database first after confirming no important data is stored there.
