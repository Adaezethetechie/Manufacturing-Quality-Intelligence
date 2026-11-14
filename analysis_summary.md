# Findings and business interpretation

## Dataset-verified results

- **1,000** defect records across **100** unique product identifiers.
- Date coverage: **2024-01-01** to **2024-06-30**.
- Total recorded repair cost: **507,627.15** (currency not provided).
- Mean repair cost per recorded defect: **507.63**.
- Largest repair-cost contribution by defect type: **Structural**, totaling **176,923.85**.
- Most recorded defects in a month: **2024-01** (191 records).
- Product with highest cumulative repair cost: **Product 81**, totaling **11,740.64** across **20** recorded defects.
- Inspection method associated with most recorded defect rows: **Manual Testing** (352 records). This does **not** establish inspection effectiveness.

## Recommendations

1. Review repair-cost drivers for **Structural** defects and assess whether process or material improvements are warranted.
2. Investigate the history of **Product 81** to determine whether the observed repair burden is caused by repeated issues or a small number of expensive cases.
3. Review changes around **2024-01** using production schedules, process logs, and manufacturing volume before attributing the increase to deteriorating quality.
4. Collect total production units, number of inspections, inspection pass/fail results, and product metadata to enable defensible defect-rate and inspection-performance metrics.

## Interpretation caveats

This is a defect-record dataset, not a census of all manufactured units. Counts are recorded defect events, not necessarily unique defective products. The dataset does not establish inspection detection effectiveness, a true manufacturing defect rate, root causes, or a currency. Findings are descriptive, not causal. Figures were independently reproduced from the supplied CSV with Python and should be cross-checked against MySQL output.
