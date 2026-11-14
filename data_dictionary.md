# Data dictionary

| Column | SQL type | Meaning | Caveat |
|---|---|---|---|
| defect_id | INT PRIMARY KEY | Unique defect record ID | Not a product ID |
| product_id | INT | Product identifier | Can repeat across defect records |
| defect_type | VARCHAR(40) | Defect category | Observed: Cosmetic, Functional, Structural |
| defect_date | DATE | Recorded defect date | Original CSV uses M/D/YYYY; SQL uses YYYY-MM-DD |
| defect_location | VARCHAR(40) | Location on the product | Not a geographic location |
| severity | VARCHAR(20) | Severity classification | Minor, Moderate, Critical |
| inspection_method | VARCHAR(50) | Method associated with record | Does not measure method sensitivity |
| repair_cost | DECIMAL(10,2) | Recorded repair expense | Currency unspecified |

**Grain:** One row per defect record. Source: supplied `defects_data.csv` and [Kaggle dataset page](https://www.kaggle.com/datasets/fahmidachowdhury/manufacturing-defects). No external production denominator is supplied.
