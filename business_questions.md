# Business questions and SQL techniques

1. Overall volume and total repair cost — `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`.
2. Most frequent and expensive defect types — `GROUP BY`, proportions, `ORDER BY`.
3. Severity distribution and repair costs — `CASE`, conditional aggregation.
4. Defect locations ranked by repair costs — `DENSE_RANK`.
5. Inspection-method comparison among recorded defects — grouped measures; **not** detection effectiveness.
6. Month-by-month defect and repair-cost changes — `DATE_FORMAT`, CTE, `LAG`.
7. Top ten products by repair costs — CTE, `DENSE_RANK`, `LIMIT`.
8. Defect type × severity cost contribution — multicolumn grouping, window totals.
9. High-cost repair cases relative to peers — partitioned window `AVG` and illustrative threshold.
10. Products with recurring defect records vs product-level mean — `COUNT`, CTE, window `AVG`.

Run `sql/03_business_analysis.sql` to reproduce these analyses.
